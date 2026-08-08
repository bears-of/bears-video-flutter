import 'dart:convert';

import 'package:bears_video/src/rust/api/database.dart' as rust_database;
import 'package:bears_video/src/rust/models/video_detail.dart';

class VideoFavoriteRecord {
  const VideoFavoriteRecord({
    required this.videoId,
    required this.videoTitle,
    required this.videoPoster,
    required this.videoDetailJson,
    required this.createdAt,
  });

  final int videoId;
  final String videoTitle;
  final String videoPoster;
  final String videoDetailJson;
  final int createdAt;

  factory VideoFavoriteRecord.fromRust(rust_database.FavoriteRecord record) {
    return VideoFavoriteRecord(
      videoId: record.videoId,
      videoTitle: record.videoTitle,
      videoPoster: record.videoPoster,
      videoDetailJson: record.videoDetailJson,
      createdAt: record.createdAt,
    );
  }
}

class VideoFavoriteRepository {
  Future<bool> isFavorite(int videoId) {
    return rust_database.favoriteIsSaved(videoId: videoId);
  }

  Future<void> add(FrontendVideoDetail videoDetail, int videoId) {
    final info = videoDetail.videoInfo.vodInfo;
    return rust_database.favoriteSave(
      videoId: videoId,
      videoTitle: info.vodName,
      videoPoster: info.vodPicSlide.isNotEmpty ? info.vodPicSlide : info.vodPic,
      videoDetailJson: jsonEncode(videoDetail.toJson()),
    );
  }

  Future<void> remove(int videoId) {
    return rust_database.favoriteRemove(videoId: videoId);
  }

  Future<String?> getVideoDetailJson(int videoId) {
    return rust_database.favoriteGetDetailJson(videoId: videoId);
  }

  Future<List<VideoFavoriteRecord>> getAll() async {
    final records = await rust_database.favoriteGetAll();
    return records.map(VideoFavoriteRecord.fromRust).toList();
  }
}
