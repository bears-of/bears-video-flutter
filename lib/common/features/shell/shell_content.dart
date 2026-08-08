import 'package:bears_video/features/home/home_screen.dart';
import 'package:bears_video/features/mine/mine_screen.dart';
import 'package:bears_video/features/shell/shell_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShellContent extends ConsumerWidget {
  const ShellContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(shellTabProvider);

    return IndexedStack(
      index: currentTab.index,
      children: [HomeScreen(), MineScreen()],
    );
  }
}
