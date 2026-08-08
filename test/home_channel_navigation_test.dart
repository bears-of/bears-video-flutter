import 'dart:async';

import 'package:bears_video/features/home/home_channel_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _channelPager(
  PageController controller,
  ValueChanged<int> onPageChanged,
) {
  return MaterialApp(
    home: Scaffold(
      body: PageView.builder(
        controller: controller,
        itemCount: 5,
        onPageChanged: onPageChanged,
        itemBuilder: (_, index) => Center(child: Text('分类 $index')),
      ),
    ),
  );
}

void main() {
  testWidgets('distant category clicks jump without visiting middle pages', (
    tester,
  ) async {
    final controller = PageController();
    addTearDown(controller.dispose);
    final visited = <int>[];
    await tester.pumpWidget(_channelPager(controller, visited.add));
    visited.clear();

    await navigateToHomeChannel(
      controller: controller,
      currentIndex: 0,
      targetIndex: 4,
      disableAnimations: false,
    );
    await tester.pump();

    expect(controller.page, 4);
    expect(visited, <int>[4]);
  });

  testWidgets('neighboring category clicks keep the short transition', (
    tester,
  ) async {
    final controller = PageController();
    addTearDown(controller.dispose);
    final visited = <int>[];
    await tester.pumpWidget(_channelPager(controller, visited.add));
    visited.clear();

    final navigation = navigateToHomeChannel(
      controller: controller,
      currentIndex: 0,
      targetIndex: 1,
      disableAnimations: false,
    );
    unawaited(navigation);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(controller.page, greaterThan(0));
    expect(controller.page, lessThan(1));

    await tester.pump(const Duration(milliseconds: 200));
    await navigation;
    expect(controller.page, 1);
    expect(visited, <int>[1]);
  });
}
