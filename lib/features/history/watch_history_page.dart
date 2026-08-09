import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/common/widgets/app_bubble_dialog.dart';
import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/core/services/episode_history_repository.dart';
import 'package:bears_video/features/player/video_detail.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WatchHistoryPage extends StatefulWidget {
  const WatchHistoryPage({super.key});

  @override
  State<WatchHistoryPage> createState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends State<WatchHistoryPage> {
  final EpisodeHistoryRepository _repository = EpisodeHistoryRepository();
  late Future<List<EpisodeHistory>> _historiesFuture;
  Future<void>? _refreshFuture;

  @override
  void initState() {
    super.initState();
    _historiesFuture = _repository.getAllHistories();
  }

  Future<void> _refresh() {
    final activeRefresh = _refreshFuture;
    if (activeRefresh != null) return activeRefresh;

    final refresh = _repository.getAllHistories().then((histories) {
      if (!mounted) return;
      setState(() {
        _historiesFuture = Future.value(histories);
      });
    });
    _refreshFuture = refresh;
    return refresh.whenComplete(() {
      if (identical(_refreshFuture, refresh)) {
        _refreshFuture = null;
      }
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showAppConfirmationBubble(
      context: context,
      title: '清空观看历史？',
      message: '全部观看记录将被永久删除，此操作无法恢复。',
      cancelLabel: '取消',
      confirmLabel: '确认清空',
      destructive: true,
    );
    if (!confirmed) return;
    await _repository.clearAll();
    if (!mounted) return;
    setState(() {
      _historiesFuture = Future.value(const <EpisodeHistory>[]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox.square(
                dimension: 46,
                child: Center(
                  child: AppVectorIcon(AppVectorIcons.chevronLeft, size: 24),
                ),
              ),
            ),
          ),
        ),
        title: const Text('观看历史', style: TextStyle(fontSize: 16)),
        actions: [
          GestureDetector(
            onTap: _clearHistory,
            child: Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: SvgPicture.string(
                BearsSVG.trashSVG,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<EpisodeHistory>>(
        future: _historiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: AppButton(
                onPressed: _refresh,
                child: const Text('读取失败，点击重试'),
              ),
            );
          }
          final histories = snapshot.data ?? const [];
          if (histories.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Image.asset(
                      'assets/images/empty_history.png',
                      width: 640,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Center(
                    child: Text(
                      '当前还没有历史记录哦',
                      style: TextStyle(fontSize: 18, color: Color(0xFF374151)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      '快去发现喜欢的视频，观看后这里会自动记录~',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: histories.length + 1,
              itemBuilder: (context, index) {
                if (index == histories.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        '没有更多了',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }
                final history = histories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _HistoryTile(
                    history: history,
                    onTap: () => _openHistory(context, history),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openHistory(
    BuildContext context,
    EpisodeHistory history,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoDetailPage(
          videoId: history.videoId,
          initialSourceIndex: history.sourceIndex,
          initialEpisodeIndex: history.episodeIndex,
        ),
      ),
    );
    if (mounted) await _refresh();
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.history, required this.onTap});

  final EpisodeHistory history;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasDuration = history.totalDurationMs > 0;
    final remainingMs = hasDuration
        ? (history.totalDurationMs - history.watchedPositionMs)
              .clamp(0, history.totalDurationMs)
              .toInt()
        : 0;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 142 * 0.90,
              height: 82 * 0.90,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  history.videoPoster.isEmpty
                      ? const ColoredBox(
                          color: Color(0xFFE8E8E8),
                          child: AppVectorIcon(AppVectorIcons.film),
                        )
                      : CachedNetworkImage(
                          imageUrl: history.videoPoster,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              const ColoredBox(color: Color(0xFFE8E8E8)),
                          errorWidget: (_, _, _) => const ColoredBox(
                            color: Color(0xFFE8E8E8),
                            child: AppVectorIcon(AppVectorIcons.imageOff),
                          ),
                        ),
                  Positioned(
                    right: 7,
                    bottom: 5,
                    child: Text(
                      _formatDuration(history.watchedPositionMs),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        shadows: [Shadow(blurRadius: 3, color: Colors.black)],
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
                  '${history.videoTitle} ${history.episodeLabel}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  hasDuration ? '剩余${_formatDuration(remainingMs)}' : '剩余时间未知',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}
