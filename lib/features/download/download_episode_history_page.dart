import 'dart:convert';

import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/core/services/episode_download_repository.dart';
import 'package:bears_video/features/download/download_formatters.dart';
import 'package:bears_video/features/download/download_manager_provider.dart';
import 'package:bears_video/features/player/video_detail.dart';
import 'package:bears_video/features/player/video_detail_providers.dart';
import 'package:bears_video/src/rust/models/video_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadEpisodeHistoryPage extends HookConsumerWidget {
  const DownloadEpisodeHistoryPage({super.key, required this.records});

  final List<EpisodeDownloadRecord> records;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = useMemoized(EpisodeDownloadRepository.new);
    final initialRecords = useMemoized(
      () =>
          List<EpisodeDownloadRecord>.of(records)
            ..sort((a, b) => a.episodeIndex.compareTo(b.episodeIndex)),
      [records],
    );
    final episodes = useState(initialRecords);
    final isEditing = useState(false);
    final selectedKeys = useState(<String>{});
    final title = episodes.value.isEmpty
        ? '已下载剧集'
        : episodes.value.first.videoTitle;
    final allSelected =
        episodes.value.isNotEmpty &&
        selectedKeys.value.length == episodes.value.length;

    void toggleRecord(EpisodeDownloadRecord record) {
      final selection = Set<String>.of(selectedKeys.value);
      final key = _recordKey(record);
      selection.contains(key) ? selection.remove(key) : selection.add(key);
      selectedKeys.value = selection;
    }

    Future<void> deleteSelected() async {
      final recordsToDelete = episodes.value
          .where((record) => selectedKeys.value.contains(_recordKey(record)))
          .toList();
      await repository.deleteRecords(recordsToDelete);
      for (final record in recordsToDelete) {
        final key = (
          videoId: record.videoId,
          sourceName: record.sourceName,
          episodeIndex: record.episodeIndex,
        );
        ref.read(downloadManagerProvider.notifier).removeTask(key);
        ref.invalidate(episodeDownloadRecordProvider(key));
      }
      final deletedKeys = recordsToDelete.map(_recordKey).toSet();
      episodes.value = episodes.value
          .where((record) => !deletedKeys.contains(_recordKey(record)))
          .toList();
      selectedKeys.value = <String>{};
      isEditing.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title, style: const TextStyle(fontSize: 16)),
        actions: [
          AppButton.ghost(
            onPressed: episodes.value.isEmpty
                ? null
                : () {
                    isEditing.value = !isEditing.value;
                    selectedKeys.value = <String>{};
                  },
            child: Text(isEditing.value ? '取消' : '编辑'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: episodes.value.isEmpty
          ? const Center(child: Text('没有已下载剧集'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: episodes.value.length,
              itemBuilder: (context, index) {
                final record = episodes.value[index];
                final selected = selectedKeys.value.contains(
                  _recordKey(record),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (isEditing.value) {
                        toggleRecord(record);
                      } else {
                        _openDownloadedEpisode(context, record);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          if (isEditing.value) ...[
                            Checkbox(
                              value: selected,
                              onChanged: (_) => toggleRecord(record),
                              shape: const CircleBorder(),
                            ),
                            const SizedBox(width: 4),
                          ],
                          _EpisodeCover(url: record.videoPoster),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${record.videoTitle} ${record.episodeLabel}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${record.sourceName} | ${formatDownloadSize(record.fileSizeBytes)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
      bottomNavigationBar: isEditing.value && episodes.value.isNotEmpty
          ? _EpisodeEditBottomBar(
              allSelected: allSelected,
              canDelete: selectedKeys.value.isNotEmpty,
              selectedCount: selectedKeys.value.length,
              onSelectAll: () {
                selectedKeys.value = allSelected
                    ? <String>{}
                    : episodes.value.map(_recordKey).toSet();
              },
              onDelete: deleteSelected,
            )
          : null,
    );
  }
}

class _EpisodeEditBottomBar extends StatelessWidget {
  const _EpisodeEditBottomBar({
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

void _openDownloadedEpisode(
  BuildContext context,
  EpisodeDownloadRecord record,
) {
  FrontendVideoDetail? cachedDetail;
  if (record.videoDetailJson.isNotEmpty) {
    try {
      cachedDetail = FrontendVideoDetail.fromJson(
        jsonDecode(record.videoDetailJson) as Map<String, dynamic>,
      );
    } catch (_) {}
  }
  final sourceIndex = cachedDetail?.playSources.indexWhere(
    (source) => source.name == record.sourceName,
  );
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => VideoDetailPage(
        videoId: record.videoId,
        initialSourceIndex: sourceIndex != null && sourceIndex >= 0
            ? sourceIndex
            : 0,
        initialEpisodeIndex: record.episodeIndex,
      ),
    ),
  );
}

String _recordKey(EpisodeDownloadRecord record) {
  return '${record.videoId}\u0000${record.sourceName}\u0000${record.episodeIndex}';
}

class _EpisodeCover extends StatelessWidget {
  const _EpisodeCover({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 142 * 0.9,
        height: 82 * 0.9,
        child: url.isEmpty
            ? const ColoredBox(
                color: Color(0xFFE8E8E8),
                child: AppVectorIcon(AppVectorIcons.film),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    const ColoredBox(color: Color(0xFFE8E8E8)),
                errorWidget: (_, _, _) => const ColoredBox(
                  color: Color(0xFFE8E8E8),
                  child: AppVectorIcon(AppVectorIcons.imageOff),
                ),
              ),
      ),
    );
  }
}
