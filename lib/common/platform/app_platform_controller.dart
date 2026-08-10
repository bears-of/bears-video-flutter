import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Platform operations that must stay outside the shared application graph.
abstract interface class AppPlatformController {
  Future<void> initialize();

  Future<void> presentFullScreen(BuildContext context, Route<void> route);

  Future<void> dismissFullScreen(BuildContext context);

  Future<void> setPlaybackActive(bool active);

  double episodeDrawerWidth(double viewportWidth);

  Widget wrapFullScreenShortcuts({
    required Widget child,
    required VoidCallback seekBackward,
    required VoidCallback seekForward,
  });
}

final appPlatformControllerProvider = Provider<AppPlatformController>((ref) {
  throw StateError(
    'AppPlatformController is not configured. '
    'Build with lib/main_desktop.dart or lib/main_mobile.dart.',
  );
});
