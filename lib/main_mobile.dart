import 'package:bears_video/common/app/app_bootstrap.dart';
import 'package:bears_video/mobile/features/shell/mobile_root_shell.dart';
import 'package:bears_video/mobile/platform/mobile_app_platform_controller.dart';

Future<void> main() => bootstrapApplication(
  platformController: MobileAppPlatformController(),
  rootShell: const MobileRootShell(),
);
