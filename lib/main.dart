import 'package:bears_video/core/app_config.dart';
import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/core/theme/app_theme.dart';
import 'package:bears_video/features/home/home_screen.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 << 20; // 最大缓存80M图片
  await RustLib.init();
  runApp(const ProviderScope(child: BearsApp()));
}

class BearsApp extends StatelessWidget {
  const BearsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _BearsAppView();
  }
}

class _BearsAppView extends StatefulWidget {
  const _BearsAppView({super.key});

  @override
  State<_BearsAppView> createState() => __BearsAppViewState();
}

class __BearsAppViewState extends State<_BearsAppView>
    with WidgetsBindingObserver {
  Future<void> initDependences() async {
    ApiService apiService = await ApiService.newInstance();
    sl.registerSingleton<ApiService>(apiService);
  }

  @override
  void initState() {
    super.initState();
    initDependences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 监听软件前后台的情况
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
