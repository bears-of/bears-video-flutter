import 'package:bears_video/common/platform/app_platform_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final class MobileAppPlatformController implements AppPlatformController {
  bool _playbackActive = false;
  Future<void> _wakelockUpdate = Future<void>.value();

  @override
  Future<void> initialize() async {}

  Future<void> _enterFullScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  Future<void> _exitFullScreen() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<void> presentFullScreen(
    BuildContext context,
    Route<void> route,
  ) async {
    final navigator = Navigator.of(context);
    final enteringFullScreen = _enterFullScreen();
    final navigation = navigator.push(route);
    try {
      await enteringFullScreen;
      await navigation;
    } catch (_) {
      if (navigator.mounted && route.isActive) {
        navigator.removeRoute(route);
      }
      await _exitFullScreen();
      rethrow;
    }
  }

  @override
  Future<void> dismissFullScreen(BuildContext context) async {
    final navigator = Navigator.of(context);
    await _exitFullScreen();
    if (navigator.mounted) {
      navigator.pop();
    }
  }

  @override
  Future<void> setPlaybackActive(bool active) {
    _playbackActive = active;
    _wakelockUpdate = _wakelockUpdate.catchError((Object _) {}).then((_) async {
      try {
        await WakelockPlus.toggle(enable: _playbackActive);
      } catch (error) {
        debugPrint('更新手机屏幕常亮状态失败: $error');
      }
    });
    return _wakelockUpdate;
  }

  @override
  double episodeDrawerWidth(double viewportWidth) => viewportWidth * 0.9;

  @override
  Widget wrapFullScreenShortcuts({
    required Widget child,
    required VoidCallback seekBackward,
    required VoidCallback seekForward,
  }) => child;
}
