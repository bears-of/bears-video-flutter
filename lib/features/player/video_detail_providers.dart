import 'dart:async';
import 'dart:convert';
import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/core/services/episode_history_repository.dart';
import 'package:bears_video/core/services/episode_download_repository.dart';
import 'package:bears_video/core/services/playback_url_resolver.dart';
import 'package:bears_video/core/services/video_favorite_repository.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/danmaku_item.dart';
import 'package:bears_video/src/rust/models/platform_int64_json_converter.dart';
import 'package:bears_video/src/rust/models/video_detail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class VideoDetailOfflineException implements Exception {
  const VideoDetailOfflineException();

  @override
  String toString() => '当前无网络连接，且没有可用缓存';
}

// ===================== 视频详情（支持刷新） =====================
class VideoDetailNotifier
    extends FamilyAsyncNotifier<FrontendVideoDetail, int> {
  @override
  FutureOr<FrontendVideoDetail> build(int videoId) {
    return _fetchVideoDetail(videoId);
  }

  Future<FrontendVideoDetail> _fetchVideoDetail(int videoId) async {
    final connection = InternetConnection();
    final hasInternet = await connection.hasInternetAccess;
    if (!hasInternet) return _loadCachedVideoDetail(videoId);

    try {
      return await sl.get<ApiService>().fetchVideoDetail(videoId: videoId);
    } catch (_) {
      if (!await connection.hasInternetAccess) {
        return _loadCachedVideoDetail(videoId);
      }
      rethrow;
    }
  }

  Future<FrontendVideoDetail> _loadCachedVideoDetail(int videoId) async {
    final history = await ref
        .read(episodeHistoryRepositoryProvider)
        .getHistory(videoId);
    final historyDetail = _decodeVideoDetail(history?.videoDetailJson);
    if (historyDetail != null) return historyDetail;

    final downloads = await ref
        .read(episodeDownloadRepositoryProvider)
        .getRecordsForVideo(videoId);
    for (final record in downloads) {
      final detail = _decodeVideoDetail(record.videoDetailJson);
      if (detail != null) return detail;
    }

    final favoriteJson = await ref
        .read(videoFavoriteRepositoryProvider)
        .getVideoDetailJson(videoId);
    final favoriteDetail = _decodeVideoDetail(favoriteJson);
    if (favoriteDetail != null) return favoriteDetail;
    throw const VideoDetailOfflineException();
  }

  FrontendVideoDetail? _decodeVideoDetail(String? json) {
    if (json == null || json.isEmpty) return null;
    try {
      return FrontendVideoDetail.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  // 手动刷新
  Future<void> refresh(int videoId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchVideoDetail(videoId));
  }
}

final videoDetailProvider =
    AsyncNotifierProvider.family<VideoDetailNotifier, FrontendVideoDetail, int>(
      VideoDetailNotifier.new,
    );

// ===================== 剧集选择（绑定 videoId，异步恢复历史） =====================
class EpisodeSelection {
  final int sourceIndex;
  final int episodeIndex;
  final bool historyRestored;
  const EpisodeSelection({
    required this.sourceIndex,
    required this.episodeIndex,
    required this.historyRestored,
  });
}

class EpisodeSelectionNotifier extends FamilyNotifier<EpisodeSelection, int> {
  EpisodeHistoryRepository? _historyRepo;
  int? _currentVideoId;
  bool _initialized = false;
  bool _selectionChanged = false;

  @override
  EpisodeSelection build(int videoId) {
    _currentVideoId = videoId;
    _historyRepo = ref.watch(episodeHistoryRepositoryProvider);

    if (!_initialized) {
      _initialized = true;
      _loadHistory(videoId);
    }

    // 先返回默认值（加载完成后再更新）
    return const EpisodeSelection(
      sourceIndex: 0,
      episodeIndex: 0,
      historyRestored: false,
    );
  }

  Future<void> _loadHistory(int videoId) async {
    final history = await _historyRepo?.getHistory(videoId);
    if (history != null && !_selectionChanged) {
      state = EpisodeSelection(
        sourceIndex: history.sourceIndex,
        episodeIndex: history.episodeIndex,
        historyRestored: true,
      );
    } else if (!_selectionChanged) {
      state = EpisodeSelection(
        sourceIndex: state.sourceIndex,
        episodeIndex: state.episodeIndex,
        historyRestored: true,
      );
    }
  }

  void selectSource(int index) {
    _selectionChanged = true;
    state = EpisodeSelection(
      sourceIndex: index,
      episodeIndex: 0,
      historyRestored: true,
    );
    _saveHistory();
  }

  void selectEpisode(int index) {
    _selectionChanged = true;
    state = EpisodeSelection(
      sourceIndex: state.sourceIndex,
      episodeIndex: index,
      historyRestored: true,
    );
    _saveHistory();
  }

  void select({required int sourceIndex, required int episodeIndex}) {
    _selectionChanged = true;
    state = EpisodeSelection(
      sourceIndex: sourceIndex,
      episodeIndex: episodeIndex,
      historyRestored: true,
    );
    _saveHistory();
  }

  void _saveHistory() {
    final videoId = _currentVideoId;
    if (videoId == null) return;
    _historyRepo?.saveHistory(videoId, state.sourceIndex, state.episodeIndex);
  }
}

final episodeSelectionProvider =
    NotifierProvider.family<EpisodeSelectionNotifier, EpisodeSelection, int>(
      EpisodeSelectionNotifier.new,
    );

class VideoPlaybackData {
  final String url;
  final Map<String, String> headers;
  final bool isLocal;

  const VideoPlaybackData({
    required this.url,
    required this.headers,
    required this.isLocal,
  });
}

final specifiedVideoUrlProvider = FutureProvider.family<VideoPlaybackData, int>(
  (ref, videoId) async {
    final sourceIndex = ref.watch(
      episodeSelectionProvider(videoId).select((value) => value.sourceIndex),
    );
    final episodeIndex = ref.watch(
      episodeSelectionProvider(videoId).select((value) => value.episodeIndex),
    );
    final repository = ref.watch(episodeDownloadRepositoryProvider);
    final downloadedRecords = await repository.getRecordsForVideo(videoId);
    if (downloadedRecords.isNotEmpty &&
        downloadedRecords.first.videoDetailJson.isNotEmpty) {
      try {
        final cachedDetail = FrontendVideoDetail.fromJson(
          jsonDecode(downloadedRecords.first.videoDetailJson)
              as Map<String, dynamic>,
        );
        if (sourceIndex >= 0 && sourceIndex < cachedDetail.playSources.length) {
          final cachedSource = cachedDetail.playSources[sourceIndex];
          final downloaded = await repository.getRecord(
            videoId: videoId,
            sourceName: cachedSource.name,
            episodeIndex: episodeIndex,
          );
          if (downloaded != null) {
            return VideoPlaybackData(
              url: downloaded.localPath,
              headers: const {},
              isLocal: true,
            );
          }
        }
      } catch (_) {}
    }

    final videoDetail = await ref.watch(videoDetailProvider(videoId).future);

    if (sourceIndex < 0 || sourceIndex >= videoDetail.playSources.length) {
      throw StateError('播放源索引越界');
    }

    final playSource = videoDetail.playSources[sourceIndex];
    if (episodeIndex < 0 || episodeIndex >= playSource.episodes.length) {
      throw StateError('选集索引越界');
    }

    final downloaded = await repository.getRecord(
      videoId: videoId,
      sourceName: playSource.name,
      episodeIndex: episodeIndex,
    );
    if (downloaded != null) {
      return VideoPlaybackData(
        url: downloaded.localPath,
        headers: const {},
        isLocal: true,
      );
    }

    final url = await resolveEpisodePlaybackUrl(
      apiService: sl.get<ApiService>(),
      playSource: playSource,
      episodeIndex: episodeIndex,
    );

    return VideoPlaybackData(
      url: url,
      headers: playSource.headers,
      isLocal: false,
    );
  },
);

// ===================== 历史记录 Repository Provider =====================
final episodeHistoryRepositoryProvider = Provider<EpisodeHistoryRepository>(
  (ref) => EpisodeHistoryRepository(),
);

final episodeDownloadRepositoryProvider = Provider<EpisodeDownloadRepository>(
  (ref) => EpisodeDownloadRepository(),
);

final videoFavoriteRepositoryProvider = Provider<VideoFavoriteRepository>(
  (ref) => VideoFavoriteRepository(),
);

class VideoFavoriteNotifier extends FamilyAsyncNotifier<bool, int> {
  bool _updating = false;
  late int _videoId;

  @override
  Future<bool> build(int videoId) {
    _videoId = videoId;
    return ref.watch(videoFavoriteRepositoryProvider).isFavorite(videoId);
  }

  Future<bool> toggle(FrontendVideoDetail videoDetail) async {
    if (_updating) return state.value ?? false;
    _updating = true;
    final previous = state.value ?? false;
    final next = !previous;
    state = AsyncValue.data(next);
    try {
      final repository = ref.read(videoFavoriteRepositoryProvider);
      if (next) {
        await repository.add(videoDetail, _videoId);
      } else {
        await repository.remove(_videoId);
      }
      return next;
    } catch (error, stackTrace) {
      state = AsyncValue.data(previous);
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _updating = false;
    }
  }
}

final videoFavoriteProvider =
    AsyncNotifierProvider.family<VideoFavoriteNotifier, bool, int>(
      VideoFavoriteNotifier.new,
    );

typedef EpisodeDownloadKey = ({
  int videoId,
  String sourceName,
  int episodeIndex,
});

final episodeDownloadRecordProvider =
    FutureProvider.family<EpisodeDownloadRecord?, EpisodeDownloadKey>((
      ref,
      key,
    ) {
      return ref
          .watch(episodeDownloadRepositoryProvider)
          .getRecord(
            videoId: key.videoId,
            sourceName: key.sourceName,
            episodeIndex: key.episodeIndex,
          );
    });

// ===================== 当前选中的集数标签（便捷 Provider） =====================
final currentEpisodeLabelProvider = Provider.family<String?, int>((
  ref,
  videoId,
) {
  final detailAsync = ref.watch(videoDetailProvider(videoId));
  final sourceIndex = ref.watch(
    episodeSelectionProvider(videoId).select((value) => value.sourceIndex),
  );
  final episodeIndex = ref.watch(
    episodeSelectionProvider(videoId).select((value) => value.episodeIndex),
  );
  return detailAsync.when(
    data: (detail) {
      final sources = detail.playSources; // 注意字段名是 playSources
      if (sourceIndex >= sources.length) return null;
      final source = sources[sourceIndex];
      final episodes = source.episodes;
      if (episodeIndex >= episodes.length) return null;
      return episodes[episodeIndex].label;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// ===================== 播放器控制状态 =====================
final danmakuEnabledProvider = StateProvider<bool>((ref) => true);
typedef DanmakuRequestKey = ({int videoId, int sourceIndex, int episodeIndex});

final danmakuListProvider =
    FutureProvider.family<List<DanmakuItem>, DanmakuRequestKey>((ref, key) {
      return sl.get<ApiService>().fetchDanmakuListByIds(
        vodId: platformInt64FromInt(key.videoId),
        currentEpisode: platformInt64FromInt(key.episodeIndex),
      );
    });
final screenBrightnessProvider = StateProvider<double>((ref) => 0.5);
final volumeProvider = StateProvider<double>((ref) => 0.5);
final playbackSpeedProvider = StateProvider<double>((ref) => 1.0);
