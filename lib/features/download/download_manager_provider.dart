import 'dart:async';
import 'dart:collection';

import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/core/services/video_download_service.dart';
import 'package:bears_video/features/player/video_detail_providers.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/episode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DownloadTaskStatus { downloading, completed, failed, cancelled }

class DownloadTaskState {
  const DownloadTaskState({
    required this.key,
    required this.status,
    required this.cancelToken,
    this.progress,
    this.error,
  });

  final EpisodeDownloadKey key;
  final DownloadTaskStatus status;
  final double? progress;
  final Object? error;
  final DownloadCancellationToken? cancelToken;

  DownloadTaskState copyWith({
    DownloadTaskStatus? status,
    double? progress,
    Object? error,
    DownloadCancellationToken? cancelToken,
  }) {
    return DownloadTaskState(
      key: key,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }
}

class DownloadManagerNotifier
    extends Notifier<Map<EpisodeDownloadKey, DownloadTaskState>> {
  static const _globalMaxConcurrent = 2;
  final Set<EpisodeDownloadKey> _runningTasks = {};
  final Queue<Completer<void>> _waitingTasks = Queue();
  int _activeTaskCount = 0;

  @override
  Map<EpisodeDownloadKey, DownloadTaskState> build() {
    ref.onDispose(() {
      for (final task in state.values) {
        task.cancelToken?.cancel();
      }
    });
    return const {};
  }

  Future<void> startDownload({
    required int videoId,
    required String videoTitle,
    required String videoPoster,
    required String videoDetailJson,
    required PlaySource playSource,
    required int episodeIndex,
  }) async {
    final key = (
      videoId: videoId,
      sourceName: playSource.name,
      episodeIndex: episodeIndex,
    );
    final existingTask = state[key];
    if (_runningTasks.contains(key) ||
        existingTask?.status == DownloadTaskStatus.downloading ||
        existingTask?.status == DownloadTaskStatus.completed) {
      return;
    }

    final cancelToken = DownloadCancellationToken();
    _runningTasks.add(key);
    state = {
      ...state,
      key: DownloadTaskState(
        key: key,
        status: DownloadTaskStatus.downloading,
        progress: 0,
        cancelToken: cancelToken,
      ),
    };

    VideoDownloadService? service;
    Timer? progressThrottle;
    double? pendingProgress;
    var slotAcquired = false;
    try {
      final repository = ref.read(episodeDownloadRepositoryProvider);
      final existing = await repository.getRecord(
        videoId: videoId,
        sourceName: playSource.name,
        episodeIndex: episodeIndex,
      );
      if (existing != null) {
        state = {
          ...state,
          key: DownloadTaskState(
            key: key,
            status: DownloadTaskStatus.completed,
            progress: 1,
            cancelToken: null,
          ),
        };
        ref.invalidate(episodeDownloadRecordProvider(key));
        return;
      }
      cancelToken.throwIfCancelled();
      await _acquireSlot(cancelToken);
      slotAcquired = true;
      service = VideoDownloadService(
        apiService: sl.get<ApiService>(),
        repository: repository,
      );
      await service.downloadEpisode(
        videoId: videoId,
        videoTitle: videoTitle,
        videoPoster: videoPoster,
        videoDetailJson: videoDetailJson,
        playSource: playSource,
        episodeIndex: episodeIndex,
        cancelToken: cancelToken,
        onProgress: (progress) {
          pendingProgress = progress;
          if (progressThrottle?.isActive == true) return;
          progressThrottle = Timer(const Duration(milliseconds: 100), () {
            final current = state[key];
            if (current == null ||
                current.status != DownloadTaskStatus.downloading) {
              return;
            }
            state = {
              ...state,
              key: DownloadTaskState(
                key: key,
                status: DownloadTaskStatus.downloading,
                progress: pendingProgress,
                cancelToken: current.cancelToken,
              ),
            };
          });
        },
      );
      cancelToken.throwIfCancelled();
      state = {
        ...state,
        key: DownloadTaskState(
          key: key,
          status: DownloadTaskStatus.completed,
          progress: 1,
          cancelToken: null,
        ),
      };
      ref.invalidate(episodeDownloadRecordProvider(key));
    } catch (error) {
      if (cancelToken.isCancelled || error is DownloadCancelledException) {
        state = {
          ...state,
          key: DownloadTaskState(
            key: key,
            status: DownloadTaskStatus.cancelled,
            cancelToken: null,
          ),
        };
        Timer(const Duration(milliseconds: 300), () => removeTask(key));
      } else {
        state = {
          ...state,
          key: DownloadTaskState(
            key: key,
            status: DownloadTaskStatus.failed,
            error: error,
            cancelToken: null,
          ),
        };
      }
    } finally {
      progressThrottle?.cancel();
      service?.close();
      if (slotAcquired) _releaseSlot();
      _runningTasks.remove(key);
    }
  }

  void cancelDownload(EpisodeDownloadKey key) {
    final task = state[key];
    if (task == null || task.status != DownloadTaskStatus.downloading) return;
    task.cancelToken?.cancel();
  }

  void removeTask(EpisodeDownloadKey key) {
    if (_runningTasks.contains(key) || !state.containsKey(key)) return;
    state = Map<EpisodeDownloadKey, DownloadTaskState>.from(state)..remove(key);
  }

  Future<void> _acquireSlot(DownloadCancellationToken cancelToken) async {
    cancelToken.throwIfCancelled();
    if (_activeTaskCount < _globalMaxConcurrent) {
      _activeTaskCount++;
      return;
    }

    final completer = Completer<void>();
    _waitingTasks.add(completer);
    void cancelWaiting() {
      if (_waitingTasks.remove(completer) && !completer.isCompleted) {
        completer.completeError(const DownloadCancelledException());
      }
    }

    cancelToken.addListener(cancelWaiting);
    try {
      await completer.future;
      try {
        cancelToken.throwIfCancelled();
      } catch (_) {
        _releaseSlot();
        rethrow;
      }
    } finally {
      cancelToken.removeListener(cancelWaiting);
    }
  }

  void _releaseSlot() {
    if (_activeTaskCount > 0) _activeTaskCount--;
    while (_waitingTasks.isNotEmpty) {
      final next = _waitingTasks.removeFirst();
      if (next.isCompleted) continue;
      _activeTaskCount++;
      next.complete();
      break;
    }
  }
}

final downloadManagerProvider =
    NotifierProvider<
      DownloadManagerNotifier,
      Map<EpisodeDownloadKey, DownloadTaskState>
    >(DownloadManagerNotifier.new);
