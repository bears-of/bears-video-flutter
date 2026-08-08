import 'package:bears_video/common/features/shell/shell_content.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/features/shell/shell_providers.dart';
import 'package:bears_video/features/svg/bears_svg.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class DesktopRootShell extends ConsumerWidget {
  const DesktopRootShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(shellTabProvider);

    return Scaffold(
      body: Row(
        children: [
          _DesktopNavigation(
            currentTab: currentTab,
            onSelected: (tab) {
              ref.read(shellTabProvider.notifier).state = tab;
            },
          ),
          const VerticalDivider(width: 1, thickness: 1),
          const Expanded(child: ShellContent()),
        ],
      ),
    );
  }
}

class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({
    required this.currentTab,
    required this.onSelected,
  });

  final ShellTab currentTab;
  final ValueChanged<ShellTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 112,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 36),
              _DesktopNavItem(
                svg: BearsSVG.homeSVG,
                label: '首页',
                selected: currentTab == ShellTab.home,
                onTap: () => onSelected(ShellTab.home),
              ),
              const SizedBox(height: 10),
              _DesktopNavItem(
                svg: BearsSVG.userSVG,
                label: '我的',
                selected: currentTab == ShellTab.mine,
                onTap: () => onSelected(ShellTab.mine),
              ),
              const Spacer(),
              Tooltip(
                message: 'Bears Video',
                child: SvgPicture.string(
                  BearsSVG.bearsVideoSVG,
                  height: 50,
                  width: 50,
                  colorFilter: ColorFilter.mode(
                    AppColors.inkMuted,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  const _DesktopNavItem({
    required this.svg,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String svg;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          hoverColor: AppColors.primary.withValues(alpha: 0.08),
          focusColor: AppColors.primary.withValues(alpha: 0.12),
          child: SizedBox(
            width: double.infinity,
            height: 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.string(
                  svg,
                  colorFilter: ColorFilter.mode(
                    selected ? AppColors.primaryDark : AppColors.inkMuted,
                    BlendMode.srcIn,
                  ),
                  width: 25,
                  height: 25,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.inkMuted,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
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
