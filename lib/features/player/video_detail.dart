import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/common/platform/app_platform_controller.dart';
import 'package:bears_video/common/widgets/app_bubble_notice.dart';
import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/common/widgets/app_text_field.dart';
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

BoxDecoration _episodeSelectorDecoration({required bool selected}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: selected ? AppColors.primaryDark : AppColors.outline,
      width: selected ? 1.5 : 1,
    ),
  );
}

class _PlayerControlButton extends StatelessWidget {
  const _PlayerControlButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final Widget icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                onPressed();
                return null;
              },
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: IconTheme.merge(
                  data: const IconThemeData(color: Colors.white),
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Ink(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppColors.primaryDark : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
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
                  color: selected ? AppColors.primaryDark : AppColors.inkMuted,
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
                AppVectorIcon(
                  AppVectorIcons.chevronLeft,
                  size: 18,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '详情介绍',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                AppVectorIcon(
                  AppVectorIcons.chevronRight,
                  size: 18,
                  color: primaryColor,
                ),
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
                showAppBubbleNotice(
                  context,
                  isFavorite ? '已收藏' : '已取消收藏',
                  type: isFavorite
                      ? AppBubbleNoticeType.success
                      : AppBubbleNoticeType.info,
                );
              } catch (_) {
                if (!context.mounted) return;
                showAppBubbleNotice(
                  context,
                  '收藏操作失败，请稍后重试',
                  type: AppBubbleNoticeType.error,
                );
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
            ? const AppVectorIcon(
                AppVectorIcons.star,
                size: 18,
                color: Colors.orange,
              )
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
        showAppBubbleNotice(
          context,
          '$episodeLabel 下载完成',
          type: AppBubbleNoticeType.success,
        );
      } else if (next?.status == DownloadTaskStatus.failed) {
        showAppBubbleNotice(
          context,
          '下载失败：${formatError(next?.error)}',
          type: AppBubbleNoticeType.error,
        );
      } else if (next?.status == DownloadTaskStatus.cancelled) {
        showAppBubbleNotice(context, '$episodeLabel 已取消下载');
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  )
                : isDownloaded
                ? const AppVectorIcon(
                    AppVectorIcons.badgeCheck,
                    size: 20,
                    color: Colors.green,
                  )
                : isCancelling
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : isFailed
                ? const AppVectorIcon(
                    AppVectorIcons.circleAlert,
                    size: 20,
                    color: Colors.red,
                  )
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
      final minutes = two(duration.inMinutes.remainder(60));
      final seconds = two(duration.inSeconds.remainder(60));
      if (duration.inHours == 0) return '$minutes:$seconds';
      return '${two(duration.inHours)}:$minutes:$seconds';
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
                const Text("选集", style: TextStyle(fontSize: 15)),
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
                              child: AppVectorIcon(
                                AppVectorIcons.chevronDown,
                                size: 20,
                              ),
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
                const Text("播放源", style: TextStyle(fontSize: 15)),
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
                        style: const TextStyle(fontSize: 22),
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
                    const AppVectorIcon(
                      AppVectorIcons.star,
                      size: 18,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      info.vodScore,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
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
                      style: TextStyle(color: Colors.black, fontSize: 15),
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
                      style: TextStyle(color: Colors.black, fontSize: 15),
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
          final detailRoute = ModalRoute.of(context);
          if (detailRoute == null || !detailRoute.isCurrent) return;
          if (!identical(fullScreenController.value, videoPlayerController)) {
            fullScreenController.value = videoPlayerController;
          }
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
          await platformController.presentFullScreen(context, fullScreenRoute);
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
            // Keep the inline texture mounted behind the fullscreen route so a
            // controller created while switching episodes already has a stable
            // render surface when fullscreen is dismissed.
            child: RepaintBoundary(
              child: Video(
                key: ValueKey(videoPlayerController.videoController),
                controller: videoPlayerController.videoController,
                controls: NoVideoControls,
                fit: BoxFit.contain,
              ),
            ),
            builder: (context, child) {
              final controlsMotionDuration =
                  MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180);
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
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AnimatedOpacity(
                            opacity: controlsVisible.value ? 1 : 0,
                            duration: controlsMotionDuration,
                            child: FocusScope(
                              canRequestFocus: controlsVisible.value,
                              descendantsAreFocusable: controlsVisible.value,
                              child: ExcludeSemantics(
                                excluding: !controlsVisible.value,
                                child: IgnorePointer(
                                  ignoring: !controlsVisible.value,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      8,
                                      4,
                                      8,
                                      6,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 28,
                                          child: SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              trackHeight: 2.5,
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                    enabledThumbRadius: 5,
                                                  ),
                                              overlayShape:
                                                  const RoundSliderOverlayShape(
                                                    overlayRadius: 14,
                                                  ),
                                              activeTrackColor:
                                                  AppColors.primary,
                                              secondaryActiveTrackColor:
                                                  Colors.white54,
                                              inactiveTrackColor:
                                                  Colors.white24,
                                              thumbColor: AppColors.primary,
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
                                                      )
                                                      .toDouble(),
                                              max: videoPlayerController
                                                  .value
                                                  .duration
                                                  .inMilliseconds
                                                  .toDouble()
                                                  .clamp(1, double.infinity)
                                                  .toDouble(),
                                              secondaryTrackValue: math
                                                  .max(
                                                    (pendingSeekPosition
                                                                .value ??
                                                            videoPlayerController
                                                                .value
                                                                .position)
                                                        .inMilliseconds,
                                                    videoPlayerController
                                                        .value
                                                        .buffer
                                                        .inMilliseconds,
                                                  )
                                                  .toDouble()
                                                  .clamp(
                                                    0,
                                                    videoPlayerController
                                                        .value
                                                        .duration
                                                        .inMilliseconds
                                                        .toDouble()
                                                        .clamp(
                                                          1,
                                                          double.infinity,
                                                        ),
                                                  )
                                                  .toDouble(),
                                              onChanged: (value) {
                                                pendingSeekPosition
                                                    .value = Duration(
                                                  milliseconds: value.toInt(),
                                                );
                                              },
                                              onChangeEnd: (value) async {
                                                final position = Duration(
                                                  milliseconds: value.toInt(),
                                                );
                                                await videoPlayerController
                                                    .seekTo(position);
                                                if (context.mounted) {
                                                  pendingSeekPosition.value =
                                                      null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            _PlayerControlButton(
                                              semanticLabel:
                                                  videoPlayerController
                                                      .value
                                                      .isPlaying
                                                  ? '暂停'
                                                  : '播放',
                                              icon: SvgPicture.string(
                                                videoPlayerController
                                                        .value
                                                        .isPlaying
                                                    ? BearsSVG.pauseSVG
                                                    : BearsSVG.playSVG,
                                                width: 24,
                                                height: 24,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                              ),
                                              onPressed: () {
                                                if (videoPlayerController
                                                    .value
                                                    .isPlaying) {
                                                  videoPlayerController.pause();
                                                } else {
                                                  videoPlayerController.play();
                                                }
                                              },
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${formatDuration(videoPlayerController.value.position)} / ${formatDuration(videoPlayerController.value.duration)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black87,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                                fontFeatures: [
                                                  FontFeature.tabularFigures(),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            _PlayerControlButton(
                                              semanticLabel: '全屏播放',
                                              icon: SvgPicture.string(
                                                BearsSVG.fullScreenSVG,
                                                width: 24,
                                                height: 24,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                              ),
                                              onPressed: () =>
                                                  _enterFullScreen(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                    const AppVectorIcon(AppVectorIcons.wifiOff, size: 64),
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          page,
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              minimum: const EdgeInsets.all(8),
              child: _PlayerControlButton(
                semanticLabel: '返回',
                icon: const AppVectorIcon(
                  AppVectorIcons.chevronLeft,
                  size: 24,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                ),
                onPressed: clearAndPop,
              ),
            ),
          ),
        ],
      ),
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
    final searchController = useTextEditingController();
    final searchQuery = useState('');
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

    useEffect(() {
      searchController.clear();
      searchQuery.value = '';
      return null;
    }, [currentSourceIndex]);

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
                            AppVectorIcon(
                              AppVectorIcons.library,
                              size: 42,
                              color: AppColors.inkMuted,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '暂时没有可播放的剧集',
                              style: TextStyle(color: AppColors.inkMuted),
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
    final normalizedQuery = searchQuery.value.trim().toLowerCase();
    final visibleEpisodeIndices = List<int>.generate(episodes.length, (i) => i)
        .where(
          (index) =>
              normalizedQuery.isEmpty ||
              episodes[index].label.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);

    void selectSource(int index) {
      ref.read(episodeSelectionProvider(videoId).notifier).selectSource(index);
    }

    void selectEpisode(int index) {
      ref.read(episodeSelectionProvider(videoId).notifier).selectEpisode(index);
      onClose();
    }

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
                        title: '选集与播放源',
                        subtitle:
                            '${currentSource.name} · $currentEpisodeLabel',
                        onClose: onClose,
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth >= 700;
                            final workspace = _EpisodeWorkspace(
                              episodes: episodes,
                              visibleEpisodeIndices: visibleEpisodeIndices,
                              sourceIndex: sourceIndex,
                              episodeIndex: episodeIndex,
                              currentEpisodeLabel: currentEpisodeLabel,
                              searchController: searchController,
                              searchQuery: searchQuery.value,
                              onSearchChanged: (value) =>
                                  searchQuery.value = value,
                              onClearSearch: () {
                                searchController.clear();
                                searchQuery.value = '';
                              },
                              onSelectEpisode: selectEpisode,
                              scrollController: scrollController,
                              bottomPadding: mediaQuery.padding.bottom + 20,
                              horizontalPadding: wide ? 24 : 20,
                            );
                            if (wide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _EpisodeSourceRail(
                                    playSources: playSources,
                                    selectedIndex: sourceIndex,
                                    onSelected: selectSource,
                                  ),
                                  const VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: AppColors.outline,
                                  ),
                                  Expanded(child: workspace),
                                ],
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _MobileSourcePicker(
                                  playSources: playSources,
                                  selectedIndex: sourceIndex,
                                  onSelected: selectSource,
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.outline,
                                ),
                                Expanded(child: workspace),
                              ],
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
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
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
                message: '关闭',
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onClose,
                    child: const SizedBox.square(
                      dimension: 44,
                      child: Center(
                        child: AppVectorIcon(
                          AppVectorIcons.x,
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
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final motionDuration = disableAnimations
        ? Duration.zero
        : _episodeSheetMotionDuration;
    final quickDuration = disableAnimations
        ? Duration.zero
        : _episodeSheetQuickDuration;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label，$episodeCount 集',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: motionDuration,
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: _episodeSelectorDecoration(selected: selected),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: quickDuration,
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
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$episodeCount',
                  style: TextStyle(
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.inkMuted,
                    fontSize: 11,
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
    final motionDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _episodeSheetMotionDuration;
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
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: motionDuration,
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: _episodeSelectorDecoration(selected: selected),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selected) ...[
                    const AppVectorIcon(
                      AppVectorIcons.play,
                      size: 16,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 3),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? AppColors.primaryDark
                            : AppColors.inkMuted,
                        fontSize: 12,
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
}

class _MobileSourcePicker extends StatelessWidget {
  const _MobileSourcePicker({
    required this.playSources,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PlaySource> playSources;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: Row(
              children: [
                const Text(
                  '播放源',
                  style: TextStyle(color: AppColors.ink, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${playSources.length} 个可用',
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: playSources.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final source = playSources[index];
                return _EpisodeSourceChip(
                  key: ValueKey('sheet_source_${source.name}_$index'),
                  label: source.name,
                  episodeCount: source.episodes.length,
                  selected: index == selectedIndex,
                  onTap: () => onSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeSourceRail extends StatelessWidget {
  const _EpisodeSourceRail({
    required this.playSources,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PlaySource> playSources;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final motionDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _episodeSheetMotionDuration;
    return SizedBox(
      width: 224,
      child: ColoredBox(
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  const Text(
                    '播放源',
                    style: TextStyle(color: AppColors.ink, fontSize: 15),
                  ),
                  const Spacer(),
                  Text(
                    '${playSources.length}',
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                itemCount: playSources.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final source = playSources[index];
                  final selected = selectedIndex == index;
                  return Semantics(
                    button: true,
                    selected: selected,
                    label: '${source.name}，${source.episodes.length} 集',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: ValueKey('sheet_source_${source.name}_$index'),
                        onTap: () => onSelected(index),
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: motionDuration,
                          curve: Curves.easeOutCubic,
                          constraints: const BoxConstraints(minHeight: 52),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: _episodeSelectorDecoration(
                            selected: selected,
                          ),
                          child: Row(
                            children: [
                              AppVectorIcon(
                                selected
                                    ? AppVectorIcons.circlePlay
                                    : AppVectorIcons.circlePlay,
                                size: 20,
                                color: selected
                                    ? AppColors.primaryDark
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  source.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.primaryDark
                                        : AppColors.inkMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                '${source.episodes.length}',
                                style: TextStyle(
                                  color: selected
                                      ? AppColors.primaryDark
                                      : AppColors.inkMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EpisodeWorkspace extends StatelessWidget {
  const _EpisodeWorkspace({
    required this.episodes,
    required this.visibleEpisodeIndices,
    required this.sourceIndex,
    required this.episodeIndex,
    required this.currentEpisodeLabel,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSelectEpisode,
    required this.scrollController,
    required this.bottomPadding,
    required this.horizontalPadding,
  });

  final List<Episode> episodes;
  final List<int> visibleEpisodeIndices;
  final int sourceIndex;
  final int episodeIndex;
  final String currentEpisodeLabel;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<int> onSelectEpisode;
  final ScrollController scrollController;
  final double bottomPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            episodes.length >= 12 ? 12 : 14,
          ),
          child: Row(
            children: [
              const Text(
                '剧集',
                style: TextStyle(color: AppColors.ink, fontSize: 17),
              ),
              const SizedBox(width: 8),
              _EpisodeCountBadge(count: episodes.length),
              const Spacer(),
              if (episodes.isNotEmpty)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppVectorIcon(
                        AppVectorIcons.audioLines,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          currentEpisodeLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (episodes.length >= 12)
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              14,
            ),
            child: SizedBox(
              height: 44,
              child: AppTextField(
                controller: searchController,
                hintText: '搜索剧集',
                onChanged: onSearchChanged,
                prefixIcon: const AppVectorIcon(
                  AppVectorIcons.search,
                  size: 12,
                ),
                suffixIcon: searchQuery.isEmpty
                    ? null
                    : Tooltip(
                        message: '清除搜索',
                        child: InkWell(
                          onTap: onClearSearch,
                          borderRadius: BorderRadius.circular(18),
                          child: const SizedBox.square(
                            dimension: 44,
                            child: Center(
                              child: AppVectorIcon(AppVectorIcons.x, size: 18),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        Expanded(
          child: _EpisodeGrid(
            episodes: episodes,
            visibleEpisodeIndices: visibleEpisodeIndices,
            sourceIndex: sourceIndex,
            episodeIndex: episodeIndex,
            onSelectEpisode: onSelectEpisode,
            scrollController: scrollController,
            bottomPadding: bottomPadding,
            horizontalPadding: horizontalPadding,
          ),
        ),
      ],
    );
  }
}

class _EpisodeCountBadge extends StatelessWidget {
  const _EpisodeCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
      ),
    );
  }
}

class _EpisodeGrid extends StatelessWidget {
  const _EpisodeGrid({
    required this.episodes,
    required this.visibleEpisodeIndices,
    required this.sourceIndex,
    required this.episodeIndex,
    required this.onSelectEpisode,
    required this.scrollController,
    required this.bottomPadding,
    required this.horizontalPadding,
  });

  final List<Episode> episodes;
  final List<int> visibleEpisodeIndices;
  final int sourceIndex;
  final int episodeIndex;
  final ValueChanged<int> onSelectEpisode;
  final ScrollController scrollController;
  final double bottomPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const _EpisodeEmptyState(
        icon: AppVectorIcons.library,
        message: '该播放源暂无剧集',
      );
    }
    if (visibleEpisodeIndices.isEmpty) {
      return const _EpisodeEmptyState(
        icon: AppVectorIcons.searchX,
        message: '没有匹配的剧集',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        var widestLabelUnits = 0.0;
        for (final index in visibleEpisodeIndices) {
          final units = episodes[index].label.runes.fold<double>(
            0,
            (sum, rune) => sum + (rune <= 0x7F ? 0.58 : 1),
          );
          widestLabelUnits = math.max(widestLabelUnits, units);
        }
        final availableGridWidth = math.max(
          1.0,
          constraints.maxWidth - horizontalPadding * 2,
        );
        final scaledFontSize = MediaQuery.textScalerOf(context).scale(12);
        final preferredTileWidth = (widestLabelUnits * scaledFontSize + 42)
            .clamp(92.0, 240.0);
        final columns = ((availableGridWidth + 10) / (preferredTileWidth + 10))
            .floor()
            .clamp(1, 8);
        return GridView.builder(
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            bottomPadding,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 48,
          ),
          itemCount: visibleEpisodeIndices.length,
          itemBuilder: (context, visibleIndex) {
            final episodeOriginalIndex = visibleEpisodeIndices[visibleIndex];
            return _EpisodeTile(
              key: ValueKey(
                'sheet_episode_${sourceIndex}_$episodeOriginalIndex',
              ),
              label: episodes[episodeOriginalIndex].label,
              selected: episodeIndex == episodeOriginalIndex,
              onTap: () => onSelectEpisode(episodeOriginalIndex),
            );
          },
        );
      },
    );
  }
}

class _EpisodeEmptyState extends StatelessWidget {
  const _EpisodeEmptyState({required this.icon, required this.message});

  final AppVectorIconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppVectorIcon(icon, size: 36, color: AppColors.inkMuted),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
