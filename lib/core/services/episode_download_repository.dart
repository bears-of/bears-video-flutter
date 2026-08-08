import 'dart:convert';
import 'dart:io';

import 'package:bears_video/src/rust/api/database.dart' as rust_database;

class EpisodeDownloadRecord {
  final int videoId;
  final String videoTitle;
  final String videoPoster;
  final String videoDetailJson;
  final String sourceName;
  final int episodeIndex;
  final String episodeLabel;
  final String remoteUrl;
  final String localPath;
  final Map<String, String> headers;
  final int downloadedAt;
  final int fileSizeBytes;

  const EpisodeDownloadRecord({
    required this.videoId,
    required this.videoTitle,
    required this.videoPoster,
    required this.videoDetailJson,
    required this.sourceName,
    required this.episodeIndex,
    required this.episodeLabel,
    required this.remoteUrl,
    required this.localPath,
    required this.headers,
    required this.downloadedAt,
    required this.fileSizeBytes,
  });

  factory EpisodeDownloadRecord.fromRust(
    rust_database.EpisodeDownloadRecord record,
  ) {
    return EpisodeDownloadRecord(
      videoId: record.videoId,
      videoTitle: record.videoTitle,
      videoPoster: record.videoPoster,
      videoDetailJson: record.videoDetailJson,
      sourceName: record.sourceName,
      episodeIndex: record.episodeIndex,
      episodeLabel: record.episodeLabel,
      remoteUrl: record.remoteUrl,
      localPath: record.localPath,
      headers: Map<String, String>.from(jsonDecode(record.headersJson) as Map),
      downloadedAt: record.downloadedAt,
      fileSizeBytes: record.fileSizeBytes,
    );
  }

  rust_database.EpisodeDownloadRecord toRust() {
    return rust_database.EpisodeDownloadRecord(
      videoId: videoId,
      videoTitle: videoTitle,
      videoPoster: videoPoster,
      videoDetailJson: videoDetailJson,
      sourceName: sourceName,
      episodeIndex: episodeIndex,
      episodeLabel: episodeLabel,
      remoteUrl: remoteUrl,
      localPath: localPath,
      headersJson: jsonEncode(headers),
      downloadedAt: downloadedAt,
      fileSizeBytes: fileSizeBytes,
    );
  }
}

class EpisodeDownloadRepository {
  Future<EpisodeDownloadRecord?> getRecord({
    required int videoId,
    required String sourceName,
    required int episodeIndex,
  }) async {
    final value = await rust_database.episodeDownloadGet(
      videoId: videoId,
      sourceName: sourceName,
      episodeIndex: episodeIndex,
    );
    if (value == null) return null;
    final record = EpisodeDownloadRecord.fromRust(value);
    if (await File(record.localPath).exists()) return record;
    await deleteRecord(
      videoId: videoId,
      sourceName: sourceName,
      episodeIndex: episodeIndex,
    );
    return null;
  }

  Future<void> save(EpisodeDownloadRecord record) {
    return rust_database.episodeDownloadSave(record: record.toRust());
  }

  Future<void> deleteRecord({
    required int videoId,
    required String sourceName,
    required int episodeIndex,
  }) {
    return rust_database.episodeDownloadDelete(
      videoId: videoId,
      sourceName: sourceName,
      episodeIndex: episodeIndex,
    );
  }

  Future<List<EpisodeDownloadRecord>> getRecordsForVideo(int videoId) async {
    final records = await rust_database.episodeDownloadGetForVideo(
      videoId: videoId,
    );
    return _removeMissingFiles(records);
  }

  Future<List<EpisodeDownloadRecord>> getAllRecords() async {
    final values = await rust_database.episodeDownloadGetAll();
    return _removeMissingFiles(values);
  }

  Future<List<EpisodeDownloadRecord>> _removeMissingFiles(
    List<rust_database.EpisodeDownloadRecord> values,
  ) async {
    final records = <EpisodeDownloadRecord>[];
    for (final value in values) {
      final record = EpisodeDownloadRecord.fromRust(value);
      if (await File(record.localPath).exists()) {
        records.add(record);
      } else {
        await deleteRecord(
          videoId: record.videoId,
          sourceName: record.sourceName,
          episodeIndex: record.episodeIndex,
        );
      }
    }
    return records;
  }

  Future<void> deleteRecords(Iterable<EpisodeDownloadRecord> records) async {
    final recordsToDelete = records.toList();
    if (recordsToDelete.isEmpty) return;

    for (final record in recordsToDelete) {
      final directory = File(record.localPath).parent;
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }

    for (final record in recordsToDelete) {
      await deleteRecord(
        videoId: record.videoId,
        sourceName: record.sourceName,
        episodeIndex: record.episodeIndex,
      );
    }
  }
}
