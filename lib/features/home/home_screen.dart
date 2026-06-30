import 'package:bears_video/core/di/injector.dart';
import 'package:bears_video/core/logger/log.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/ui/featured_carousel.dart';
import 'package:bears_video/src/rust/api/bears_api.dart';
import 'package:bears_video/src/rust/models/recommend_video.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterState extends Equatable {
  const CounterState({required this.counterNumber});
  final int counterNumber;

  CounterState copyWith({int? counterNumber}) {
    return CounterState(counterNumber: counterNumber ?? this.counterNumber);
  }

  @override
  List<Object?> get props => [counterNumber];
}

class Counter extends StateNotifier<CounterState> {
  Counter() : super(CounterState(counterNumber: 0));

  void increment() {
    state = state.copyWith(counterNumber: state.counterNumber + 1);
  }
}

final counterProvider = StateNotifierProvider<Counter, CounterState>(
  (_) => Counter(),
);

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  // ignore: unused_element
  Future<void> _getHomePageRecommendVideo() async {
    HomeRecommendData recommendData = await sl<ApiService>()
        .fetchHomeRecommend();
    AppLogger.longText(recommendData.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async {
          ref.read(counterProvider.notifier).increment();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 把普通 Widget 放进 CustomScrollView 的 sliver 列表里
            SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  return Stack(
                    children: [
                      // 把某个 Widget 单独隔离成一个绘制区域，尽量避免父组件或兄弟组件刷新时，连带它一起重绘。
                      FeaturedCarousel(pageController: pageController),
                    ],
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
