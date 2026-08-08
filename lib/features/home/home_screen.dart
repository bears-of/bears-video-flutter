import 'dart:async';

import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/common/widgets/app_text_field.dart';
import 'package:bears_video/features/home/home_providers.dart';
import 'package:bears_video/features/download/download_history_page.dart';
import 'package:bears_video/features/home/home_channel_navigation.dart';
import 'package:bears_video/features/history/watch_history_page.dart';
import 'package:bears_video/features/player/video_detail.dart';
import 'package:bears_video/features/search/search_page.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:bears_video/core/ui/responsive_layout.dart';
import 'package:bears_video/src/rust/models/recommend_video.dart';
import 'package:bears_video/src/rust/models/video_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _homeEntranceDuration = Duration(milliseconds: 560);
const _motionQuickDuration = Duration(milliseconds: 140);
const _motionStandardDuration = Duration(milliseconds: 240);
const _motionCurve = Curves.easeOutCubic;

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChannel = useState(0);
    final searchEditingController = useTextEditingController();
    final channelPageController = usePageController();
    final channelBarController = useScrollController();
    final entranceController = useAnimationController(
      duration: _homeEntranceDuration,
    );
    final homeRecommend = ref.watch(homeRecommendProvider);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    useEffect(() {
      if (disableAnimations) {
        entranceController.value = 1;
      } else {
        entranceController.forward(from: 0);
      }
      return null;
    }, [disableAnimations]);

    // 使用 useRef 保存上一次成功的数据
    final previousData = useRef<HomeRecommendData?>(null);

    // 当有新数据时，更新缓存
    if (homeRecommend.hasValue) {
      previousData.value = homeRecommend.value;
    }

    // 优先取当前数据，若为 loading 则取缓存数据
    final data = homeRecommend.valueOrNull ?? previousData.value;

    void selectChannel(int index) {
      selectedChannel.value = index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!channelBarController.hasClients) return;
        final position = channelBarController.position;
        final target = (index * 82.0 - position.viewportDimension / 2 + 41)
            .clamp(0.0, position.maxScrollExtent)
            .toDouble();
        channelBarController.animateTo(
          target,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      });
    }

    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: ResponsiveLayout.pagePadding(context),
        child: ResponsiveContent(
          maxWidth: 1440,
          child: Column(
            children: [
              _HomeEntranceTransition(
                animation: entranceController,
                interval: const Interval(0, 0.48, curve: _motionCurve),
                beginOffset: const Offset(0, -0.10),
                disableAnimations: disableAnimations,
                child: _SearchBar(
                  searchEditingController: searchEditingController,
                ),
              ),
              _HomeEntranceTransition(
                animation: entranceController,
                interval: const Interval(0.10, 0.62, curve: _motionCurve),
                beginOffset: const Offset(-0.025, 0),
                disableAnimations: disableAnimations,
                child: _ChannelBar(
                  controller: channelBarController,
                  selectedIndex: selectedChannel.value,
                  disableAnimations: disableAnimations,
                  onSelected: (index) {
                    final currentIndex = selectedChannel.value;
                    selectChannel(index);
                    unawaited(
                      navigateToHomeChannel(
                        controller: channelPageController,
                        currentIndex: currentIndex,
                        targetIndex: index,
                        disableAnimations: disableAnimations,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _HomeEntranceTransition(
                  animation: entranceController,
                  interval: const Interval(0.22, 1, curve: _motionCurve),
                  beginOffset: const Offset(0, 0.018),
                  beginScale: 0.992,
                  disableAnimations: disableAnimations,
                  child: PageView.builder(
                    controller: channelPageController,
                    itemCount: _homeChannels.length,
                    onPageChanged: selectChannel,
                    itemBuilder: (context, index) {
                      final Widget page;
                      if (index == 0) {
                        page = data == null
                            ? const Center(child: CircularProgressIndicator())
                            : HomeRecommendView(
                                homeRecommendData: data,
                                isActive: selectedChannel.value == 0,
                              );
                      } else {
                        final channel = _homeChannels[index];
                        page = _ChannelVideoView(
                          key: ValueKey(channel.typeId),
                          typeId: channel.typeId!,
                          filterGroups: channel.filterGroups,
                        );
                      }
                      return _ChannelPageTransition(
                        controller: channelPageController,
                        pageIndex: index,
                        disableAnimations: disableAnimations,
                        child: page,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeEntranceTransition extends StatelessWidget {
  const _HomeEntranceTransition({
    required this.animation,
    required this.interval,
    required this.beginOffset,
    required this.disableAnimations,
    required this.child,
    this.beginScale = 1,
  });

  final Animation<double> animation;
  final Interval interval;
  final Offset beginOffset;
  final double beginScale;
  final bool disableAnimations;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (disableAnimations) return child;
    final progress = CurvedAnimation(parent: animation, curve: interval);
    final translated = SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(progress),
      child: child,
    );
    return FadeTransition(
      opacity: progress,
      child: beginScale == 1
          ? translated
          : ScaleTransition(
              scale: Tween<double>(begin: beginScale, end: 1).animate(progress),
              child: translated,
            ),
    );
  }
}

class _ChannelPageTransition extends StatelessWidget {
  const _ChannelPageTransition({
    required this.controller,
    required this.pageIndex,
    required this.disableAnimations,
    required this.child,
  });

  final PageController controller;
  final int pageIndex;
  final bool disableAnimations;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (disableAnimations) return child;
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        var page = controller.initialPage.toDouble();
        if (controller.hasClients && controller.position.hasContentDimensions) {
          page = controller.page ?? page;
        }
        final distance = (page - pageIndex).abs().clamp(0.0, 1.0);
        final opacity = 1 - distance * 0.22;
        final scale = 1 - distance * 0.018;
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}

class _HomeChannel {
  const _HomeChannel(this.label, this.typeId, {this.filterGroups = const []});

  final String label;
  final int? typeId;
  final List<List<String>> filterGroups;
}

const sortOptions = ['最新', '最热', '好评'];
const yearOptions = [
  '全部',
  '2026',
  '2025',
  '2024',
  '2023',
  '2022',
  '2021',
  '2020',
  '2019',
  '2018',
  '2017',
  '2016',
  '2015',
  '2014',
  '2013',
  '2012',
  '2011',
  '2010',
  '2009',
  '2008',
  '2007',
  '2006',
  '2005',
  '2004',
  '2003',
  '2002',
  '2001',
  '2000',
  '1999',
  '1998',
  '1997',
  '1996',
];

const languageOptions = [
  '全部',
  '国语',
  '英语',
  '粤语',
  '闽南语',
  '韩语',
  '日语',
  '法语',
  '德语',
  '其他',
];

const countryOptons = [
  '全部',
  '大陆',
  '香港',
  '台湾',
  '美国',
  '韩国',
  '日本',
  '法国',
  '英国',
  '德国',
  '泰国',
  '印度',
  '其他',
];
const _movieFilterGroups = <List<String>>[
  sortOptions,
  [
    '全部',
    '喜剧',
    '爱情',
    '恐怖',
    '动作',
    '科幻',
    '剧情',
    '战争',
    '警匪',
    '犯罪',
    '动画',
    '奇幻',
    '武侠',
    '冒险',
    '枪战',
    '悬疑',
    '惊悚',
    '谍战',
    '灾难',
    '经典青春',
    '文艺',
    '微电影',
    '古装',
    '历史',
    '运动',
    '农村',
    '儿童',
    '网络电影',
    '歌舞',
    '传记',
    '纪录',
    '其他',
  ],
  countryOptons,
  languageOptions,
  yearOptions,
];

const _tvFilterGroups = <List<String>>[
  sortOptions,
  [
    '全部',
    '喜剧',
    '古装',
    '家庭',
    '犯罪',
    '动作',
    '奇幻',
    '武侠',
    '爱情',
    '青春',
    '悬疑',
    '科幻',
    '警匪',
    '谍战',
    '商战',
    '偶像',
    '军事',
    '神话',
    '战争',
    '都市',
    '青春偶像',
    '剧情',
    '历史',
    '经典',
    '乡村',
    '情景',
    '网剧',
    '其他',
  ],
  countryOptons,
  languageOptions,
  yearOptions,
];

const _varietyFilterGroups = <List<String>>[
  sortOptions,
  [
    '全部',
    '脱口秀',
    '真人秀',
    '搞笑',
    '访谈',
    '生活',
    '晚会',
    '美食',
    '游戏',
    '亲子',
    '旅游',
    '文化',
    '体育',
    '时尚',
    '纪实',
    '益智',
    '演艺',
    '歌舞',
    '音乐',
    '播报',
    '选秀',
    '情感',
    '播报',
    '旅游',
    '音乐',
    '纪实',
    '曲艺',
    '生活',
    '游戏互动',
    '财经',
    '求职',
  ],
  countryOptons,
  languageOptions,
  yearOptions,
];

const _animeFilterGroups = <List<String>>[
  sortOptions,
  [
    '全部',
    '情感',
    '科幻',
    '热血',
    '推理',
    '搞笑',
    '神魔',
    '真人',
    '青春',
    '魔法',
    '神话',
    '冒险',
    '剧情',
    '历史',
    '萝莉',
    '校园',
    '动作',
    '机动',
    '运动',
    '战争',
    '少年',
    '少女',
    '社会',
    '原创',
    '亲子',
    '益智',
    '励志',
    '格斗',
    '恋爱',
    '美少女',
    'LOLI',
    '竞技',
    '竞技',
    '童话',
    '教育',
    '其他',
  ],
  countryOptons,
  languageOptions,
  yearOptions,
];

const _documentaryFilterGroups = <List<String>>[
  sortOptions,
  ['全部', '人物', '军事', '历史', '自然', '探险', '科技', '文化', '刑侦', '社会', '旅游', '其他'],
  countryOptons,
  languageOptions,
  yearOptions,
];

const _kidsFilterGroups = <List<String>>[
  sortOptions,
  [
    '全部',
    '儿歌',
    '益智',
    '手工·绘画',
    '玩具',
    '搞笑',
    '英语',
    '早教',
    '动画',
    '数学',
    '国学',
    '冒险',
    '交通工具',
    '魔幻·科幻',
    '动物',
    '真人特摄',
    '探索',
    '其他',
  ],
  countryOptons,
  languageOptions,
  yearOptions,
];

const _homeChannels = <_HomeChannel>[
  _HomeChannel('首页', null),
  _HomeChannel('电影', 1, filterGroups: _movieFilterGroups),
  _HomeChannel('电视剧', 2, filterGroups: _tvFilterGroups),
  _HomeChannel('综艺', 3, filterGroups: _varietyFilterGroups),
  _HomeChannel('动漫', 4, filterGroups: _animeFilterGroups),
  _HomeChannel('纪录片', 5, filterGroups: _documentaryFilterGroups),
  _HomeChannel('少儿', 208, filterGroups: _kidsFilterGroups),
];

class _ChannelBar extends StatelessWidget {
  const _ChannelBar({
    required this.controller,
    required this.selectedIndex,
    required this.disableAnimations,
    required this.onSelected,
  });

  final ScrollController controller;
  final int selectedIndex;
  final bool disableAnimations;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _homeChannels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: disableAnimations
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    curve: _motionCurve,
                    style: TextStyle(
                      color: selected
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: selected ? 18 : 15,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                    child: Text(_homeChannels[index].label),
                  ),
                  const SizedBox(height: 2),
                  AnimatedContainer(
                    duration: disableAnimations
                        ? Duration.zero
                        : _motionStandardDuration,
                    curve: _motionCurve,
                    width: selected ? 18 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChannelVideoView extends StatefulWidget {
  const _ChannelVideoView({
    super.key,
    required this.typeId,
    required this.filterGroups,
  });

  final int typeId;
  final List<List<String>> filterGroups;

  @override
  State<_ChannelVideoView> createState() => _ChannelVideoViewState();
}

class _ChannelVideoViewState extends State<_ChannelVideoView>
    with AutomaticKeepAliveClientMixin {
  late List<int> _selectedFilters;
  late List<ScrollController> _filterScrollControllers;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  @override
  void didUpdateWidget(covariant _ChannelVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.filterGroups, widget.filterGroups)) {
      _disposeFilterControllers();
      _initializeFilters();
    }
  }

  void _initializeFilters() {
    _selectedFilters = List<int>.filled(widget.filterGroups.length, 0);
    _filterScrollControllers = List.generate(
      widget.filterGroups.length,
      (_) => ScrollController(),
    );
  }

  void _disposeFilterControllers() {
    for (final controller in _filterScrollControllers) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeFilterControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _PaginatedChannelContent(
      typeId: widget.typeId,
      filterGroups: widget.filterGroups,
      filterScrollControllers: _filterScrollControllers,
      selectedIndexes: _selectedFilters,
      onSelected: (groupIndex, optionIndex) {
        if (_selectedFilters[groupIndex] == optionIndex) return;
        final next = [..._selectedFilters];
        next[groupIndex] = optionIndex;
        setState(() => _selectedFilters = next);
      },
    );
  }
}

class _PaginatedChannelContent extends ConsumerStatefulWidget {
  const _PaginatedChannelContent({
    required this.typeId,
    required this.filterGroups,
    required this.filterScrollControllers,
    required this.selectedIndexes,
    required this.onSelected,
  });

  final int typeId;
  final List<List<String>> filterGroups;
  final List<ScrollController> filterScrollControllers;
  final List<int> selectedIndexes;
  final void Function(int groupIndex, int optionIndex) onSelected;

  @override
  ConsumerState<_PaginatedChannelContent> createState() =>
      _PaginatedChannelContentState();
}

class _PaginatedChannelContentState
    extends ConsumerState<_PaginatedChannelContent> {
  List<VodListItem> _extraItems = const [];
  int _nextPage = 2;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _loadMoreError;
  int _requestGeneration = 0;

  @override
  void didUpdateWidget(covariant _PaginatedChannelContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.typeId != widget.typeId ||
        !listEquals(oldWidget.selectedIndexes, widget.selectedIndexes)) {
      _extraItems = const [];
      _nextPage = 2;
      _isLoadingMore = false;
      _hasMore = true;
      _loadMoreError = null;
      _requestGeneration++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterGroups = widget.filterGroups;
    final selectedIndexes = widget.selectedIndexes;

    String selectedValue(int groupIndex) {
      if (groupIndex >= filterGroups.length ||
          groupIndex >= selectedIndexes.length) {
        return '';
      }
      final options = filterGroups[groupIndex];
      final optionIndex = selectedIndexes[groupIndex];
      if (optionIndex >= options.length) return '';
      final value = options[optionIndex];
      return value == '全部' ? '' : value;
    }

    VideoListRequest requestForPage(int page) {
      return VideoListRequest(
        pg: BigInt.from(page),
        tid: BigInt.from(widget.typeId),
        class_: selectedValue(1),
        area: selectedValue(2),
        lang: selectedValue(3),
        year: selectedValue(4),
        order: selectedValue(0),
        token: '',
      );
    }

    final firstRequest = requestForPage(1);
    final firstPage = ref.watch(homeVideoListProvider(firstRequest));

    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: _ChannelFilters(
          filterGroups: filterGroups,
          scrollControllers: widget.filterScrollControllers,
          selectedIndexes: selectedIndexes,
          onSelected: widget.onSelected,
        ),
      ),
    ];
    VoidCallback? loadMore;

    firstPage.when<void>(
      loading: () {
        slivers.add(
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
      error: (error, _) {
        slivers.add(
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 42),
                  const SizedBox(height: 12),
                  const Text('加载失败，请稍后重试'),
                  const SizedBox(height: 8),
                  AppButton.ghost(
                    onPressed: () =>
                        ref.invalidate(homeVideoListProvider(firstRequest)),
                    child: const Text('重新加载'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      data: (firstItems) {
        final items = [...firstItems, ..._extraItems];

        loadMore = () {
          if (firstItems.isEmpty || _isLoadingMore || !_hasMore) {
            return;
          }
          final generation = _requestGeneration;
          final retrying = _loadMoreError != null;
          setState(() {
            _isLoadingMore = true;
            _loadMoreError = null;
          });
          final page = _nextPage;
          final nextRequest = requestForPage(page);
          if (retrying) {
            ref.invalidate(homeVideoListProvider(nextRequest));
          }
          unawaited(() async {
            try {
              final nextItems = await ref.read(
                homeVideoListProvider(nextRequest).future,
              );
              if (!mounted || generation != _requestGeneration) return;
              if (nextItems.isEmpty) {
                setState(() => _hasMore = false);
                return;
              }
              final knownIds = [
                ...firstItems,
                ..._extraItems,
              ].map((item) => item.vodId).toSet();
              final uniqueItems = nextItems
                  .where((item) => knownIds.add(item.vodId))
                  .toList();
              setState(() {
                _extraItems = [..._extraItems, ...uniqueItems];
                _nextPage = page + 1;
              });
            } catch (error) {
              if (mounted && generation == _requestGeneration) {
                setState(() => _loadMoreError = error);
              }
            } finally {
              if (mounted && generation == _requestGeneration) {
                setState(() => _isLoadingMore = false);
              }
            }
          }());
        };

        if (items.isEmpty) {
          slivers.add(
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('暂无内容')),
            ),
          );
          return;
        }

        slivers
          ..add(
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveLayout.posterColumns(context),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.52,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final video = items[index];
                  return _VideoPosterCard(
                    key: ValueKey(video.vodId),
                    imageUrl: video.vodPic,
                    title: video.vodName,
                    remark: video.vodRemarks,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              VideoDetailPage(videoId: video.vodId.toInt()),
                        ),
                      );
                    },
                  );
                }, childCount: items.length),
              ),
            ),
          )
          ..add(
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 110),
                child: Center(
                  child: _isLoadingMore
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : _loadMoreError != null
                      ? AppButton.ghost(
                          onPressed: loadMore,
                          child: const Text('加载失败，点击重试'),
                        )
                      : !_hasMore
                      ? const Text(
                          '没有更多了',
                          style: TextStyle(color: Colors.grey),
                        )
                      : const SizedBox(height: 24),
                ),
              ),
            ),
          );
      },
    );

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _extraItems = const [];
          _nextPage = 2;
          _isLoadingMore = false;
          _hasMore = true;
          _loadMoreError = null;
          _requestGeneration++;
        });
        ref.invalidate(homeVideoListProvider(firstRequest));
        await ref.read(homeVideoListProvider(firstRequest).future);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 &&
              notification.metrics.axis == Axis.vertical &&
              notification.metrics.extentAfter < 500) {
            loadMore?.call();
          }
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: slivers,
        ),
      ),
    );
  }
}

class _ChannelFilters extends StatelessWidget {
  const _ChannelFilters({
    required this.filterGroups,
    required this.scrollControllers,
    required this.selectedIndexes,
    required this.onSelected,
  });

  final List<List<String>> filterGroups;
  final List<ScrollController> scrollControllers;
  final List<int> selectedIndexes;
  final void Function(int groupIndex, int optionIndex) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 6),
      child: Column(
        children: List.generate(filterGroups.length, (groupIndex) {
          final options = filterGroups[groupIndex];
          return SizedBox(
            height: 38,
            child: ListView.separated(
              controller: scrollControllers[groupIndex],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(width: 2),
              itemBuilder: (context, optionIndex) {
                final selected = selectedIndexes[groupIndex] == optionIndex;
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelected(groupIndex, optionIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      options[optionIndex],
                      style: TextStyle(
                        fontSize: 13,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _VideoPosterCard extends StatefulWidget {
  const _VideoPosterCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.remark,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String remark;
  final VoidCallback onTap;

  @override
  State<_VideoPosterCard> createState() => _VideoPosterCardState();
}

class _VideoPosterCardState extends State<_VideoPosterCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final cacheWidth = (((screenWidth - 40) / 3) * pixelRatio)
        .round()
        .clamp(1, 1024)
        .toInt();
    final duration = disableAnimations ? Duration.zero : _motionQuickDuration;
    final scale = _pressed ? 0.985 : (_hovered ? 1.018 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedScale(
        scale: scale,
        duration: duration,
        curve: _motionCurve,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: duration,
                curve: _motionCurve,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _hovered && !_pressed
                      ? const [
                          BoxShadow(
                            color: Color(0x1A0A5E4A),
                            blurRadius: 16,
                            offset: Offset(0, 7),
                          ),
                        ]
                      : const [],
                ),
                child: Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onHighlightChanged: (value) {
                        if (_pressed == value) return;
                        setState(() => _pressed = value);
                      },
                      onTap: widget.onTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox.expand(
                          child: _SafeNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            cacheWidth: cacheWidth,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                          child: Text(
                            widget.remark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveLayout.isDesktop(context) ? 14 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafeNetworkImage extends StatefulWidget {
  const _SafeNetworkImage({
    required this.imageUrl,
    required this.fit,
    this.cacheWidth,
  });

  final String imageUrl;
  final BoxFit fit;
  final int? cacheWidth;

  @override
  State<_SafeNetworkImage> createState() => _SafeNetworkImageState();
}

class _SafeNetworkImageState extends State<_SafeNetworkImage> {
  String? _url;
  Map<String, String>? _headers;

  @override
  void initState() {
    super.initState();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant _SafeNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) _resolveImage();
  }

  void _resolveImage() {
    var value = widget.imageUrl.trim().replaceAll('&amp;', '&');
    if (value.startsWith('//')) value = 'https:$value';
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      _url = null;
      _headers = null;
      return;
    }
    final path = uri.path.toLowerCase();
    final unsupported =
        path.endsWith('.avif') ||
        path.endsWith('.heic') ||
        path.endsWith('.heif') ||
        path.endsWith('.jxl') ||
        path.endsWith('.svg');
    if (unsupported) {
      _url = null;
      _headers = null;
      return;
    }
    _url = uri.toString();
    _headers = {
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/124.0 Mobile Safari/537.36',
      'Accept': 'image/webp,image/png,image/jpeg,image/gif,image/apng',
      'Referer': uri.origin,
    };
  }

  @override
  Widget build(BuildContext context) {
    final url = _url;
    if (url == null) {
      return const _NetworkImagePlaceholder(showError: true);
    }
    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: _headers,
      fit: widget.fit,
      memCacheWidth: widget.cacheWidth,
      maxWidthDiskCache: widget.cacheWidth,
      fadeInDuration: const Duration(milliseconds: 120),
      placeholderFadeInDuration: Duration.zero,
      placeholder: (_, _) => const _NetworkImagePlaceholder(),
      errorWidget: (_, _, error) {
        debugPrint('图片加载失败: $url ($error)');
        return const _NetworkImagePlaceholder(showError: true);
      },
    );
  }
}

class _NetworkImagePlaceholder extends StatelessWidget {
  const _NetworkImagePlaceholder({this.showError = false});

  final bool showError;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(31, 157, 143, 143),
      child: showError
          ? const Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.grey),
            )
          : null,
    );
  }
}

class HomeRecommendView extends HookConsumerWidget {
  const HomeRecommendView({
    super.key,
    required this.homeRecommendData,
    required this.isActive,
  });

  final HomeRecommendData homeRecommendData;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerPageController = usePageController();
    final currentBannerPageIndex = useValueNotifier<int>(0);
    final bannerAutoPlayController = useAnimationController(
      duration: const Duration(seconds: 5),
    );
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    final banners = homeRecommendData.banners;
    final videoLists = homeRecommendData.videos;

    List<Widget> buildSlivers() {
      final slivers = <Widget>[
        SliverToBoxAdapter(
          child: _BannerView(
            bannerPageController: bannerPageController,
            banners: banners,
            currentBannerPageIndex: currentBannerPageIndex,
            bannerAutoPlayController: bannerAutoPlayController,
            disableAnimations: disableAnimations,
            onBannerTap: (videoId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoDetailPage(videoId: videoId),
                ),
              );
            },
          ),
        ),
      ];

      for (final category in videoLists) {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

        slivers.add(_HomeRecommendItemView(category: category));
      }

      slivers.add(
        SliverToBoxAdapter(
          child: SizedBox(
            // 建议值：76 (仅导航栏内容高度) 或 94 (76+18)
            // 你可以根据视觉微调，数值越小，最后一个卡片被遮挡越多
            height: 98, //+  MediaQuery.of(context).padding.bottom,
          ),
        ),
      );

      return slivers;
    }

    useEffect(() {
      if (disableAnimations || banners.length <= 1) {
        bannerAutoPlayController.stop();
        return null;
      }

      void listener(AnimationStatus status) {
        if (status != AnimationStatus.completed) return;
        if (!bannerPageController.hasClients) return;

        final next = (currentBannerPageIndex.value + 1) % banners.length;
        bannerPageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 420),
          curve: _motionCurve,
        );
      }

      bannerAutoPlayController.addStatusListener(listener);
      if (isActive) {
        bannerAutoPlayController.forward(from: 0);
      } else {
        bannerAutoPlayController.stop();
      }

      return () {
        bannerAutoPlayController.stop();
        bannerAutoPlayController.removeStatusListener(listener);
      };
    }, [banners.length, disableAnimations, isActive]);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeRecommendProvider.notifier).refresh();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: buildSlivers(),
      ),
    );
  }
}

class _HomeRecommendItemView extends StatelessWidget {
  const _HomeRecommendItemView({required this.category});

  final HomeVideoSection category;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final video = category.vlist[index];
          return _VideoPosterCard(
            key: ValueKey(video.vodId),
            imageUrl: video.vodPic,
            title: video.vodName,
            remark: video.vodRemarks,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VideoDetailPage(videoId: video.vodId),
                ),
              );
            },
          );
        }, childCount: category.vlist.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveLayout.posterColumns(context),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.52,
        ),
      ),
    );
  }
}

class _BannerView extends StatelessWidget {
  const _BannerView({
    required this.bannerPageController,
    required this.banners,
    required this.currentBannerPageIndex,
    required this.bannerAutoPlayController,
    required this.disableAnimations,
    this.onBannerTap,
  });

  final PageController bannerPageController;
  final List<BannerItem> banners;
  final ValueNotifier<int> currentBannerPageIndex;
  final AnimationController bannerAutoPlayController;
  final bool disableAnimations;
  final void Function(int videoId)? onBannerTap;

  @override
  Widget build(BuildContext context) {
    // 如果无轮播数据，直接返回空
    if (banners.isEmpty) return const SizedBox.shrink();
    final bannerCacheWidth =
        (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context))
            .round()
            .clamp(1, 2048)
            .toInt();
    final bannerWidth = (MediaQuery.sizeOf(context).width - 24).clamp(
      1.0,
      1080.0,
    );
    final bannerHeight = (bannerWidth / 2.4).clamp(120.0, 450.0).toDouble();

    void openCurrentBanner() {
      final index = currentBannerPageIndex.value;
      if (index >= banners.length) return;
      final videoId = int.tryParse(banners[index].reqContent);
      if (videoId != null) onBannerTap?.call(videoId);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: openCurrentBanner,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: bannerHeight,
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                      controller: bannerPageController,
                      itemCount: banners.length,
                      onPageChanged: (index) {
                        currentBannerPageIndex.value = index;
                        if (!disableAnimations) {
                          bannerAutoPlayController.forward(from: 0);
                        }
                      },

                      itemBuilder: (context, index) {
                        final image = SizedBox.expand(
                          child: _SafeNetworkImage(
                            imageUrl: banners[index].content,
                            fit: BoxFit.cover,
                            cacheWidth: bannerCacheWidth,
                          ),
                        );
                        if (disableAnimations) return image;
                        return AnimatedBuilder(
                          animation: bannerPageController,
                          child: image,
                          builder: (context, child) {
                            var page = currentBannerPageIndex.value.toDouble();
                            if (bannerPageController.hasClients &&
                                bannerPageController
                                    .position
                                    .hasContentDimensions) {
                              page = bannerPageController.page ?? page;
                            }
                            final distance = (page - index).clamp(-1.0, 1.0);
                            final scale = 1 - (distance.abs() * 0.025);
                            return Transform.translate(
                              offset: Offset(distance * -10, 0),
                              child: Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Positioned(
                      left: 15,
                      right: 90,
                      bottom: 15,
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentBannerPageIndex,
                        builder: (context, currentIndex, child) {
                          final index = currentIndex
                              .clamp(0, banners.length - 1)
                              .toInt();
                          final title = Text(
                            banners[index].name,
                            key: ValueKey(banners[index].reqContent),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 4),
                              ],
                            ),
                          );
                          if (disableAnimations) return title;
                          return AnimatedSwitcher(
                            duration: _motionStandardDuration,
                            switchInCurve: _motionCurve,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              final offset = Tween<Offset>(
                                begin: const Offset(0.035, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offset,
                                  child: child,
                                ),
                              );
                            },
                            child: title,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 15,
                      child: RepaintBoundary(
                        child: ValueListenableBuilder<int>(
                          valueListenable: currentBannerPageIndex,
                          builder: (context, currentIndex, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(banners.length, (index) {
                                final selected = currentIndex == index;
                                final duration = disableAnimations
                                    ? Duration.zero
                                    : _motionStandardDuration;
                                return AnimatedScale(
                                  scale: selected ? 1.25 : 1,
                                  duration: duration,
                                  curve: _motionCurve,
                                  child: AnimatedContainer(
                                    duration: duration,
                                    curve: _motionCurve,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: selected ? 18 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.searchEditingController});

  final TextEditingController searchEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AppTextField(
                controller: searchEditingController,
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
                },
                hintText: '搜索视频，电影，直播',
                prefixIcon: const Icon(Icons.search_sharp, size: 18),
              ),
            ),
            const SizedBox(width: 18),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DownloadHistoryPage(),
                    ),
                  );
                },
                customBorder: const CircleBorder(),
                mouseCursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: SvgPicture.string(BearsSVG.fileDownloadSVG),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WatchHistoryPage()),
                  );
                },
                customBorder: const CircleBorder(),
                mouseCursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(child: SvgPicture.string(BearsSVG.historySVG)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
