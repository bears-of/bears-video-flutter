import 'dart:async';
import 'dart:math' as math;

import 'package:battery_plus/battery_plus.dart';
import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/common/platform/app_platform_controller.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/features/player/media_kit_player_controller.dart';
import 'package:bears_video/features/player/video_detail_providers.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:bears_video/src/rust/models/danmaku_item.dart';
import 'package:bears_video/src/rust/models/episode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

const _danmakuDurationSeconds = 24.0;
const _danmakuLaneHeight = 26.0;
const _danmakuGap = 16.0;
const _drawerMotionDuration = Duration(milliseconds: 220);
const _controlsFadeDuration = Duration(milliseconds: 200);
const _platformAdjustThrottle = Duration(milliseconds: 33);
const _playbackSpeedOptions = <double>[0.75, 1.0, 1.25, 1.5, 2.0, 3.0];

enum _FullScreenDrawerMode { episodes, playbackSpeed }

class _ThrottledPlatformValueSetter {
  _ThrottledPlatformValueSetter(this.setter);

  final FutureOr<void> Function(double value) setter;
  Timer? _timer;
  double? _pendingValue;
  DateTime? _lastRunAt;

  void set(double value) {
    _pendingValue = value;
    final now = DateTime.now();
    final lastRunAt = _lastRunAt;
    if (lastRunAt == null ||
        now.difference(lastRunAt) >= _platformAdjustThrottle) {
      _flush();
      return;
    }
    _timer ??= Timer(
      _platformAdjustThrottle - now.difference(lastRunAt),
      _flush,
    );
  }

  void _flush() {
    _timer?.cancel();
    _timer = null;
    final value = _pendingValue;
    if (value == null) return;
    _pendingValue = null;
    _lastRunAt = DateTime.now();
    try {
      final result = setter(value);
      if (result is Future) {
        unawaited(result.catchError((_) {}));
      }
    } catch (_) {}
  }

  void flush() => _flush();

  void dispose() {
    _flush();
  }
}

class _ScheduledDanmaku {
  const _ScheduledDanmaku({
    required this.startSeconds,
    required this.width,
    required this.lane,
    required this.textPainter,
  });

  final double startSeconds;
  final double width;
  final int lane;
  final TextPainter textPainter;
}

class _DanmakuLaneTail {
  const _DanmakuLaneTail({required this.startSeconds, required this.width});

  final double startSeconds;
  final double width;
}

class _DanmakuPainter extends CustomPainter {
  _DanmakuPainter({
    required this.positionSeconds,
    required this.isInitialized,
    required Listenable repaint,
  }) : super(repaint: repaint);

  List<_ScheduledDanmaku> schedule = const [];
  double viewportWidth = 0;
  double topPadding = 0;
  final double Function() positionSeconds;
  final bool Function() isInitialized;

  int _firstActiveIndex = 0;
  int _lastActiveIndex = 0;
  double _lastPositionSeconds = double.nan;

  void updateConfiguration({
    required List<_ScheduledDanmaku> schedule,
    required double viewportWidth,
    required double topPadding,
  }) {
    if (identical(this.schedule, schedule) &&
        this.viewportWidth == viewportWidth &&
        this.topPadding == topPadding) {
      return;
    }
    this.schedule = schedule;
    this.viewportWidth = viewportWidth;
    this.topPadding = topPadding;
    _firstActiveIndex = 0;
    _lastActiveIndex = 0;
    _lastPositionSeconds = double.nan;
  }

  int _upperBound(double value) {
    var low = 0;
    var high = schedule.length;
    while (low < high) {
      final middle = low + ((high - low) >> 1);
      if (schedule[middle].startSeconds <= value) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    return low;
  }

  void _updateActiveRange(double nowSeconds) {
    final earliestSeconds = nowSeconds - _danmakuDurationSeconds;
    final requiresRelocation =
        !_lastPositionSeconds.isFinite ||
        nowSeconds < _lastPositionSeconds ||
        nowSeconds - _lastPositionSeconds > 0.5;

    if (requiresRelocation) {
      _firstActiveIndex = _upperBound(earliestSeconds);
      _lastActiveIndex = _upperBound(nowSeconds);
    } else {
      while (_firstActiveIndex < schedule.length &&
          schedule[_firstActiveIndex].startSeconds <= earliestSeconds) {
        _firstActiveIndex++;
      }
      if (_lastActiveIndex < _firstActiveIndex) {
        _lastActiveIndex = _firstActiveIndex;
      }
      while (_lastActiveIndex < schedule.length &&
          schedule[_lastActiveIndex].startSeconds <= nowSeconds) {
        _lastActiveIndex++;
      }
    }
    _lastPositionSeconds = nowSeconds;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!isInitialized() || schedule.isEmpty) return;

    final nowSeconds = positionSeconds();
    if (!nowSeconds.isFinite) return;
    _updateActiveRange(nowSeconds);

    for (var index = _firstActiveIndex; index < _lastActiveIndex; index++) {
      final entry = schedule[index];
      final elapsedSeconds = nowSeconds - entry.startSeconds;
      if (elapsedSeconds < 0 || elapsedSeconds >= _danmakuDurationSeconds) {
        continue;
      }
      final progress = elapsedSeconds / _danmakuDurationSeconds;
      final left = viewportWidth - progress * (viewportWidth + entry.width);
      entry.textPainter.paint(
        canvas,
        Offset(left, topPadding + entry.lane * _danmakuLaneHeight),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DanmakuPainter oldDelegate) => true;
}

class _DanmakuOverlay extends StatefulWidget {
  const _DanmakuOverlay({required this.controller, required this.items});

  final MediaKitPlayerController controller;
  final List<DanmakuItem> items;

  @override
  State<_DanmakuOverlay> createState() => _DanmakuOverlayState();
}

class _DanmakuOverlayState extends State<_DanmakuOverlay>
    with SingleTickerProviderStateMixin {
  List<_ScheduledDanmaku> _schedule = const [];
  List<DanmakuItem>? _scheduledItems;
  double _scheduledWidth = -1;
  int _scheduledLaneCount = -1;
  late final AnimationController _frameClock;
  late final _DanmakuPainter _painter;
  final Stopwatch _stopwatch = Stopwatch();
  double _anchorPositionMs = 0;
  double _anchorClockMs = 0;
  double _lastRawPositionMs = -1;
  double _lastRawClockMs = 0;
  double _lastPlaybackSpeed = 1;
  bool _lastPlaying = false;

  static const _textStyle = TextStyle(
    fontSize: 14,
    // shadows: [
    //   Shadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1)),
    //   Shadow(color: Colors.black87, blurRadius: 2, offset: Offset(-1, -1)),
    // ],
  );

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _frameClock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _painter = _DanmakuPainter(
      positionSeconds: _estimatedPositionSeconds,
      isInitialized: () => widget.controller.value.isInitialized,
      repaint: _frameClock,
    );
    _resetPositionAnchor();
    widget.controller.addListener(_syncFrameClock);
    _syncFrameClock();
  }

  @override
  void didUpdateWidget(covariant _DanmakuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.items, oldWidget.items)) {
      _scheduledItems = null;
    }
    if (!identical(widget.controller, oldWidget.controller)) {
      oldWidget.controller.removeListener(_syncFrameClock);
      widget.controller.addListener(_syncFrameClock);
      _resetPositionAnchor();
      _syncFrameClock();
    }
  }

  @override
  void dispose() {
    _disposeSchedule(_schedule);
    widget.controller.removeListener(_syncFrameClock);
    _frameClock.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  void _disposeSchedule(List<_ScheduledDanmaku> schedule) {
    for (final entry in schedule) {
      entry.textPainter.dispose();
    }
  }

  double get _clockMs => _stopwatch.elapsedMicroseconds / 1000.0;

  void _syncFrameClock() {
    final value = widget.controller.value;
    final shouldAnimate =
        value.isInitialized && value.isPlaying && !value.isBuffering;
    if (shouldAnimate) {
      if (!_frameClock.isAnimating) _frameClock.repeat();
    } else {
      if (_frameClock.isAnimating) _frameClock.stop();
    }
  }

  void _setPositionAnchor(
    double positionMs,
    double speed,
    bool playing, {
    double? rawPositionMs,
  }) {
    _anchorPositionMs = positionMs;
    _anchorClockMs = _clockMs;
    _lastRawPositionMs = rawPositionMs ?? positionMs;
    _lastRawClockMs = _anchorClockMs;
    _lastPlaybackSpeed = speed;
    _lastPlaying = playing;
  }

  void _resetPositionAnchor() {
    final value = widget.controller.value;
    _setPositionAnchor(
      value.position.inMilliseconds.toDouble(),
      value.playbackSpeed,
      value.isPlaying && !value.isBuffering,
    );
  }

  double _estimatedPositionSeconds() {
    final value = widget.controller.value;
    final rawPositionMs = value.position.inMilliseconds.toDouble();
    final speed = value.playbackSpeed;
    final playing = value.isPlaying && !value.isBuffering;
    final nowMs = _clockMs;
    final predictedMs =
        _anchorPositionMs +
        (_lastPlaying ? (nowMs - _anchorClockMs) * _lastPlaybackSpeed : 0);

    if (_lastRawPositionMs < 0 || playing != _lastPlaying) {
      _setPositionAnchor(rawPositionMs, speed, playing);
    } else if (speed != _lastPlaybackSpeed) {
      _setPositionAnchor(
        predictedMs,
        speed,
        playing,
        rawPositionMs: rawPositionMs,
      );
    } else if (!playing) {
      _setPositionAnchor(rawPositionMs, speed, false);
    } else if (rawPositionMs != _lastRawPositionMs) {
      final rawElapsedMs = (nowMs - _lastRawClockMs)
          .clamp(1.0, double.infinity)
          .toDouble();
      final rawDeltaMs = rawPositionMs - _lastRawPositionMs;
      final expectedDeltaMs = rawElapsedMs * speed;
      final errorMs = rawPositionMs - predictedMs;
      final seekThresholdMs = (expectedDeltaMs.abs() * 1.2 + 500)
          .clamp(1200.0, 5000.0)
          .toDouble();
      final seekDetected =
          rawDeltaMs < -250 ||
          (rawDeltaMs - expectedDeltaMs).abs() > seekThresholdMs;
      if (seekDetected) {
        _setPositionAnchor(rawPositionMs, speed, true);
      } else {
        final forwardCorrectionMs = errorMs > 0
            ? (errorMs * 0.12).clamp(0.0, 80.0).toDouble()
            : 0.0;
        _setPositionAnchor(
          predictedMs + forwardCorrectionMs,
          speed,
          true,
          rawPositionMs: rawPositionMs,
        );
      }
    }

    final positionMs =
        _anchorPositionMs +
        (_lastPlaying ? (_clockMs - _anchorClockMs) * _lastPlaybackSpeed : 0);
    return positionMs / 1000.0;
  }

  Color _parseColor(String value) {
    final rgb = RegExp(
      r'rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)',
      caseSensitive: false,
    ).firstMatch(value);
    if (rgb != null) {
      return Color.fromARGB(
        255,
        int.parse(rgb.group(1)!).clamp(0, 255).toInt(),
        int.parse(rgb.group(2)!).clamp(0, 255).toInt(),
        int.parse(rgb.group(3)!).clamp(0, 255).toInt(),
      );
    }
    final hex = value.trim().replaceFirst('#', '');
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed != null && (hex.length == 6 || hex.length == 8)) {
      return Color(hex.length == 6 ? 0xFF000000 | parsed : parsed);
    }
    return Colors.white;
  }

  bool _canFollow({
    required _DanmakuLaneTail previous,
    required double startSeconds,
    required double width,
    required double viewportWidth,
  }) {
    final delta = startSeconds - previous.startSeconds;
    if (delta >= _danmakuDurationSeconds) return true;
    if (delta <= 0) return false;

    final previousSpeed =
        (viewportWidth + previous.width) / _danmakuDurationSeconds;
    final nextSpeed = (viewportWidth + width) / _danmakuDurationSeconds;
    final gapAtStart = delta * previousSpeed - previous.width;
    final previousRemaining = _danmakuDurationSeconds - delta;
    final gapWhenPreviousExits = viewportWidth - previousRemaining * nextSpeed;
    return gapAtStart >= _danmakuGap && gapWhenPreviousExits >= _danmakuGap;
  }

  void _ensureSchedule(double viewportWidth, int laneCount) {
    if (identical(_scheduledItems, widget.items) &&
        _scheduledWidth == viewportWidth &&
        _scheduledLaneCount == laneCount) {
      return;
    }

    final parsedItems =
        widget.items
            .map((item) => (item: item, time: double.tryParse(item.vTime)))
            .where(
              (entry) =>
                  entry.time != null &&
                  entry.time! >= 0 &&
                  entry.item.content.trim().isNotEmpty,
            )
            .toList()
          ..sort((left, right) {
            final byTime = left.time!.compareTo(right.time!);
            return byTime != 0 ? byTime : left.item.id.compareTo(right.item.id);
          });

    final laneTails = List<_DanmakuLaneTail?>.filled(laneCount, null);
    final schedule = <_ScheduledDanmaku>[];
    for (final entry in parsedItems) {
      final content = entry.item.content.trim();
      final textPainter = TextPainter(
        text: TextSpan(
          text: content,
          style: _textStyle.copyWith(color: _parseColor(entry.item.color)),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      final width = textPainter.width;
      final startSeconds = entry.time!;
      int? selectedLane;
      for (var lane = 0; lane < laneCount; lane++) {
        final previous = laneTails[lane];
        if (previous == null ||
            _canFollow(
              previous: previous,
              startSeconds: startSeconds,
              width: width,
              viewportWidth: viewportWidth,
            )) {
          selectedLane = lane;
          break;
        }
      }
      if (selectedLane == null) {
        textPainter.dispose();
        continue;
      }
      laneTails[selectedLane] = _DanmakuLaneTail(
        startSeconds: startSeconds,
        width: width,
      );
      schedule.add(
        _ScheduledDanmaku(
          startSeconds: startSeconds,
          width: width,
          lane: selectedLane,
          textPainter: textPainter,
        ),
      );
    }

    _disposeSchedule(_schedule);
    _scheduledItems = widget.items;
    _scheduledWidth = viewportWidth;
    _scheduledLaneCount = laneCount;
    _schedule = schedule;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const topPadding = 52.0;
          final danmakuHeight = constraints.maxHeight * 0.56;
          final laneCount = ((danmakuHeight - topPadding) / _danmakuLaneHeight)
              .floor()
              .clamp(1, 12)
              .toInt();
          _ensureSchedule(constraints.maxWidth, laneCount);
          _painter.updateConfiguration(
            schedule: _schedule,
            viewportWidth: constraints.maxWidth,
            topPadding: topPadding,
          );
          return RepaintBoundary(
            child: ClipRect(
              child: CustomPaint(
                painter: _painter,
                isComplex: true,
                willChange: true,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenPlayer extends HookConsumerWidget {
  const FullScreenPlayer({
    super.key,
    required this.controllerListenable,
    required this.videoId,
    this.playSources = const [],
    this.videoTitle,
  });

  final ValueListenable<MediaKitPlayerController?> controllerListenable;
  final String? videoTitle;
  final int videoId;
  final List<PlaySource> playSources;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformController = ref.watch(appPlatformControllerProvider);
    useEffect(() {
      unawaited(platformController.configureFullScreenSurface());
      VolumeController.instance.showSystemUI = false;
      return () {
        unawaited(platformController.cleanupFullScreenSurface());
      };
    }, [platformController]);

    return ValueListenableBuilder<MediaKitPlayerController?>(
      valueListenable: controllerListenable,
      builder: (context, controller, child) {
        if (controller == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        return _FullScreenPlayerContent(
          controller: controller,
          videoId: videoId,
          playSources: playSources,
          videoTitle: videoTitle,
        );
      },
    );
  }
}

class _FullScreenPlayerContent extends HookConsumerWidget {
  _FullScreenPlayerContent({
    required this.controller,
    required this.videoId,
    this.playSources = const [],
    this.videoTitle,
  });

  final String? videoTitle;
  final int videoId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MediaKitPlayerController controller;
  final List<PlaySource> playSources; // 播放源列表

  String formatDuration(Duration duration) {
    String two(int n) => n.toString().padLeft(2, '0');
    final hours = two(duration.inHours);
    final minutes = two(duration.inMinutes.remainder(60));
    final seconds = two(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String _formatPlaybackSpeed(double speed) {
    return speed == speed.truncateToDouble()
        ? speed.toStringAsFixed(1)
        : speed.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
  }

  // ---------- 抽取的指示器组件 ----------

  /// 长按倍速指示器（3x）
  Widget _buildSpeedIndicator() {
    return Positioned(
      top: 70,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            '3倍速播放中',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ),
    );
  }

  /// 拖拽进度指示器（hh:mm:ss / hh:mm:ss）
  Widget _buildSeekIndicator(Duration current, Duration total) {
    return Positioned(
      top: 70,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            '${formatDuration(current)} / ${formatDuration(total)}',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ),
    );
  }

  /// 亮度指示器
  Widget _buildBrightnessIndicator(double brightness) {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppVectorIcon(
                AppVectorIcons.sun,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: brightness,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(brightness * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 音量指示器
  Widget _buildVolumeIndicator(double volume) {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppVectorIcon(
                volume > 0 ? AppVectorIcons.volume : AppVectorIcons.volumeOff,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: volume,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(volume * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeDrawer(BuildContext context, WidgetRef ref) {
    if (playSources.isEmpty) {
      return const Center(
        child: Text('暂无选集', style: TextStyle(color: Colors.white54)),
      );
    }

    final selection = ref.watch(episodeSelectionProvider(videoId));
    final sourceIndex = selection.sourceIndex
        .clamp(0, playSources.length - 1)
        .toInt();
    final currentSource = playSources[sourceIndex];
    final episodes = currentSource.episodes;
    final episodeIndex = episodes.isEmpty
        ? 0
        : selection.episodeIndex.clamp(0, episodes.length - 1).toInt();
    final currentEpisodeLabel = episodes.isEmpty
        ? '暂无剧集'
        : episodes[episodeIndex].label;

    return Builder(
      builder: (drawerContext) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFA101418),
            border: Border(left: BorderSide(color: Colors.white12)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 8, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '选集',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${playSources.length} 个播放源 · ${episodes.length} 集',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _PlayerControlButton(
                        semanticLabel: '关闭选集',
                        onPressed: () => Navigator.of(drawerContext).pop(),
                        child: const AppVectorIcon(
                          AppVectorIcons.x,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.white12),
                if (episodes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Row(
                      children: [
                        const AppVectorIcon(
                          AppVectorIcons.audioLines,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            currentEpisodeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: Text(
                            currentSource.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 9),
                  child: Row(
                    children: [
                      const Text(
                        '播放源',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        '${playSources.length}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: playSources.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final source = playSources[index];
                      return _buildDrawerSourceChip(
                        context,
                        label: source.name,
                        episodeCount: source.episodes.length,
                        selected: sourceIndex == index,
                        onTap: () => ref
                            .read(episodeSelectionProvider(videoId).notifier)
                            .selectSource(index),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 11),
                  child: Row(
                    children: [
                      const Text(
                        '剧集',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${episodes.length}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppVectorIcon(
                                AppVectorIcons.library,
                                color: Colors.white30,
                                size: 38,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '该播放源暂无剧集',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        );
                      }
                      var widestLabelUnits = 0.0;
                      for (final episode in episodes) {
                        final units = episode.label.runes.fold<double>(
                          0,
                          (sum, rune) => sum + (rune <= 0x7F ? 0.58 : 1),
                        );
                        widestLabelUnits = math.max(widestLabelUnits, units);
                      }
                      final availableGridWidth = math.max(
                        1.0,
                        constraints.maxWidth - 40,
                      );
                      final scaledFontSize = MediaQuery.textScalerOf(
                        context,
                      ).scale(12);
                      final preferredTileWidth =
                          (widestLabelUnits * scaledFontSize + 38).clamp(
                            104.0,
                            190.0,
                          );
                      final columns =
                          ((availableGridWidth + 10) /
                                  (preferredTileWidth + 10))
                              .floor()
                              .clamp(1, 4);
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 46,
                        ),
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          return _buildDrawerEpisodeTile(
                            context,
                            label: episodes[index].label,
                            selected: episodeIndex == index,
                            onTap: () {
                              ref
                                  .read(
                                    episodeSelectionProvider(videoId).notifier,
                                  )
                                  .selectEpisode(index);
                              Navigator.of(drawerContext).pop();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaybackSpeedDrawer(BuildContext context) {
    return Builder(
      builder: (drawerContext) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFA101418),
            border: Border(left: BorderSide(color: Colors.white12)),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final currentSpeed = controller.value.playbackSpeed;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 8, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '倍速',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '当前 ${_formatPlaybackSpeed(currentSpeed)}x',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _PlayerControlButton(
                            semanticLabel: '关闭倍速选择',
                            onPressed: () => Navigator.of(drawerContext).pop(),
                            child: const AppVectorIcon(
                              AppVectorIcons.x,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white12),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 48,
                            ),
                        itemCount: _playbackSpeedOptions.length,
                        itemBuilder: (context, index) {
                          final speed = _playbackSpeedOptions[index];
                          final selected = (currentSpeed - speed).abs() < 0.001;
                          return _buildDrawerSpeedTile(
                            context,
                            speed: speed,
                            selected: selected,
                            onTap: () {
                              unawaited(controller.setPlaybackSpeed(speed));
                              Navigator.of(drawerContext).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerSpeedTile(
    BuildContext context, {
    required double speed,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _drawerMotionDuration;
    final label = '${_formatPlaybackSpeed(speed)}x';
    return Semantics(
      button: true,
      selected: selected,
      label: selected ? '播放速度 $label，已选择' : '播放速度 $label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: selected ? 0.07 : 0.04),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.white24,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18,
                  child: selected
                      ? const AppVectorIcon(
                          AppVectorIcons.check,
                          size: 17,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerSourceChip(
    BuildContext context, {
    required String label,
    required int episodeCount,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _drawerMotionDuration;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label，$episodeCount 集',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.white24,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: duration,
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
                    color: selected ? Colors.white : Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$episodeCount',
                  style: TextStyle(
                    color: selected ? AppColors.primary : Colors.white38,
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

  Widget _buildDrawerEpisodeTile(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _drawerMotionDuration;
    return Semantics(
      button: true,
      selected: selected,
      label: selected ? '$label，正在播放' : label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.white24,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selected) ...[
                  const AppVectorIcon(
                    AppVectorIcons.play,
                    size: 16,
                    color: AppColors.primary,
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
                      color: selected ? Colors.white : Colors.white70,
                      fontSize: 12,
                      height: 1.18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- 主构建 ----------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformController = ref.watch(appPlatformControllerProvider);
    final controlsVisible = useMemoized(() => ValueNotifier(true));
    final hideTimer = useRef<Timer?>(null);
    final isExitingFullScreen = useRef(false);

    final isSpeeding = useMemoized(() => ValueNotifier(false));
    final speedBeforeLongPress = useRef(1.0);
    final drawerMode = useMemoized(
      () => ValueNotifier(_FullScreenDrawerMode.episodes),
    );

    final isDragging = useMemoized(() => ValueNotifier(false));
    final dragProgress = useMemoized(() => ValueNotifier(Duration.zero));
    final dragStartGlobalX = useRef<double>(0);
    final dragStartPositionMs = useRef<double>(0);
    final sliderPointerActive = useRef(false);
    final ignoreHorizontalDrag = useRef(false);
    final sliderSeekPosition = useMemoized(
      () => ValueNotifier<Duration?>(null),
    );
    // 亮度/音量调节状态
    final isAdjustingBrightness = useMemoized(() => ValueNotifier(false));
    final isAdjustingVolume = useMemoized(() => ValueNotifier(false));
    final brightness = useMemoized(
      () => ValueNotifier(ref.read(screenBrightnessProvider)),
    );
    final volume = useMemoized(() => ValueNotifier(ref.read(volumeProvider)));
    final brightnessSetter = useMemoized(
      () => _ThrottledPlatformValueSetter(
        (value) => ScreenBrightness().setApplicationScreenBrightness(value),
      ),
    );
    final volumeSetter = useMemoized(
      () => _ThrottledPlatformValueSetter(
        (value) => VolumeController.instance.setVolume(value),
      ),
    );

    // 全局状态
    final showDanmaku = ref.watch(danmakuEnabledProvider);

    final adjustStartValue = useRef(0.0); // 手势起始时的亮度/音量值
    final adjustStartY = useRef<double>(0);
    final currentTime = useMemoized(() => ValueNotifier(DateTime.now()));
    final batteryLevel = useMemoized(() => ValueNotifier<int?>(null));
    final batteryState = useMemoized(() => ValueNotifier(BatteryState.unknown));
    final battery = useRef(Battery());

    useEffect(() {
      return () {
        controlsVisible.dispose();
        isSpeeding.dispose();
        drawerMode.dispose();
        isDragging.dispose();
        dragProgress.dispose();
        sliderSeekPosition.dispose();
        isAdjustingBrightness.dispose();
        isAdjustingVolume.dispose();
        brightness.dispose();
        volume.dispose();
        currentTime.dispose();
        batteryLevel.dispose();
        batteryState.dispose();
        brightnessSetter.dispose();
        volumeSetter.dispose();
      };
    }, const []);

    final selection = ref.watch(episodeSelectionProvider(videoId));
    final videoWidget = useMemoized(
      () => RepaintBoundary(
        child: Video(
          controller: controller.videoController,
          controls: NoVideoControls,
          fit: BoxFit.contain,
        ),
      ),
      [controller.videoController],
    );
    final danmakuAsync = ref.watch(
      danmakuListProvider((
        videoId: videoId,
        sourceIndex: selection.sourceIndex,
        episodeIndex: selection.episodeIndex,
      )),
    );
    final danmakuItems = danmakuAsync.asData?.value ?? const <DanmakuItem>[];
    final selectedSource = playSources.isEmpty
        ? null
        : playSources[selection.sourceIndex
              .clamp(0, playSources.length - 1)
              .toInt()];
    final selectedEpisodes = selectedSource?.episodes ?? const <Episode>[];
    final episodeLabel = selectedEpisodes.isEmpty
        ? null
        : selectedEpisodes[selection.episodeIndex
                  .clamp(0, selectedEpisodes.length - 1)
                  .toInt()]
              .label;
    // 初始化亮度 & 音量
    useEffect(() {
      var cancelled = false;
      // 读取当前系统亮度（0-1）
      ScreenBrightness().application
          .then((value) {
            if (cancelled) return;
            brightness.value = value;
            ref.read(screenBrightnessProvider.notifier).state = value;
          })
          .catchError((_) {
            if (cancelled) return;
            brightness.value = 0.5;
            ref.read(screenBrightnessProvider.notifier).state = 0.5;
          });
      // 读取当前音量
      try {
        VolumeController.instance
            .getVolume()
            .then((value) {
              if (cancelled) return;
              volume.value = value;
              ref.read(volumeProvider.notifier).state = value;
            })
            .catchError((_) {
              if (cancelled) return;
              volume.value = 0.5;
              ref.read(volumeProvider.notifier).state = 0.5;
            });
      } catch (_) {
        if (!cancelled) {
          volume.value = 0.5;
          ref.read(volumeProvider.notifier).state = 0.5;
        }
      }
      return () => cancelled = true;
    }, []);

    // 更新时间 & 监听电量
    useEffect(() {
      var cancelled = false;

      Future<void> refreshBattery() async {
        try {
          final level = await battery.value.batteryLevel;
          if (!cancelled) {
            batteryLevel.value = level < 0 ? null : level.clamp(0, 100).toInt();
          }
        } catch (_) {
          if (!cancelled) batteryLevel.value = null;
        }
      }

      Future<void> refreshBatteryState() async {
        try {
          final state = await battery.value.batteryState;
          if (!cancelled) batteryState.value = state;
        } catch (_) {
          if (!cancelled) batteryState.value = BatteryState.unknown;
        }
      }

      // battery_plus does not expose a level stream, so poll while fullscreen.
      final timer = Timer.periodic(const Duration(seconds: 15), (_) {
        if (cancelled) return;
        currentTime.value = DateTime.now();
        unawaited(refreshBattery());
      });

      unawaited(refreshBattery());
      unawaited(refreshBatteryState());

      StreamSubscription<BatteryState>? stateSub;
      stateSub = battery.value.onBatteryStateChanged.listen(
        (state) {
          if (cancelled) return;
          batteryState.value = state;
          unawaited(refreshBattery());
        },
        onError: (_) {
          if (!cancelled) batteryState.value = BatteryState.unknown;
        },
      );

      return () {
        cancelled = true;
        timer.cancel();
        stateSub?.cancel();
      };
    }, []);

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

    Future<void> exitFullScreen(BuildContext context) async {
      if (isExitingFullScreen.value) return;
      isExitingFullScreen.value = true;
      try {
        await platformController.dismissFullScreen(context);
      } catch (_) {
        isExitingFullScreen.value = false;
        rethrow;
      }
    }

    useEffect(() {
      startHideTimer();
      return () {
        hideTimer.value?.cancel();
      };
    }, []);

    double calculateSeekSeconds(double deltaX, double screenWidth) {
      return (deltaX / screenWidth) * 300;
    }

    void seekBy(Duration offset) {
      final value = controller.value;
      if (!value.isInitialized || value.duration <= Duration.zero) return;
      final targetMilliseconds = (value.position + offset).inMilliseconds.clamp(
        0,
        value.duration.inMilliseconds,
      );
      unawaited(
        controller.seekTo(Duration(milliseconds: targetMilliseconds.toInt())),
      );
      showControls();
    }

    return platformController.wrapFullScreenShortcuts(
      seekBackward: () => seekBy(const Duration(seconds: -10)),
      seekForward: () => seekBy(const Duration(seconds: 10)),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await exitFullScreen(context);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          endDrawer: Drawer(
            width: platformController.episodeDrawerWidth(
              MediaQuery.sizeOf(context).width,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            child: ValueListenableBuilder<_FullScreenDrawerMode>(
              valueListenable: drawerMode,
              builder: (context, mode, child) {
                return switch (mode) {
                  _FullScreenDrawerMode.episodes => _buildEpisodeDrawer(
                    context,
                    ref,
                  ),
                  _FullScreenDrawerMode.playbackSpeed =>
                    _buildPlaybackSpeedDrawer(context),
                };
              },
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,

                // 手势处理
                onTap: () {
                  if (controlsVisible.value) {
                    controlsVisible.value = false;
                    hideTimer.value?.cancel();
                  } else {
                    showControls();
                  }
                },
                onDoubleTap: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                onLongPressStart: (_) {
                  speedBeforeLongPress.value = controller.value.playbackSpeed;
                  controller.setPlaybackSpeed(3.0);
                  isSpeeding.value = true;
                },
                onLongPressEnd: (_) {
                  controller.setPlaybackSpeed(speedBeforeLongPress.value);
                  isSpeeding.value = false;
                },
                onHorizontalDragStart: (details) {
                  ignoreHorizontalDrag.value = sliderPointerActive.value;
                  if (ignoreHorizontalDrag.value) return;
                  dragStartGlobalX.value = details.globalPosition.dx;
                  dragStartPositionMs.value = controller
                      .value
                      .position
                      .inMilliseconds
                      .toDouble();
                  isDragging.value = true;
                },
                onHorizontalDragUpdate: (details) {
                  if (ignoreHorizontalDrag.value) return;
                  final deltaX =
                      details.globalPosition.dx - dragStartGlobalX.value;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final seekSeconds = calculateSeekSeconds(deltaX, screenWidth);
                  final targetMs =
                      dragStartPositionMs.value + seekSeconds * 1000;
                  final clampedMs = targetMs.clamp(
                    0,
                    controller.value.duration.inMilliseconds.toDouble(),
                  );
                  dragProgress.value = Duration(
                    milliseconds: clampedMs.toInt(),
                  );
                },
                onHorizontalDragEnd: (_) {
                  if (ignoreHorizontalDrag.value) {
                    ignoreHorizontalDrag.value = false;
                    return;
                  }
                  isDragging.value = false;
                  unawaited(controller.seekTo(dragProgress.value));
                },
                onHorizontalDragCancel: () {
                  ignoreHorizontalDrag.value = false;
                  isDragging.value = false;
                },

                // ========== 垂直拖动：亮度/音量调节 ==========
                onVerticalDragStart: (details) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final isLeft = details.localPosition.dx < screenWidth / 2;
                  if (isLeft) {
                    isAdjustingBrightness.value = true;
                    adjustStartValue.value = brightness.value;
                  } else {
                    isAdjustingVolume.value = true;
                    adjustStartValue.value = volume.value;
                  }
                  adjustStartY.value = details.globalPosition.dy;
                },
                onVerticalDragUpdate: (details) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  // 拖动距离占屏幕高度的比例，转换为数值变化（上滑增加，下滑减少）
                  final dy = adjustStartY.value - details.globalPosition.dy;
                  final ratio = dy / screenHeight;
                  final newValue = (adjustStartValue.value + ratio).clamp(
                    0.0,
                    1.0,
                  );

                  if (isAdjustingBrightness.value) {
                    brightness.value = newValue;
                    ref.read(screenBrightnessProvider.notifier).state =
                        newValue;
                    brightnessSetter.set(newValue);
                  } else if (isAdjustingVolume.value) {
                    volume.value = newValue;
                    ref.read(volumeProvider.notifier).state = newValue;
                    volumeSetter.set(newValue);
                  }
                },
                onVerticalDragEnd: (_) {
                  brightnessSetter.flush();
                  volumeSetter.flush();
                  isAdjustingBrightness.value = false;
                  isAdjustingVolume.value = false;
                },
                onVerticalDragCancel: () {
                  brightnessSetter.flush();
                  volumeSetter.flush();
                  isAdjustingBrightness.value = false;
                  isAdjustingVolume.value = false;
                },

                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 视频画面
                    videoWidget,

                    if (showDanmaku && danmakuItems.isNotEmpty)
                      _DanmakuOverlay(
                        controller: controller,
                        items: danmakuItems,
                      ),
                  ],
                ),
              ),

              // 缓冲加载指示器
              Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    controller,
                    isSpeeding,
                    isDragging,
                  ]),
                  builder: (context, child) {
                    final value = controller.value;
                    if (!value.isInitialized ||
                        !value.isBuffering ||
                        isSpeeding.value ||
                        isDragging.value) {
                      return const SizedBox.shrink();
                    }
                    return child!;
                  },
                  child: const Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Text(
                          '正在缓冲...',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 抽取的指示器：倍速 / 拖拽进度（同一位置，互斥显示）
              AnimatedBuilder(
                animation: Listenable.merge([
                  isSpeeding,
                  isDragging,
                  dragProgress,
                ]),
                builder: (context, child) => Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isSpeeding.value) _buildSpeedIndicator(),
                    if (isDragging.value)
                      _buildSeekIndicator(
                        dragProgress.value,
                        controller.value.duration,
                      ),
                  ],
                ),
              ),

              // 亮度 / 音量指示器
              AnimatedBuilder(
                animation: Listenable.merge([
                  isAdjustingBrightness,
                  isAdjustingVolume,
                  brightness,
                  volume,
                ]),
                builder: (context, child) => Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isAdjustingBrightness.value)
                      _buildBrightnessIndicator(brightness.value),
                    if (isAdjustingVolume.value)
                      _buildVolumeIndicator(volume.value),
                  ],
                ),
              ),

              // 顶部信息栏（包含返回、剧名/集数、时间、电量）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    controlsVisible,
                    currentTime,
                    batteryLevel,
                    batteryState,
                  ]),
                  builder: (context, child) {
                    final visible = controlsVisible.value;
                    final fadeDuration = MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : _controlsFadeDuration;
                    return AnimatedOpacity(
                      opacity: visible ? 1.0 : 0.0,
                      duration: fadeDuration,
                      child: IgnorePointer(
                        ignoring: !visible,
                        child: Container(
                          color: Colors.transparent,
                          child: SafeArea(
                            bottom: false,
                            child: _FullScreenTopBar(
                              videoTitle: videoTitle,
                              episodeLabel: episodeLabel,
                              currentTime: currentTime.value,
                              batteryLevel: batteryLevel.value,
                              batteryState: batteryState.value,
                              onBack: () => exitFullScreen(context),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 底部控制栏（两行布局）
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: controlsVisible,
                  builder: (context, visible, child) {
                    final fadeDuration = MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : _controlsFadeDuration;
                    return AnimatedOpacity(
                      opacity: visible ? 1.0 : 0.0,
                      duration: fadeDuration,
                      child: IgnorePointer(ignoring: !visible, child: child),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: SafeArea(
                      top: false,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 600;
                          final horizontalPadding = compact ? 12.0 : 24.0;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 第一行：进度条 + 时间
                                AnimatedBuilder(
                                  animation: Listenable.merge([
                                    controller,
                                    sliderSeekPosition,
                                  ]),
                                  builder: (context, child) {
                                    final value = controller.value;
                                    final durationMs = value
                                        .duration
                                        .inMilliseconds
                                        .toDouble();
                                    final displayPosition =
                                        sliderSeekPosition.value ??
                                        value.position;
                                    final sliderMax = durationMs
                                        .clamp(1, double.infinity)
                                        .toDouble();
                                    final displayPositionMs = displayPosition
                                        .inMilliseconds
                                        .toDouble()
                                        .clamp(0, sliderMax)
                                        .toDouble();
                                    final bufferedMs = math
                                        .max(
                                          displayPositionMs,
                                          value.buffer.inMilliseconds
                                              .toDouble(),
                                        )
                                        .clamp(0, sliderMax)
                                        .toDouble();
                                    return Row(
                                      children: [
                                        Text(
                                          formatDuration(displayPosition),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: compact ? 4 : 10),
                                        Expanded(
                                          child: Listener(
                                            onPointerDown: (_) {
                                              sliderPointerActive.value = true;
                                            },
                                            onPointerUp: (_) {
                                              sliderPointerActive.value = false;
                                            },
                                            onPointerCancel: (_) {
                                              sliderPointerActive.value = false;
                                              sliderSeekPosition.value = null;
                                            },
                                            child: SliderTheme(
                                              data: SliderTheme.of(context).copyWith(
                                                trackHeight: 4,
                                                thumbShape:
                                                    const RoundSliderThumbShape(
                                                      enabledThumbRadius: 7,
                                                    ),
                                                overlayShape:
                                                    const RoundSliderOverlayShape(
                                                      overlayRadius: 18,
                                                    ),
                                                activeTrackColor: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                secondaryActiveTrackColor:
                                                    Colors.white54,
                                                inactiveTrackColor:
                                                    Colors.white24,
                                                thumbColor: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                              child: Slider(
                                                value: displayPositionMs,
                                                max: sliderMax,
                                                secondaryTrackValue: bufferedMs,
                                                onChangeStart: (value) {
                                                  sliderSeekPosition
                                                      .value = Duration(
                                                    milliseconds: value.toInt(),
                                                  );
                                                },
                                                onChanged: (value) {
                                                  sliderSeekPosition
                                                      .value = Duration(
                                                    milliseconds: value.toInt(),
                                                  );
                                                },
                                                onChangeEnd: (value) async {
                                                  final position = Duration(
                                                    milliseconds: value.toInt(),
                                                  );
                                                  sliderSeekPosition.value =
                                                      position;
                                                  await controller.seekTo(
                                                    position,
                                                  );
                                                  if (context.mounted) {
                                                    sliderSeekPosition.value =
                                                        null;
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: compact ? 4 : 10),
                                        Text(
                                          formatDuration(value.duration),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                // 第二行：控制按钮
                                Row(
                                  children: [
                                    // 播放/暂停按钮
                                    AnimatedBuilder(
                                      animation: controller,
                                      builder: (context, child) {
                                        final isPlaying =
                                            controller.value.isPlaying;
                                        return _PlayerControlButton(
                                          semanticLabel: isPlaying
                                              ? '暂停'
                                              : '播放',
                                          prominent: true,
                                          onPressed: () {
                                            if (isPlaying) {
                                              controller.pause();
                                            } else {
                                              controller.play();
                                            }
                                          },
                                          child: child!,
                                        );
                                      },
                                      child: _PlaybackStateIcon(
                                        controller: controller,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // 弹幕按钮
                                    _PlayerControlButton(
                                      semanticLabel:
                                          ref.watch(danmakuEnabledProvider)
                                          ? '关闭弹幕'
                                          : '开启弹幕',
                                      selected: ref.watch(
                                        danmakuEnabledProvider,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              danmakuEnabledProvider.notifier,
                                            )
                                            .update((state) => !state);
                                      },
                                      child: ref.watch(danmakuEnabledProvider)
                                          ? SvgPicture.string(
                                              BearsSVG.danmakuLineSVG,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    Color(0xFF8DBBFA),
                                                    BlendMode.srcIn,
                                                  ),
                                              height: 22,
                                              width: 22,
                                            )
                                          : SvgPicture.string(
                                              BearsSVG.danmakuOffLineSVG,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn,
                                                  ),
                                              height: 22,
                                              width: 22,
                                            ),
                                    ),
                                    // 将退出全屏推到最右侧
                                    const Spacer(),

                                    AnimatedBuilder(
                                      animation: controller,
                                      builder: (context, child) {
                                        final speed =
                                            controller.value.playbackSpeed;
                                        return _PlayerLabeledControl(
                                          semanticLabel:
                                              '选择播放速度，当前 ${_formatPlaybackSpeed(speed)} 倍',
                                          label:
                                              '倍速 ${_formatPlaybackSpeed(speed)}x',
                                          onPressed: () {
                                            drawerMode.value =
                                                _FullScreenDrawerMode
                                                    .playbackSpeed;
                                            _scaffoldKey.currentState
                                                ?.openEndDrawer();
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),

                                    // 选集按钮（有数据时显示）
                                    if (playSources.isNotEmpty)
                                      _PlayerLabeledControl(
                                        semanticLabel: '打开选集',
                                        label: '选集',
                                        onPressed: () {
                                          drawerMode.value =
                                              _FullScreenDrawerMode.episodes;
                                          _scaffoldKey.currentState
                                              ?.openEndDrawer();
                                        },
                                      ),
                                    if (playSources.isNotEmpty)
                                      const SizedBox(width: 6),
                                    _PlayerControlButton(
                                      semanticLabel: '退出全屏',
                                      onPressed: () => exitFullScreen(context),
                                      child: SvgPicture.string(
                                        BearsSVG.exitFullScreenSVG,
                                        width: 22,
                                        height: 22,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
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
  }
}

class _PlaybackStateIcon extends StatefulWidget {
  const _PlaybackStateIcon({required this.controller});

  final MediaKitPlayerController controller;

  @override
  State<_PlaybackStateIcon> createState() => _PlaybackStateIconState();
}

class _PlaybackStateIconState extends State<_PlaybackStateIcon> {
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_syncPlayingState);
  }

  @override
  void didUpdateWidget(covariant _PlaybackStateIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller.removeListener(_syncPlayingState);
      _isPlaying = widget.controller.value.isPlaying;
      widget.controller.addListener(_syncPlayingState);
    }
  }

  void _syncPlayingState() {
    final next = widget.controller.value.isPlaying;
    if (next == _isPlaying || !mounted) return;
    setState(() => _isPlaying = next);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncPlayingState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _isPlaying ? BearsSVG.pauseSVG : BearsSVG.playSVG,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      height: 22,
      width: 22,
    );
  }
}

class _PlayerControlButton extends StatefulWidget {
  const _PlayerControlButton({
    required this.semanticLabel,
    required this.onPressed,
    required this.child,
    this.selected = false,
    this.prominent = false,
  });

  final String semanticLabel;
  final VoidCallback onPressed;
  final Widget child;
  final bool selected;
  final bool prominent;

  @override
  State<_PlayerControlButton> createState() => _PlayerControlButtonState();
}

class _PlayerControlButtonState extends State<_PlayerControlButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final dimension = widget.prominent ? 48.0 : 44.0;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: SizedBox.square(
            dimension: dimension,
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.child,
                if (_focused)
                  const Positioned(
                    left: 10,
                    right: 10,
                    bottom: 3,
                    child: SizedBox(
                      height: 2,
                      child: ColoredBox(color: Colors.white),
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

class _PlayerLabeledControl extends StatefulWidget {
  const _PlayerLabeledControl({
    required this.semanticLabel,
    required this.label,
    required this.onPressed,
  });

  final String semanticLabel;
  final String label;
  final VoidCallback onPressed;

  @override
  State<_PlayerLabeledControl> createState() => _PlayerLabeledControlState();
}

class _PlayerLabeledControlState extends State<_PlayerLabeledControl> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 52, minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  if (_focused)
                    const Positioned(
                      left: 2,
                      right: 2,
                      bottom: 3,
                      child: SizedBox(
                        height: 2,
                        child: ColoredBox(color: Colors.white),
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

class _FullScreenTopBar extends StatelessWidget {
  const _FullScreenTopBar({
    required this.videoTitle,
    required this.episodeLabel,
    required this.currentTime,
    required this.batteryLevel,
    required this.batteryState,
    required this.onBack,
  });

  final String? videoTitle;
  final String? episodeLabel;
  final DateTime currentTime;
  final int? batteryLevel;
  final BatteryState batteryState;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;
        final hasTitle = videoTitle != null && videoTitle!.trim().isNotEmpty;
        final hasEpisode =
            episodeLabel != null && episodeLabel!.trim().isNotEmpty;
        final time =
            '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 18),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _PlayerControlButton(
                        semanticLabel: '返回',
                        onPressed: onBack,
                        child: const AppVectorIcon(
                          AppVectorIcons.chevronLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: hasTitle
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    videoTitle!.trim(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: compact ? 14 : 15,
                                    ),
                                  ),
                                  if (hasEpisode)
                                    Text(
                                      episodeLabel!.trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Semantics(
                    label: '时间 $time',
                    excludeSemantics: true,
                    child: Center(
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _PlayerStatus(
                      batteryLevel: batteryLevel,
                      batteryState: batteryState,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlayerStatus extends StatelessWidget {
  const _PlayerStatus({required this.batteryLevel, required this.batteryState});

  final int? batteryLevel;
  final BatteryState batteryState;

  @override
  Widget build(BuildContext context) {
    final level = batteryLevel;
    final charging =
        batteryState == BatteryState.charging ||
        batteryState == BatteryState.full;
    final connectedNotCharging =
        batteryState == BatteryState.connectedNotCharging;
    final levelLabel = level == null ? '不可用' : '$level%';
    return Semantics(
      container: true,
      label:
          '电量 $levelLabel${charging
              ? '，正在充电'
              : connectedNotCharging
              ? '，已连接电源'
              : ''}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            level == null ? '--%' : '$level%',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(width: 4),
          if (charging || connectedNotCharging) ...[
            AppVectorIcon(
              charging ? AppVectorIcons.zap : AppVectorIcons.power,
              size: 13,
              color: Colors.white,
            ),
            const SizedBox(width: 2),
          ],
          _LiveBatteryIcon(level: level),
        ],
      ),
    );
  }
}

class _LiveBatteryIcon extends StatelessWidget {
  const _LiveBatteryIcon({required this.level});

  final int? level;

  @override
  Widget build(BuildContext context) {
    final fill = ((level ?? 0) / 100).clamp(0.0, 1.0);
    return SizedBox(
      width: 25,
      height: 13,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fill,
                  child: const ColoredBox(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 1),
          Container(
            width: 2,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(1)),
            ),
          ),
        ],
      ),
    );
  }
}
