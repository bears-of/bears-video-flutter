import 'package:bears_video/common/app/app_bootstrap.dart';
import 'package:bears_video/desktop/features/shell/desktop_root_shell.dart';
import 'package:bears_video/desktop/platform/desktop_app_platform_controller.dart';

Future<void> main() => bootstrapApplication(
  platformController: DesktopAppPlatformController(),
  rootShell: const DesktopRootShell(),
);
