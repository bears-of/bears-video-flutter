import 'dart:async';

import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/common/widgets/app_text_field.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/features/player/video_detail.dart';
import 'package:bears_video/features/search/search_providers.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:bears_video/src/rust/models/search_result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _SearchType {
  const _SearchType(this.label, this.typeId);

  final String label;
  final int? typeId;
}

const _searchTypes = <_SearchType>[
  _SearchType('全部', null),
  _SearchType('电影', 1),
  _SearchType('电视剧', 2),
  _SearchType('综艺', 3),
  _SearchType('动漫', 4),
  _SearchType('纪录', 5),
  _SearchType('少儿', 208),
];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  List<String> _history = const [];
  List<SearchVodItem> _results = const [];
  String? _submittedQuery;
  Object? _error;
  int _selectedTypeIndex = 0;
  int _nextPage = 1;
  int _requestGeneration = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
    _scrollController.addListener(_onScroll);
    unawaited(_loadHistory());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onQueryChanged)
      ..dispose();
    _focusNode.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 400) {
      unawaited(_loadNextPage());
    }
  }

  Future<void> _loadHistory() async {
    try {
      final history = await ref
          .read(searchHistoryRepositoryProvider)
          .getRecent();
      if (mounted) setState(() => _history = history);
    } catch (error) {
      debugPrint('读取搜索历史失败: $error');
    }
  }

  Future<void> _clearHistory() async {
    await ref.read(searchHistoryRepositoryProvider).clear();
    if (mounted) setState(() => _history = const []);
  }

  void _submitSearch([String? keyword]) {
    final query = (keyword ?? _searchController.text).trim();
    if (query.isEmpty) return;
    if (_searchController.text != query) {
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }
    _focusNode.unfocus();
    setState(() {
      _submittedQuery = query;
      _selectedTypeIndex = 0;
    });
    unawaited(() async {
      try {
        await ref.read(searchHistoryRepositoryProvider).save(query);
        await _loadHistory();
      } catch (error) {
        debugPrint('保存搜索历史失败: $error');
      }
    }());
    _restartSearch(refresh: true);
  }

  void _selectType(int index) {
    if (_selectedTypeIndex == index) return;
    setState(() => _selectedTypeIndex = index);
    _restartSearch();
  }

  void _restartSearch({bool refresh = false}) {
    _requestGeneration++;
    setState(() {
      _results = const [];
      _error = null;
      _nextPage = 1;
      _hasMore = true;
      _isLoading = false;
    });
    unawaited(_loadNextPage(refresh: refresh));
  }

  Future<void> _loadNextPage({bool refresh = false}) async {
    final query = _submittedQuery;
    if (query == null || _isLoading || !_hasMore) return;
    final generation = _requestGeneration;
    final page = _nextPage;
    final typeId = _searchTypes[_selectedTypeIndex].typeId;
    final request = SearchRequest(
      pg: BigInt.from(page),
      tid: typeId == null ? null : BigInt.from(typeId),
      text: query,
      token: '',
    );

    setState(() {
      _isLoading = true;
      _error = null;
    });
    if (refresh) ref.invalidate(searchVodListProvider(request));

    try {
      final nextItems = await ref.read(searchVodListProvider(request).future);
      if (!mounted || generation != _requestGeneration) return;
      if (nextItems.isEmpty) {
        setState(() => _hasMore = false);
        return;
      }
      final knownIds = _results.map((item) => item.vodId).toSet();
      final uniqueItems = nextItems
          .where((item) => knownIds.add(item.vodId))
          .toList();
      setState(() {
        _results = [..._results, ...uniqueItems];
        _nextPage = page + 1;
      });
    } catch (error) {
      if (mounted && generation == _requestGeneration) {
        setState(() => _error = error);
      }
    } finally {
      if (mounted && generation == _requestGeneration) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SearchHeader(
              controller: _searchController,
              focusNode: _focusNode,
              submitted: _submittedQuery != null,
              onBack: () => Navigator.of(context).pop(),
              onClear: () {
                setState(() {
                  _submittedQuery = null;
                  _selectedTypeIndex = 0;
                });
                _searchController.clear();
              },
              onSubmitted: _submitSearch,
              onAction: () {
                if (_searchController.text.trim().isEmpty &&
                    _submittedQuery == null) {
                  Navigator.of(context).pop();
                } else {
                  _submitSearch();
                }
              },
            ),
            Expanded(
              child: _submittedQuery == null
                  ? _SearchHistory(
                      history: _history,
                      onClear: _clearHistory,
                      onSelected: _submitSearch,
                    )
                  : _SearchResults(
                      controller: _scrollController,
                      results: _results,
                      selectedTypeIndex: _selectedTypeIndex,
                      isLoading: _isLoading,
                      hasMore: _hasMore,
                      error: _error,
                      onTypeSelected: _selectType,
                      onRetry: () => _loadNextPage(refresh: true),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.submitted,
    required this.onBack,
    required this.onClear,
    required this.onSubmitted,
    required this.onAction,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool submitted;
  final VoidCallback onBack;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 12, 10, 12),
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppTextField(
                style: const TextStyle(fontSize: 13),
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                maxLength: 20,
                textInputAction: TextInputAction.search,
                onSubmitted: onSubmitted,
                hintText: '搜索视频，电影，直播',
                prefixIcon: const Icon(Icons.search_sharp, size: 18),
                suffixIcon: hasText
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onClear,
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: Icon(
                                Icons.cancel_rounded,
                                color: AppColors.inkMuted,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: onAction,
              child: Text(
                hasText || submitted ? '搜索' : '取消',
                style: const TextStyle(fontSize: 14, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHistory extends StatelessWidget {
  const _SearchHistory({
    required this.history,
    required this.onClear,
    required this.onSelected,
  });

  final List<String> history;
  final VoidCallback onClear;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 20),
      children: [
        Row(
          children: [
            const Text(
              '历史记录',
              style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
            ),
            const Spacer(),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: history.isEmpty ? null : onClear,
                customBorder: const CircleBorder(),
                mouseCursor: history.isEmpty
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Opacity(
                      opacity: history.isEmpty ? 0.38 : 1.0,
                      child: SvgPicture.string(
                        BearsSVG.trashSVG,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: history
              .map(
                (keyword) => GestureDetector(
                  onTap: () => onSelected(keyword),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        keyword,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.controller,
    required this.results,
    required this.selectedTypeIndex,
    required this.isLoading,
    required this.hasMore,
    required this.error,
    required this.onTypeSelected,
    required this.onRetry,
  });

  final ScrollController controller;
  final List<SearchVodItem> results;
  final int selectedTypeIndex;
  final bool isLoading;
  final bool hasMore;
  final Object? error;
  final ValueChanged<int> onTypeSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _searchTypes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = index == selectedTypeIndex;
                return GestureDetector(
                  onTap: () => onTypeSelected(index),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                        fontSize: selected ? 18 : 15,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: selected
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      child: Text(_searchTypes[index].label),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (results.isEmpty && isLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (results.isEmpty && error != null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('搜索失败，请稍后重试'),
                  const SizedBox(height: 8),
                  AppButton.ghost(
                    onPressed: onRetry,
                    child: const Text('重新加载'),
                  ),
                ],
              ),
            ),
          )
        else if (results.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('没有找到相关内容')),
          )
        else
          SliverList.builder(
            itemCount: results.length,
            itemBuilder: (context, index) => _SearchResultCard(
              key: ValueKey(results[index].vodId),
              item: results[index],
            ),
          ),
        if (results.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: isLoading
                    ? const SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : error != null
                    ? AppButton.ghost(
                        onPressed: onRetry,
                        child: const Text('加载失败，点击重试'),
                      )
                    : !hasMore
                    ? const Text(
                        '没有更多了',
                        style: TextStyle(color: Color(0xFFBDBDBD)),
                      )
                    : const SizedBox(height: 24),
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({super.key, required this.item});

  final SearchVodItem item;

  @override
  Widget build(BuildContext context) {
    final actors = item.vodActor
        .split(RegExp(r'[,，、/]+'))
        .map((actor) => actor.trim())
        .where((actor) => actor.isNotEmpty)
        .take(5)
        .toList();
    final metadata = [
      if (item.vodYear.isNotEmpty && item.vodYear != '0') item.vodYear,
      _typeLabel(item.typeId),
      if (item.vodArea.isNotEmpty) item.vodArea,
      if (item.vodLang.isNotEmpty) item.vodLang,
    ].where((value) => value.isNotEmpty).join(' / ');

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VideoDetailPage(videoId: item.vodId.toInt()),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 18, 2),
        child: SizedBox(
          height: 142 * 0.65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 96 * 0.7,
                  height: 142 * 0.65,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _SearchPosterImage(url: item.vodPic),
                      if (item.vodRemarks.isNotEmpty)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black54],
                              ),
                            ),
                            child: Text(
                              item.vodRemarks,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.vodName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      metadata,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (actors.isNotEmpty)
                      SizedBox(
                        height: 24,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: actors.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 6),
                          itemBuilder: (context, index) => Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              actors[index],
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8A8A8A),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(int typeId) {
    for (final type in _searchTypes) {
      if (type.typeId == typeId) return type.label;
    }
    return '';
  }
}

class _SearchPosterImage extends StatelessWidget {
  const _SearchPosterImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final value = url.trim().replaceAll('&amp;', '&');
    final normalized = value.startsWith('//') ? 'https:$value' : value;
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return const ColoredBox(
        color: Color(0xFFF2F2F2),
        child: Icon(Icons.broken_image_outlined, color: Colors.grey),
      );
    }
    final cacheWidth = (96 * MediaQuery.devicePixelRatioOf(context)).round();
    return CachedNetworkImage(
      imageUrl: uri.toString(),
      fit: BoxFit.cover,
      memCacheWidth: cacheWidth,
      maxWidthDiskCache: cacheWidth,
      fadeInDuration: const Duration(milliseconds: 120),
      placeholder: (_, _) => const ColoredBox(color: Color(0xFFF2F2F2)),
      errorWidget: (_, _, _) => const ColoredBox(
        color: Color(0xFFF2F2F2),
        child: Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }
}
