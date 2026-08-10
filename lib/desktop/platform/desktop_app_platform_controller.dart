import 'package:bears_video/common/platform/app_platform_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

final class DesktopAppPlatformController implements AppPlatformController {
  @override
  Future<void> initialize() async {
    await windowManager.ensureInitialized();
    await windowManager.setSize(const Size(1280, 980));
    await windowManager.center();
  }

  @override
  Future<void> presentFullScreen(
    BuildContext context,
    Route<void> route,
  ) async {
    final navigator = Navigator.of(context);
    final navigation = navigator.push(route);
    await WidgetsBinding.instance.endOfFrame;
    await windowManager.setFullScreen(true);
    await navigation;
  }

  @override
  Future<void> dismissFullScreen(BuildContext context) async {
    final navigator = Navigator.of(context);
    if (await windowManager.isFullScreen()) {
      await windowManager.setFullScreen(false);
    }
    if (navigator.mounted) {
      navigator.pop();
    }
  }

  @override
  Future<void> setPlaybackActive(bool active) async {}

  @override
  double episodeDrawerWidth(double viewportWidth) =>
      (viewportWidth * 0.34).clamp(420.0, 540.0).toDouble();

  @override
  Widget wrapFullScreenShortcuts({
    required Widget child,
    required VoidCallback seekBackward,
    required VoidCallback seekForward,
  }) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowLeft): seekBackward,
        const SingleActivator(LogicalKeyboardKey.arrowRight): seekForward,
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
