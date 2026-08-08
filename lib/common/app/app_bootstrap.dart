import 'package:bears_video/common/platform/app_platform_controller.dart';
import 'package:bears_video/core/app_config.dart';
import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/core/theme/app_theme.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/api/database.dart' as rust_database;
import 'package:bears_video/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<void> bootstrapApplication({
  required AppPlatformController platformController,
  required Widget rootShell,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await platformController.initialize();
  MediaKit.ensureInitialized();
  await RustLib.init();
  final supportDirectory = await getApplicationSupportDirectory();
  await rust_database.initializeDatabase(
    directory: path.join(supportDirectory.path, 'database'),
  );
  final apiService = await ApiService.newInstance();
  sl.registerSingleton<ApiService>(apiService);

  runApp(
    ProviderScope(
      overrides: [
        appPlatformControllerProvider.overrideWithValue(platformController),
      ],
      child: BearsApp(rootShell: rootShell),
    ),
  );
}

class BearsApp extends StatelessWidget {
  const BearsApp({super.key, required this.rootShell});

  final Widget rootShell;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: rootShell,
    );
  }
}
