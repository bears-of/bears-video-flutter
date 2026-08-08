import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:bears_video/common/platform/app_platform_controller.dart';
import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/features/download/download_manager_provider.dart';
import 'package:bears_video/features/full_screen/full_screen_player.dart';
import 'package:bears_video/features/player/media_kit_player_controller.dart';
import 'package:bears_video/features/player/video_detail_providers.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:bears_video/src/rust/models/episode.dart';
import 'package:bears_video/src/rust/models/video_detail.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';

const _episodeSheetQuickDuration = Duration(milliseconds: 140);
const _episodeSheetMotionDuration = Duration(milliseconds: 220);

class _PlayerControllerSession {
  bool cancelled = false;
}

class _PlayerLifecycleCoordinator {
  static Future<void> _releaseBarrier = Future<void>.value();

  static Future<void> initialize(
    MediaKitPlayerController controller,
    _PlayerControllerSession session,
  ) async {
    await _releaseBarrier;
    if (session.cancelled) return;
    await controller.initialize();
  }

  static void release(
    MediaKitPlayerController controller, {
    Duration delay = Duration.zero,
  }) {
    final release = _releaseBarrier.then((_) async {
      if (delay > Duration.zero) await Future<void>.delayed(delay);
      await controller.release();
    });
    _releaseBarrier = release.catchError((Object error) {
      debugPrint('释放播放器失败: $error');
    });
  }
}

class _SelectionChipButton extends StatelessWidget {
  const _SelectionChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Ink(
          height: 36,
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? colorScheme.primary : Colors.grey.shade300,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerWithLabel extends StatelessWidget {
  const _DividerWithLabel();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, size: 18, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  '详情介绍',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 18, color: primaryColor),
              ],
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.videoId, required this.videoDetail});

  final int videoId;
  final FrontendVideoDetail videoDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteAsync = ref.watch(videoFavoriteProvider(videoId));
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: favoriteAsync.isLoading
          ? null
          : () async {
              try {
                final isFavorite = await ref
                    .read(videoFavoriteProvider(videoId).notifier)
                    .toggle(videoDetail);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isFavorite ? '已收藏' : '已取消收藏')),
                );
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('收藏操作失败：$error')));
              }
            },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: favoriteAsync.isLoading
            ? const SizedBox.square(
                dimension: 26,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : favoriteAsync.value ?? false
            ? const Icon(Icons.star_rounded, size: 18, color: Colors.orange)
            : SvgPicture.string(
                BearsSVG.starSVG,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}

class _DownloadEpisodeButton extends ConsumerWidget {
  const _DownloadEpisodeButton({
    required this.videoId,
    required this.videoDetail,
    required this.playSource,
    required this.episodeIndex,
    required this.formatError,
  });

  final int videoId;
  final FrontendVideoDetail videoDetail;
  final PlaySource playSource;
  final int episodeIndex;
  final String Function(Object?) formatError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = videoDetail.videoInfo.vodInfo;
    final downloadKey = (
      videoId: videoId,
      sourceName: playSource.name,
      episodeIndex: episodeIndex,
    );
    final downloadRecordAsync = ref.watch(
      episodeDownloadRecordProvider(downloadKey),
    );
    final task = ref.watch(
      downloadManagerProvider.select((tasks) => tasks[downloadKey]),
    );
    final isDownloaded =
        downloadRecordAsync.asData?.value != null ||
        task?.status == DownloadTaskStatus.completed;
    final isDownloading = task?.status == DownloadTaskStatus.downloading;
    final isCancelling = task?.status == DownloadTaskStatus.cancelled;
    final isFailed = task?.status == DownloadTaskStatus.failed;
    final progress = task?.progress;

    ref.listen(downloadManagerProvider.select((tasks) => tasks[downloadKey]), (
      previous,
      next,
    ) {
      if (previous?.status == next?.status || !context.mounted) return;
      final episodeLabel = playSource.episodes[episodeIndex].label;
      if (next?.status == DownloadTaskStatus.completed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$episodeLabel 下载完成')));
      } else if (next?.status == DownloadTaskStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下载失败：${formatError(next?.error)}')),
        );
      } else if (next?.status == DownloadTaskStatus.cancelled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$episodeLabel 已取消下载')));
      }
    });

    void handleTap() {
      if (isDownloaded || isCancelling) return;
      if (isDownloading) {
        return;
      }

      unawaited(
        ref
            .read(downloadManagerProvider.notifier)
            .startDownload(
              videoId: videoId,
              videoTitle: info.vodName,
              videoPoster: info.vodPicSlide.isNotEmpty
                  ? info.vodPicSlide
                  : info.vodPic,
              videoDetailJson: jsonEncode(videoDetail.toJson()),
              playSource: playSource,
              episodeIndex: episodeIndex,
            ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: handleTap,
      onLongPress: isDownloading
          ? () => ref
                .read(downloadManagerProvider.notifier)
                .cancelDownload(downloadKey)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox.square(
          dimension: 26,
          child: Center(
            child: isDownloading
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: progress != null && progress > 0
                              ? progress.clamp(0.0, 1.0).toDouble()
                              : null,
                        ),
                      ),
                      if (progress != null && progress > 0)
                        Text(
                          '${(progress * 100).clamp(0, 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  )
                : isDownloaded
                ? const Icon(Icons.download_done, size: 20, color: Colors.green)
                : isCancelling
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : isFailed
                ? const Icon(Icons.error_outline, size: 20, color: Colors.red)
                : SvgPicture.string(
                    BearsSVG.downloadSVG,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class VideoDetailPage extends HookConsumerWidget {
  VideoDetailPage({
    super.key,
    required this.videoId,
    this.initialSourceIndex,
    this.initialEpisodeIndex,
  });
  final int videoId;
  final int? initialSourceIndex;
  final int? initialEpisodeIndex;

  final playerKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformController = ref.watch(appPlatformControllerProvider);
    final sourceIndex = ref.watch(
      episodeSelectionProvider(videoId).select((value) => value.sourceIndex),
    );
    final episodeIndex = ref.watch(
      episodeSelectionProvider(videoId).select((value) => value.episodeIndex),
    );
    final historyRestored = ref.watch(
      episodeSelectionProvider(
        videoId,
      ).select((value) => value.historyRestored),
    );
    final selection = EpisodeSelection(
      sourceIndex: sourceIndex,
      episodeIndex: episodeIndex,
      historyRestored: historyRestored,
    );
    final videoDetailAsync = ref.watch(videoDetailProvider(videoId));
    final playbackAsync = ref.watch(specifiedVideoUrlProvider(videoId));
    final playback = playbackAsync.isLoading
        ? null
        : playbackAsync.asData?.value;
    final playUrl = playback?.url;

    // --- 视频控制器（依赖 playUrl） ---
    final videoPlayerController = useMemoized(() {
      final url = playUrl;
      if (url == null || url.isEmpty) return null;
      if (playback!.isLocal) {
        return MediaKitPlayerController.file(File(url));
      }
      return MediaKitPlayerController.network(
        url,
        httpHeaders: playback.headers,
      );
    }, [playUrl, playback?.headers, playback?.isLocal]);
    final fullScreenController = useState<MediaKitPlayerController?>(
      videoPlayerController,
    );
    final fullScreenActive = useState(false);
    final fullScreenControllerVersion = useRef(0);

    useEffect(() {
      final version = ++fullScreenControllerVersion.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || version != fullScreenControllerVersion.value) {
          return;
        }
        fullScreenController.value = videoPlayerController;
      });
      return null;
    }, [videoPlayerController]);

    // --- 初始化并播放视频（当控制器创建后） ---
    final controllerSession = useMemoized(_PlayerControllerSession.new, [
      videoPlayerController,
    ]);

    final initializeFuture = useMemoized(() {
      final controller = videoPlayerController;
      if (controller == null) return Future<void>.value();
      return _PlayerLifecycleCoordinator.initialize(
        controller,
        controllerSession,
      );
    }, [videoPlayerController, controllerSession]);

    useEffect(() {
      final controller = videoPlayerController;
      if (controller == null) {
        unawaited(platformController.setPlaybackActive(false));
        return null;
      }

      bool? lastPlaybackActive;
      void syncPlaybackActivity() {
        final active = controller.value.isPlaying;
        if (active == lastPlaybackActive) return;
        lastPlaybackActive = active;
        unawaited(platformController.setPlaybackActive(active));
      }

      controller.addListener(syncPlaybackActivity);
      syncPlaybackActivity();
      return () {
        controller.removeListener(syncPlaybackActivity);
        unawaited(platformController.setPlaybackActive(false));
      };
    }, [videoPlayerController, platformController]);

    final controlsVisible = useValueNotifier(true);
    final playerError = useState<Object?>(null);
    final isPopping = useState(false);
    final appLifecycleState = useAppLifecycleState();
    final appLifecycleStateRef = useRef<AppLifecycleState?>(appLifecycleState);
    final currentVideoPlayerController = useRef<MediaKitPlayerController?>(
      videoPlayerController,
    );
    final resumePlaybackOnForeground = useRef(true);
    final wasBackgrounded = useRef(false);
    appLifecycleStateRef.value = appLifecycleState;
    currentVideoPlayerController.value = videoPlayerController;
    final pendingSeekPosition = useValueNotifier<Duration?>(null);
    final playerRebuildListenable = useMemoized(
      () => Listenable.merge([
        if (videoPlayerController != null) videoPlayerController,
        controlsVisible,
        pendingSeekPosition,
      ]),
      [videoPlayerController, controlsVisible, pendingSeekPosition],
    );
    final initialSelectionApplied = useRef(false);
    final hideTimer = useRef<Timer?>(null);
    final tapTimer = useRef<Timer?>(null);

    useEffect(() {
      if (initialSelectionApplied.value ||
          initialSourceIndex == null ||
          initialEpisodeIndex == null) {
        return null;
      }
      initialSelectionApplied.value = true;
      Future.microtask(() {
        ref
            .read(episodeSelectionProvider(videoId).notifier)
            .select(
              sourceIndex: initialSourceIndex!,
              episodeIndex: initialEpisodeIndex!,
            );
      });
      return null;
    }, [videoId, initialSourceIndex, initialEpisodeIndex]);

    useEffect(
      () {
        final videoDetail = videoDetailAsync.asData?.value;
        if (videoDetail == null || !selection.historyRestored) return null;
        unawaited(
          ref
              .read(episodeHistoryRepositoryProvider)
              .savePlaybackMetadata(
                videoId: videoId,
                sourceIndex: selection.sourceIndex,
                episodeIndex: selection.episodeIndex,
                videoDetail: videoDetail,
              ),
        );
        return null;
      },
      [
        videoId,
        videoDetailAsync.asData?.value,
        selection.sourceIndex,
        selection.episodeIndex,
        selection.historyRestored,
      ],
    );

    void startHideTimer() {
      hideTimer.value?.cancel();
      hideTimer.value = Timer(const Duration(seconds: 5), () {
        controlsVisible.value = false;
      });
    }

    void showControls() {
      controlsVisible.value = true;
      startHideTimer();
    }

    useEffect(() {
      final controller = videoPlayerController;
      final state = appLifecycleState;
      if (state == null) return null;

      if (state == AppLifecycleState.resumed) {
        final shouldResume =
            wasBackgrounded.value && resumePlaybackOnForeground.value;
        wasBackgrounded.value = false;
        if (shouldResume && controller != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted ||
                appLifecycleStateRef.value != AppLifecycleState.resumed ||
                !identical(currentVideoPlayerController.value, controller) ||
                !controller.value.isInitialized ||
                isPopping.value) {
              return;
            }
            unawaited(controller.play());
          });
        }
        return null;
      }

      if (!wasBackgrounded.value) {
        resumePlaybackOnForeground.value =
            controller == null ||
            !controller.value.isInitialized ||
            controller.value.isPlaying;
      }
      wasBackgrounded.value = true;
      if (controller != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted ||
              appLifecycleStateRef.value == AppLifecycleState.resumed ||
              !identical(currentVideoPlayerController.value, controller) ||
              !controller.value.isInitialized) {
            return;
          }
          unawaited(controller.pause());
        });
      }
      return null;
    }, [appLifecycleState, videoPlayerController]);

    // --- 自动播放和资源清理 ---
    useEffect(() {
      if (videoPlayerController == null) {
        return () {};
      }

      var disposed = false;
      Timer? progressSaveTimer;
      final controllerSourceIndex = selection.sourceIndex;
      final controllerEpisodeIndex = selection.episodeIndex;
      final historyRepository = ref.read(episodeHistoryRepositoryProvider);

      Future<void> saveControllerProgress() async {
        final currentSelection = ref.read(episodeSelectionProvider(videoId));
        if (currentSelection.sourceIndex != controllerSourceIndex ||
            currentSelection.episodeIndex != controllerEpisodeIndex ||
            !videoPlayerController.value.isInitialized) {
          return;
        }
        await historyRepository.savePlaybackProgress(
          videoId: videoId,
          sourceIndex: controllerSourceIndex,
          episodeIndex: controllerEpisodeIndex,
          watchedPositionMs:
              videoPlayerController.value.position.inMilliseconds,
          totalDurationMs: videoPlayerController.value.duration.inMilliseconds,
        );
      }

      playerError.value = null;
      initializeFuture
          .then((_) async {
            if (disposed || isPopping.value) return;
            await videoPlayerController.setLooping(true);
            final history = await historyRepository.getHistory(videoId);
            if (disposed || isPopping.value) return;
            if (history != null &&
                history.sourceIndex == selection.sourceIndex &&
                history.episodeIndex == selection.episodeIndex &&
                history.watchedPositionMs > 0 &&
                videoPlayerController.value.duration.inMilliseconds > 0) {
              final durationMs =
                  videoPlayerController.value.duration.inMilliseconds;
              final resumePositionMs = history.watchedPositionMs
                  .clamp(0, durationMs)
                  .toInt();
              await videoPlayerController.seekTo(
                Duration(milliseconds: resumePositionMs),
              );
            }
            if (disposed || isPopping.value) return;
            await saveControllerProgress();
            if (disposed || isPopping.value) return;
            if (appLifecycleStateRef.value == null ||
                appLifecycleStateRef.value == AppLifecycleState.resumed) {
              await videoPlayerController.play();
              if (appLifecycleStateRef.value != null &&
                  appLifecycleStateRef.value != AppLifecycleState.resumed) {
                resumePlaybackOnForeground.value = true;
                await videoPlayerController.pause();
              }
            } else {
              resumePlaybackOnForeground.value = true;
            }
            progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
              if (disposed ||
                  appLifecycleStateRef.value != AppLifecycleState.resumed ||
                  !videoPlayerController.value.isInitialized ||
                  !videoPlayerController.value.isPlaying) {
                return;
              }
              unawaited(saveControllerProgress());
            });
          })
          .catchError((Object error) {
            if (!disposed) {
              playerError.value = error;
              debugPrint('播放器初始化失败: $error');
              debugPrint('播放地址: $playUrl');
            }
          });

      startHideTimer();

      return () {
        disposed = true;
        controllerSession.cancelled = true;
        progressSaveTimer?.cancel();
        hideTimer.value?.cancel();
        tapTimer.value?.cancel();
        if (!isPopping.value && videoPlayerController.value.isInitialized) {
          unawaited(saveControllerProgress());
        }
        _PlayerLifecycleCoordinator.release(
          videoPlayerController,
          delay: isPopping.value
              ? Duration(milliseconds: kDebugMode ? 1500 : 500)
              : const Duration(milliseconds: 50),
        );
      };
    }, [videoPlayerController]);

    Future<void> clearAndPop([Object? result]) async {
      if (isPopping.value) return;
      isPopping.value = true;
      final controller = videoPlayerController;
      final progress = controller != null && controller.value.isInitialized
          ? (
              sourceIndex: selection.sourceIndex,
              episodeIndex: selection.episodeIndex,
              positionMs: controller.value.position.inMilliseconds,
              durationMs: controller.value.duration.inMilliseconds,
            )
          : null;
      final historyRepository = ref.read(episodeHistoryRepositoryProvider);
      if (controller != null && controller.value.isInitialized) {
        try {
          await controller.pause();
        } catch (error) {
          debugPrint('暂停播放器失败: $error');
        }
      }
      if (!context.mounted) return;
      Navigator.of(context).pop(result);
      if (progress != null) {
        unawaited(
          historyRepository
              .savePlaybackProgress(
                videoId: videoId,
                sourceIndex: progress.sourceIndex,
                episodeIndex: progress.episodeIndex,
                watchedPositionMs: progress.positionMs,
                totalDurationMs: progress.durationMs,
              )
              .catchError((Object error) {
                debugPrint('保存观看进度失败: $error');
              }),
        );
      }
    }

    String formatDuration(Duration duration) {
      String two(int n) => n.toString().padLeft(2, '0');
      final hours = two(duration.inHours);
      final minutes = two(duration.inMinutes.remainder(60));
      final seconds = two(duration.inSeconds.remainder(60));
      return "$hours:$minutes:$seconds";
    }

    String formatUserError(Object? error) {
      if (error == null) return '未知错误';
      final message = error
          .toString()
          .split('Stack backtrace:')
          .first
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      const maxLength = 240;
      return message.length <= maxLength
          ? message
          : '${message.substring(0, maxLength)}…';
    }

    final page = videoDetailAsync.when(
      data: (videoDetail) {
        final currentPlaySource =
            videoDetail.playSources[selection.sourceIndex];

        // ========== 修改2：内部函数中所有 Provider 使用均带 videoId ==========
        void _showEpisodeDialog(BuildContext context) {
          final renderBox =
              playerKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox == null) return;

          final offset = renderBox.localToGlobal(Offset.zero);
          final playerBottom = offset.dy + renderBox.size.height;
          final screenHeight = MediaQuery.of(context).size.height;
          final sheetHeight = screenHeight - playerBottom;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => _EpisodeSheet(
              videoId: videoId, // 传递 videoId
              videoDetail: videoDetail,
              sheetHeight: sheetHeight,
              onClose: () => Navigator.pop(context),
            ),
          );
        }

        Widget _buildEpisodes() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "选集",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentPlaySource.episodes.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final selected = selection.episodeIndex == index;
                            return _SelectionChipButton(
                              key: ValueKey(
                                'episode_${currentPlaySource.name}_$index',
                              ),
                              label: currentPlaySource.episodes[index].label,
                              selected: selected,
                              onTap: () {
                                // ========== 修改3：使用带 videoId 的 notifier ==========
                                ref
                                    .read(
                                      episodeSelectionProvider(
                                        videoId,
                                      ).notifier,
                                    )
                                    .selectEpisode(index);
                              },
                            );
                          },
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => _showEpisodeDialog(context),
                          child: const SizedBox.square(
                            dimension: 36,
                            child: Center(
                              child: Icon(Icons.keyboard_arrow_down, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        Widget _buildPlaySources() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "播放源",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: videoDetail.playSources.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final source = videoDetail.playSources[index];
                      return _SelectionChipButton(
                        key: ValueKey('source_${source.name}_$index'),
                        label: source.name,
                        selected: selection.sourceIndex == index,
                        onTap: () {
                          ref
                              .read(episodeSelectionProvider(videoId).notifier)
                              .selectSource(index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        Widget _buildTitle() {
          final info = videoDetail.videoInfo.vodInfo;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        info.vodName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FavoriteButton(videoId: videoId, videoDetail: videoDetail),
                    const SizedBox(width: 4),
                    _DownloadEpisodeButton(
                      videoId: videoId,
                      videoDetail: videoDetail,
                      playSource: currentPlaySource,
                      episodeIndex: selection.episodeIndex,
                      formatError: formatUserError,
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ref
                            .read(danmakuEnabledProvider.notifier)
                            .update((state) => !state);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ref.watch(danmakuEnabledProvider)
                            ? SvgPicture.string(
                                BearsSVG.danmakuLineSVG,
                                height: 18,
                                width: 18,
                                colorFilter: ColorFilter.mode(
                                  AppColors.primary.withValues(alpha: 0.7),
                                  BlendMode.srcIn,
                                ),
                              )
                            : SvgPicture.string(
                                BearsSVG.danmakuOffLineSVG,
                                height: 18,
                                width: 18,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      info.vodScore,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${info.vodYear} · ${info.vodArea} · ${info.vodClass}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        Widget _buildVideoInfo() {
          final info = videoDetail.videoInfo.vodInfo;
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '演职人员',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '导演：${info.vodDirector}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                Text(
                  '主演：${info.vodActor}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '剧情介绍',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ExpandableText(
                  info.vodContent,
                  maxLines: 3,
                  expandText: ' 展开',
                  collapseText: ' 收起',
                  animation: true,
                  animationDuration: const Duration(milliseconds: 200),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  linkColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          );
        }

        Future<void> _enterFullScreen(BuildContext context) async {
          if (fullScreenActive.value) return;
          fullScreenActive.value = true;
          final fullScreenRoute = PageRouteBuilder<void>(
            pageBuilder: (_, __, ___) => FullScreenPlayer(
              controllerListenable: fullScreenController,
              videoId: videoId,
              playSources: videoDetail.playSources,
              videoTitle: videoDetail.videoInfo.vodInfo.vodName,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
          try {
            await platformController.presentFullScreen(
              context,
              fullScreenRoute,
            );
          } finally {
            if (context.mounted) {
              fullScreenActive.value = false;
            }
            await platformController.completeFullScreenExit();
          }
        }

        Widget playerView() {
          if (videoPlayerController == null) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: Colors.black,
                child: Center(
                  child: playbackAsync.hasError
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '获取播放地址失败：${formatUserError(playbackAsync.error)}',
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              AppButton(
                                onPressed: () => ref.invalidate(
                                  specifiedVideoUrlProvider(videoId),
                                ),
                                child: const Text('重试'),
                              ),
                            ],
                          ),
                        )
                      : const CircularProgressIndicator(color: Colors.white),
                ),
              ),
            );
          }
          return AnimatedBuilder(
            animation: playerRebuildListenable,
            child: fullScreenActive.value
                ? const ColoredBox(color: Colors.black)
                : RepaintBoundary(
                    child: Video(
                      controller: videoPlayerController.videoController,
                      controls: NoVideoControls,
                      fit: BoxFit.contain,
                    ),
                  ),
            builder: (context, child) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: ColoredBox(
                  key: playerKey,
                  color: Colors.black,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      if (tapTimer.value != null) {
                        tapTimer.value?.cancel();
                        tapTimer.value = null;
                        if (videoPlayerController.value.isPlaying) {
                          videoPlayerController.pause();
                        } else {
                          videoPlayerController.play();
                        }
                      } else {
                        tapTimer.value = Timer(
                          const Duration(milliseconds: 300),
                          () {
                            if (controlsVisible.value) {
                              controlsVisible.value = false;
                              hideTimer.value?.cancel();
                            } else {
                              showControls();
                            }
                            tapTimer.value = null;
                          },
                        );
                      }
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (videoPlayerController.value.isInitialized) child!,
                        if (!videoPlayerController.value.isInitialized)
                          Center(
                            child: playerError.value == null
                                ? const CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '播放器加载失败：${formatUserError(playerError.value)}',
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        AppButton(
                                          onPressed: () => ref.invalidate(
                                            specifiedVideoUrlProvider(videoId),
                                          ),
                                          child: const Text('重试'),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        if (videoPlayerController.value.isInitialized &&
                            videoPlayerController.value.isBuffering)
                          const Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                child: Text(
                                  '正在缓冲...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 8,
                          left: 8,
                          right: 8,
                          child: SafeArea(
                            child: Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: clearAndPop,
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const Spacer(),
                                AnimatedOpacity(
                                  opacity: controlsVisible.value ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: IgnorePointer(
                                    ignoring: !controlsVisible.value,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: SvgPicture.string(
                                          BearsSVG.tvSVG,
                                          width: 22,
                                          height: 22,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AnimatedOpacity(
                            opacity: controlsVisible.value ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: IgnorePointer(
                              ignoring: !controlsVisible.value,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (videoPlayerController
                                            .value
                                            .isPlaying) {
                                          videoPlayerController.pause();
                                        } else {
                                          videoPlayerController.play();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: SvgPicture.string(
                                          videoPlayerController.value.isPlaying
                                              ? BearsSVG.pauseSVG
                                              : BearsSVG.playSVG,
                                          width: 22,
                                          height: 22,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      formatDuration(
                                        videoPlayerController.value.position,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 3,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                enabledThumbRadius: 6,
                                              ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                overlayRadius: 12,
                                              ),
                                          activeTrackColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          inactiveTrackColor: Colors.white24,
                                          thumbColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        child: Slider(
                                          value:
                                              (pendingSeekPosition.value ??
                                                      videoPlayerController
                                                          .value
                                                          .position)
                                                  .inMilliseconds
                                                  .toDouble()
                                                  .clamp(
                                                    0,
                                                    videoPlayerController
                                                        .value
                                                        .duration
                                                        .inMilliseconds
                                                        .toDouble(),
                                                  ),
                                          max: videoPlayerController
                                              .value
                                              .duration
                                              .inMilliseconds
                                              .toDouble()
                                              .clamp(1, double.infinity),
                                          onChanged: (value) {
                                            pendingSeekPosition.value =
                                                Duration(
                                                  milliseconds: value.toInt(),
                                                );
                                          },
                                          onChangeEnd: (value) async {
                                            final position = Duration(
                                              milliseconds: value.toInt(),
                                            );
                                            await videoPlayerController.seekTo(
                                              position,
                                            );
                                            if (context.mounted) {
                                              pendingSeekPosition.value = null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      formatDuration(
                                        videoPlayerController.value.duration,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        _enterFullScreen(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 2,
                                        ),
                                        child: SvgPicture.string(
                                          BearsSVG.fullScreenSVG,
                                          width: 22,
                                          height: 22,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: playerView()),
                SliverToBoxAdapter(child: _buildTitle()),
                SliverToBoxAdapter(child: _buildPlaySources()),
                SliverToBoxAdapter(child: _buildEpisodes()),
                const SliverToBoxAdapter(child: _DividerWithLabel()),
                SliverToBoxAdapter(child: _buildVideoInfo()),
              ],
            ),
          ),
        );
      },
      error: (error, _) {
        if (error is VideoDetailOfflineException) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 64),
                    const SizedBox(height: 16),
                    const Text('无法连接', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 8),
                    const Text('当前无网络连接，且没有可用缓存'),
                    const SizedBox(height: 20),
                    AppButton(
                      onPressed: () =>
                          ref.invalidate(videoDetailProvider(videoId)),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '加载视频详情失败：${formatUserError(error)}',
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    onPressed: () =>
                        ref.invalidate(videoDetailProvider(videoId)),
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );

    return PopScope<Object?>(
      canPop: isPopping.value,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) await clearAndPop(result);
      },
      child: page,
    );
  }
}

class _EpisodeSheet extends HookConsumerWidget {
  const _EpisodeSheet({
    required this.videoId,
    required this.videoDetail,
    required this.onClose,
    required this.sheetHeight,
  });

  final int videoId;
  final FrontendVideoDetail videoDetail;
  final VoidCallback onClose;
  final double sheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSourceIndex = ref.watch(
      episodeSelectionProvider(videoId).select((value) => value.sourceIndex),
    );
    final currentEpisodeIndex = ref.watch(
      episodeSelectionProvider(videoId).select((value) => value.episodeIndex),
    );
    final mediaQuery = MediaQuery.of(context);
    final maxPanelHeight = mediaQuery.size.height * 0.86;
    final panelHeight = maxPanelHeight <= 320
        ? maxPanelHeight
        : sheetHeight.clamp(320.0, maxPanelHeight).toDouble();
    final playSources = videoDetail.playSources;

    if (playSources.isEmpty) {
      return SizedBox(
        height: panelHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: SizedBox(
              width: double.infinity,
              child: _EpisodeSheetSurface(
                child: Column(
                  children: [
                    _EpisodeSheetHeader(
                      title: '选集',
                      subtitle: '暂无可用播放源',
                      onClose: onClose,
                    ),
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.video_library_outlined,
                              size: 42,
                              color: AppColors.inkMuted,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '暂时没有可播放的剧集',
                              style: TextStyle(
                                color: AppColors.inkMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final sourceIndex = currentSourceIndex
        .clamp(0, playSources.length - 1)
        .toInt();
    final currentSource = playSources[sourceIndex];
    final episodes = currentSource.episodes;
    final episodeIndex = episodes.isEmpty
        ? 0
        : currentEpisodeIndex.clamp(0, episodes.length - 1).toInt();
    final currentEpisodeLabel = episodes.isEmpty
        ? '暂无剧集'
        : episodes[episodeIndex].label;

    return SizedBox(
      height: panelHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: SizedBox(
            width: double.infinity,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 1,
              minChildSize: 0.62,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return _EpisodeSheetSurface(
                  child: Column(
                    children: [
                      _EpisodeSheetHeader(
                        title: '选集',
                        subtitle:
                            '${currentSource.name} · ${episodes.length} 集 · 当前 $currentEpisodeLabel',
                        onClose: onClose,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                        child: Row(
                          children: [
                            const Text(
                              '播放源',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${playSources.length} 个可用源',
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 46,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: playSources.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final source = playSources[index];
                            return _EpisodeSourceChip(
                              key: ValueKey(
                                'sheet_source_${source.name}_$index',
                              ),
                              label: source.name,
                              episodeCount: source.episodes.length,
                              selected: sourceIndex == index,
                              onTap: () => ref
                                  .read(
                                    episodeSelectionProvider(videoId).notifier,
                                  )
                                  .selectSource(index),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                        child: Row(
                          children: [
                            const Text(
                              '剧集',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${episodes.length}',
                                style: const TextStyle(
                                  color: AppColors.inkMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (episodes.isNotEmpty)
                              Flexible(
                                child: Text(
                                  '正在播放 · $currentEpisodeLabel',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (episodes.isEmpty) {
                              return const Center(
                                child: Text(
                                  '该播放源暂无剧集',
                                  style: TextStyle(color: AppColors.inkMuted),
                                ),
                              );
                            }
                            var widestLabelUnits = 0.0;
                            for (final episode in episodes) {
                              final units = episode.label.runes.fold<double>(
                                0,
                                (sum, rune) => sum + (rune <= 0x7F ? 0.58 : 1),
                              );
                              widestLabelUnits = math.max(
                                widestLabelUnits,
                                units,
                              );
                            }
                            final availableGridWidth = math.max(
                              1.0,
                              constraints.maxWidth - 40,
                            );
                            final scaledFontSize = MediaQuery.textScalerOf(
                              context,
                            ).scale(12);
                            final preferredTileWidth =
                                (widestLabelUnits * scaledFontSize + 32).clamp(
                                  92.0,
                                  240.0,
                                );
                            final columns =
                                ((availableGridWidth + 10) /
                                        (preferredTileWidth + 10))
                                    .floor()
                                    .clamp(1, 8);
                            return GridView.builder(
                              controller: scrollController,
                              padding: EdgeInsets.fromLTRB(
                                20,
                                0,
                                20,
                                mediaQuery.padding.bottom + 20,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 48,
                                  ),
                              itemCount: episodes.length,
                              itemBuilder: (context, index) {
                                return _EpisodeTile(
                                  key: ValueKey(
                                    'sheet_episode_${sourceIndex}_$index',
                                  ),
                                  label: episodes[index].label,
                                  selected: episodeIndex == index,
                                  onTap: () {
                                    ref
                                        .read(
                                          episodeSelectionProvider(
                                            videoId,
                                          ).notifier,
                                        )
                                        .selectEpisode(index);
                                    onClose();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodeSheetSurface extends StatelessWidget {
  const _EpisodeSheetSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white, width: 1)),
        ),
        child: child,
      ),
    );
  }
}

class _EpisodeSheetHeader extends StatelessWidget {
  const _EpisodeSheetHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 9),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.outline,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.video_library_rounded,
                  color: AppColors.primaryDark,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'MiSans',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: '关闭选集',
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onClose,
                    child: const SizedBox.square(
                      dimension: 36,
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.outline),
      ],
    );
  }
}

class _EpisodeSourceChip extends StatelessWidget {
  const _EpisodeSourceChip({
    super.key,
    required this.label,
    required this.episodeCount,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int episodeCount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label，$episodeCount 集',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: _episodeSheetMotionDuration,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.11)
                  : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: _episodeSheetQuickDuration,
                  width: selected ? 7 : 0,
                  height: 7,
                  margin: EdgeInsets.only(right: selected ? 7 : 0),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.inkMuted,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$episodeCount',
                  style: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : AppColors.inkMuted.withValues(alpha: 0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 450),
      child: Semantics(
        button: true,
        selected: selected,
        label: selected ? '$label，正在播放' : label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: _episodeSheetMotionDuration,
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.ink,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
