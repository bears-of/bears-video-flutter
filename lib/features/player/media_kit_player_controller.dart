import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

@immutable
class MediaKitPlayerValue {
  const MediaKitPlayerValue({
    this.isInitialized = false,
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.playbackSpeed = 1,
    this.size = const Size(16, 9),
  });

  final bool isInitialized;
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final double playbackSpeed;
  final Size size;

  MediaKitPlayerValue copyWith({
    bool? isInitialized,
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    double? playbackSpeed,
    Size? size,
  }) {
    return MediaKitPlayerValue(
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      size: size ?? this.size,
    );
  }
}

class MediaKitPlayerController extends ValueNotifier<MediaKitPlayerValue> {
  MediaKitPlayerController.network(
    String url, {
    Map<String, String> httpHeaders = const {},
  }) : this._(url, httpHeaders: httpHeaders);

  MediaKitPlayerController.file(File file) : this._(file.uri.toString());

  MediaKitPlayerController._(
    this._resource, {
    Map<String, String> httpHeaders = const {},
  }) : _httpHeaders = httpHeaders,
       player = Player(),
       super(const MediaKitPlayerValue()) {
    videoController = VideoController(player);
  }

  final String _resource;
  final Map<String, String> _httpHeaders;
  final Player player;
  late final VideoController videoController;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Timer? _positionNotificationTimer;
  Duration? _pendingPosition;
  DateTime _lastPositionNotification = DateTime.fromMillisecondsSinceEpoch(0);
  bool _released = false;

  static const _positionNotificationInterval = Duration(milliseconds: 200);

  Future<void> initialize() async {
    if (_released || value.isInitialized) return;

    _subscriptions.addAll([
      player.stream.playing.listen(
        (playing) => _update(value.copyWith(isPlaying: playing)),
      ),
      player.stream.buffering.listen(
        (buffering) => _update(value.copyWith(isBuffering: buffering)),
      ),
      player.stream.position.listen(_handlePosition),
      player.stream.duration.listen(
        (duration) => _update(value.copyWith(duration: duration)),
      ),
      player.stream.rate.listen(
        (rate) => _update(value.copyWith(playbackSpeed: rate)),
      ),
      player.stream.width.listen((width) => _updateVideoSize(width: width)),
      player.stream.height.listen((height) => _updateVideoSize(height: height)),
    ]);

    await player.open(
      Media(
        _resource,
        httpHeaders: _httpHeaders.isEmpty ? null : _httpHeaders,
      ),
      play: false,
    );
    final state = player.state;
    _update(
      value.copyWith(
        isInitialized: true,
        isPlaying: state.playing,
        isBuffering: state.buffering,
        position: state.position,
        duration: state.duration,
        playbackSpeed: state.rate,
        size: _sizeFrom(state.width, state.height),
      ),
    );
  }

  Future<void> play() => player.play();

  Future<void> pause() => player.pause();

  Future<void> seekTo(Duration position) async {
    _positionNotificationTimer?.cancel();
    _positionNotificationTimer = null;
    _pendingPosition = null;
    _lastPositionNotification = DateTime.now();
    _update(value.copyWith(position: position));
    await player.seek(position);
  }

  Future<void> setPlaybackSpeed(double speed) => player.setRate(speed);

  Future<void> setLooping(bool looping) => player.setPlaylistMode(
    looping ? PlaylistMode.single : PlaylistMode.none,
  );

  Future<void> release() async {
    if (_released) return;
    _released = true;
    _positionNotificationTimer?.cancel();
    _positionNotificationTimer = null;
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    await player.dispose();
    super.dispose();
  }

  void _updateVideoSize({int? width, int? height}) {
    final nextWidth = width ?? value.size.width.toInt();
    final nextHeight = height ?? value.size.height.toInt();
    _update(value.copyWith(size: _sizeFrom(nextWidth, nextHeight)));
  }

  void _handlePosition(Duration position) {
    if (_released) return;
    final elapsed = DateTime.now().difference(_lastPositionNotification);
    if (elapsed >= _positionNotificationInterval) {
      _positionNotificationTimer?.cancel();
      _positionNotificationTimer = null;
      _pendingPosition = null;
      _lastPositionNotification = DateTime.now();
      _update(value.copyWith(position: position));
      return;
    }

    _pendingPosition = position;
    _positionNotificationTimer ??= Timer(
      _positionNotificationInterval - elapsed,
      () {
        _positionNotificationTimer = null;
        final pending = _pendingPosition;
        _pendingPosition = null;
        if (pending == null || _released) return;
        _lastPositionNotification = DateTime.now();
        _update(value.copyWith(position: pending));
      },
    );
  }

  Size _sizeFrom(int? width, int? height) {
    if (width == null || height == null || width <= 0 || height <= 0) {
      return value.size;
    }
    return Size(width.toDouble(), height.toDouble());
  }

  void _update(MediaKitPlayerValue nextValue) {
    if (!_released) value = nextValue;
  }
}
