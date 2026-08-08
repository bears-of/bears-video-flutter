import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/core/services/episode_download_repository.dart';
import 'package:bears_video/features/download/download_episode_history_page.dart';
import 'package:bears_video/features/download/download_formatters.dart';
import 'package:bears_video/features/download/download_manager_provider.dart';
import 'package:bears_video/features/player/video_detail_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadHistoryPage extends HookConsumerWidget {
  const DownloadHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = useMemoized(EpisodeDownloadRepository.new);
    final initialFuture = useMemoized(repository.getAllRecords, [repository]);
    final recordsFuture = useState(initialFuture);
    final activeRefresh = useRef<Future<void>?>(null);
    final isEditing = useState(false);
    final selectedVideoIds = useState(<int>{});

    Future<void> refresh() {
      final currentRefresh = activeRefresh.value;
      if (currentRefresh != null) return currentRefresh;
      final future = repository.getAllRecords().then((records) {
        if (context.mounted) recordsFuture.value = Future.value(records);
      });
      activeRefresh.value = future;
      return future.whenComplete(() {
        if (identical(activeRefresh.value, future)) {
          activeRefresh.value = null;
        }
      });
    }

    void toggleVideo(int videoId) {
      final selection = Set<int>.of(selectedVideoIds.value);
      selection.contains(videoId)
          ? selection.remove(videoId)
          : selection.add(videoId);
      selectedVideoIds.value = selection;
    }

    return FutureBuilder<List<EpisodeDownloadRecord>>(
      future: recordsFuture.value,
      builder: (context, snapshot) {
        final records = snapshot.data ?? const <EpisodeDownloadRecord>[];
        final groupedRecords = <int, List<EpisodeDownloadRecord>>{};
        for (final record in records) {
          groupedRecords.putIfAbsent(record.videoId, () => []).add(record);
        }
        final groups = groupedRecords.values.toList()
          ..sort((left, right) {
            final leftTime = left
                .map((record) => record.downloadedAt)
                .reduce((a, b) => a > b ? a : b);
            final rightTime = right
                .map((record) => record.downloadedAt)
                .reduce((a, b) => a > b ? a : b);
            return rightTime.compareTo(leftTime);
          });
        final allSelected =
            groups.isNotEmpty && selectedVideoIds.value.length == groups.length;

        Future<void> deleteSelected() async {
          final selectedRecords = records
              .where(
                (record) => selectedVideoIds.value.contains(record.videoId),
              )
              .toList();
          await repository.deleteRecords(selectedRecords);
          for (final record in selectedRecords) {
            final key = (
              videoId: record.videoId,
              sourceName: record.sourceName,
              episodeIndex: record.episodeIndex,
            );
            ref.read(downloadManagerProvider.notifier).removeTask(key);
            ref.invalidate(episodeDownloadRecordProvider(key));
          }
          selectedVideoIds.value = <int>{};
          isEditing.value = false;
          await refresh();
        }

        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = _ErrorView(error: snapshot.error, onRetry: refresh);
        } else if (records.isEmpty) {
          body = RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Image.asset(
                    'assets/images/empty_download.png',
                    width: 640,
                  ),
                ),
                const Center(
                  child: Text(
                    '目前还没有下载视频哦',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '快去发现喜欢的视频，下载后就能离线观看啦~',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        } else {
          body = RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final episodes = List<EpisodeDownloadRecord>.of(groups[index])
                  ..sort((a, b) => a.episodeIndex.compareTo(b.episodeIndex));
                final first = episodes.first;
                final totalBytes = episodes.fold<int>(
                  0,
                  (total, episode) => total + episode.fileSizeBytes,
                );
                final selected = selectedVideoIds.value.contains(first.videoId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      if (isEditing.value) {
                        toggleVideo(first.videoId);
                        return;
                      }
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              DownloadEpisodeHistoryPage(records: episodes),
                        ),
                      );
                      if (context.mounted) await refresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          if (isEditing.value) ...[
                            Checkbox(
                              value: selected,
                              onChanged: (_) => toggleVideo(first.videoId),
                              shape: const CircleBorder(),
                            ),
                            const SizedBox(width: 4),
                          ],
                          _DownloadCover(url: first.videoPoster),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  first.videoTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '已缓存${episodes.length}集 | ${formatDownloadSize(totalBytes)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
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
              },
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
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
                      child: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: const Text('我的下载', style: TextStyle(fontSize: 16)),
            actions: [
              AppButton.ghost(
                onPressed: records.isEmpty
                    ? null
                    : () {
                        isEditing.value = !isEditing.value;
                        selectedVideoIds.value = <int>{};
                      },
                child: Text(isEditing.value ? '取消' : '编辑'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: body,
          bottomNavigationBar: isEditing.value && records.isNotEmpty
              ? _EditBottomBar(
                  allSelected: allSelected,
                  canDelete: selectedVideoIds.value.isNotEmpty,
                  selectedCount: selectedVideoIds.value.length,
                  onSelectAll: () {
                    selectedVideoIds.value = allSelected
                        ? <int>{}
                        : groups.map((group) => group.first.videoId).toSet();
                  },
                  onDelete: deleteSelected,
                )
              : null,
        );
      },
    );
  }
}

class _EditBottomBar extends StatelessWidget {
  const _EditBottomBar({
    required this.allSelected,
    required this.canDelete,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onDelete,
  });

  final bool allSelected;
  final bool canDelete;
  final int selectedCount;
  final VoidCallback onSelectAll;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1),
            SizedBox(
              height: 58,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.ghost(
                      expand: true,
                      onPressed: onSelectAll,
                      child: Text(allSelected ? '取消全选' : '全选'),
                    ),
                  ),
                  Expanded(
                    child: AppButton.danger(
                      compact: true,
                      expand: true,
                      onPressed: canDelete ? onDelete : null,
                      child: Text('删除($selectedCount)'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadCover extends StatelessWidget {
  const _DownloadCover({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 142 * 0.90,
        height: 82 * 0.90,
        child: url.isEmpty
            ? const ColoredBox(
                color: Color(0xFFE8E8E8),
                child: Icon(Icons.movie_outlined),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    const ColoredBox(color: Color(0xFFE8E8E8)),
                errorWidget: (_, _, _) => const ColoredBox(
                  color: Color(0xFFE8E8E8),
                  child: Icon(Icons.broken_image_outlined),
                ),
              ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('读取下载历史失败：$error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}
