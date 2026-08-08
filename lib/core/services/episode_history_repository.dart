import 'dart:convert';

import 'package:bears_video/src/rust/api/database.dart' as rust_database;
import 'package:bears_video/src/rust/models/video_detail.dart';

class EpisodeHistory {
  final int videoId;
  final int sourceIndex;
  final int episodeIndex;
  final int watchedPositionMs;
  final int totalDurationMs;
  final String videoTitle;
  final String videoPoster;
  final String videoDetailJson;
  final String sourceName;
  final String episodeLabel;
  final int updatedAt;
  const EpisodeHistory({
    required this.videoId,
    required this.sourceIndex,
    required this.episodeIndex,
    required this.watchedPositionMs,
    required this.totalDurationMs,
    required this.videoTitle,
    required this.videoPoster,
    required this.videoDetailJson,
    required this.sourceName,
    required this.episodeLabel,
    required this.updatedAt,
  });

  factory EpisodeHistory.fromRust(rust_database.EpisodeHistoryRecord record) {
    return EpisodeHistory(
      videoId: record.videoId,
      sourceIndex: record.sourceIndex,
      episodeIndex: record.episodeIndex,
      watchedPositionMs: record.watchedPositionMs,
      totalDurationMs: record.totalDurationMs,
      videoTitle: record.videoTitle,
      videoPoster: record.videoPoster,
      videoDetailJson: record.videoDetailJson,
      sourceName: record.sourceName,
      episodeLabel: record.episodeLabel,
      updatedAt: record.updatedAt,
    );
  }
}

class EpisodeHistoryRepository {
  Future<EpisodeHistory?> getHistory(int videoId) async {
    final record = await rust_database.episodeHistoryGet(videoId: videoId);
    return record == null ? null : EpisodeHistory.fromRust(record);
  }

  Future<List<EpisodeHistory>> getAllHistories() async {
    final records = await rust_database.episodeHistoryGetAll();
    return records.map(EpisodeHistory.fromRust).toList();
  }

  Future<void> saveHistory(int videoId, int sourceIndex, int episodeIndex) {
    return rust_database.episodeHistorySaveSelection(
      videoId: videoId,
      sourceIndex: sourceIndex,
      episodeIndex: episodeIndex,
    );
  }

  Future<void> savePlaybackProgress({
    required int videoId,
    required int sourceIndex,
    required int episodeIndex,
    required int watchedPositionMs,
    required int totalDurationMs,
  }) {
    return rust_database.episodeHistorySaveProgress(
      videoId: videoId,
      sourceIndex: sourceIndex,
      episodeIndex: episodeIndex,
      watchedPositionMs: watchedPositionMs,
      totalDurationMs: totalDurationMs,
    );
  }

  Future<void> savePlaybackMetadata({
    required int videoId,
    required int sourceIndex,
    required int episodeIndex,
    required FrontendVideoDetail videoDetail,
  }) {
    if (sourceIndex < 0 || sourceIndex >= videoDetail.playSources.length) {
      return Future.value();
    }
    final source = videoDetail.playSources[sourceIndex];
    if (episodeIndex < 0 || episodeIndex >= source.episodes.length) {
      return Future.value();
    }
    final info = videoDetail.videoInfo.vodInfo;
    return rust_database.episodeHistorySaveMetadata(
      videoId: videoId,
      sourceIndex: sourceIndex,
      episodeIndex: episodeIndex,
      videoTitle: info.vodName,
      videoPoster: info.vodPicSlide.isNotEmpty ? info.vodPicSlide : info.vodPic,
      videoDetailJson: jsonEncode(videoDetail.toJson()),
      sourceName: source.name,
      episodeLabel: source.episodes[episodeIndex].label,
    );
  }

  Future<void> clearAll() => rust_database.episodeHistoryClear();
}
