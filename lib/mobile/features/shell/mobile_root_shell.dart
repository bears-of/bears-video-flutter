import 'dart:ui';

import 'package:bears_video/common/features/shell/shell_content.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/features/shell/shell_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _navAnimationDuration = Duration(milliseconds: 320);
const _navPressDuration = Duration(milliseconds: 120);
const _navBarHeight = 76.0;

class MobileRootShell extends ConsumerWidget {
  const MobileRootShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(shellTabProvider);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final navDuration = disableAnimations
        ? Duration.zero
        : _navAnimationDuration;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        extendBody: true,
        body: const ShellContent(),
        // SafeArea 用于避免底部手势栏
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Material(
                color: Colors.transparent,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    color: AppColors.surface.withValues(alpha: 0.42),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.42),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 28,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: _navBarHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _CapsuleTabIndicator(
                          tab: currentTab,
                          duration: navDuration,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _NavItem(
                                onTap: () {
                                  ref.read(shellTabProvider.notifier).state =
                                      ShellTab.home;
                                },
                                selected: currentTab == ShellTab.home,
                                duration: navDuration,
                                disableAnimations: disableAnimations,
                                icon: Icons.home_rounded,
                                label: '首页',
                              ),
                            ),
                            Expanded(
                              child: _NavItem(
                                selected: currentTab == ShellTab.mine,
                                duration: navDuration,
                                disableAnimations: disableAnimations,
                                onTap: () {
                                  ref.read(shellTabProvider.notifier).state =
                                      ShellTab.mine;
                                },
                                icon: Icons.person_rounded,
                                label: '我的',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CapsuleTabIndicator extends StatelessWidget {
  const _CapsuleTabIndicator({required this.tab, required this.duration});

  final ShellTab tab;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      // layoutBuilder可以获取父组件的布局信息，通过父组件的布局信息来设置child布局
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / ShellTab.values.length;
          final indicatorWidth = (tabWidth - 18).clamp(88.0, 126.0).toDouble();
          final tabCenterX = tabWidth * (tab.index + 0.5);
          final indicatorLeft = tabCenterX - (indicatorWidth / 2);
          return Stack(
            children: [
              AnimatedPositioned(
                duration: duration,
                curve: Curves.easeOutCubic,
                left: indicatorLeft,
                top: 10,
                width: indicatorWidth,
                height: _navBarHeight - 20,
                child: const _GlassCapsule(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlassCapsule extends StatelessWidget {
  const _GlassCapsule();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.58),
              Colors.white.withValues(alpha: 0.24),
              AppColors.primary.withValues(alpha: 0.18),
            ],
            stops: const [0, 0.48, 1],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.58)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.32),
              blurRadius: 12,
              offset: const Offset(-4, -4),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 9,
              child: Container(
                width: 28,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 9,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.onTap,
    required this.selected,
    required this.duration,
    required this.disableAnimations,
    required this.icon,
    required this.label,
  });

  final GestureTapCallback onTap;
  final bool selected;
  final Duration duration;
  final bool disableAnimations;
  final IconData icon;
  final String label;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final pressDuration = widget.disableAnimations
        ? Duration.zero
        : _navPressDuration;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.965 : 1,
          duration: pressDuration,
          curve: Curves.easeOutCubic,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSlide(
                  offset: widget.selected
                      ? const Offset(0, -0.08)
                      : Offset.zero,
                  duration: widget.duration,
                  curve: Curves.easeOutCubic,
                  child: AnimatedScale(
                    scale: widget.selected ? 1.15 : 1,
                    duration: widget.duration,
                    curve: Curves.easeOutCubic,
                    child: SizedBox(
                      height: 36,
                      width: 44,
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          end: widget.selected
                              ? AppColors.primaryDark
                              : AppColors.inkMuted,
                        ),
                        duration: widget.duration,
                        curve: Curves.easeOutCubic,
                        builder: (context, color, child) {
                          return Icon(widget.icon, size: 24, color: color);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  height: 17,
                  child: AnimatedSlide(
                    offset: widget.selected
                        ? Offset.zero
                        : const Offset(0, 0.22),
                    duration: widget.duration,
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: widget.selected ? 1 : 0.28,
                      duration: widget.duration,
                      curve: Curves.easeOutCubic,
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          end: widget.selected
                              ? AppColors.primaryDark
                              : AppColors.inkMuted,
                        ),
                        duration: widget.duration,
                        builder: (context, color, child) {
                          return Text(
                            widget.label,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 11,
                              fontWeight: widget.selected
                                  ? FontWeight.w800
                                  : FontWeight.w700,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
