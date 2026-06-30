import 'package:bears_video/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FeaturedHero extends StatelessWidget {
  const FeaturedHero({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.bg),
          // Positioned 只能放在Stack
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.15),
                    radius: 1.05,
                    colors: [
                      AppColors.surface2.withValues(alpha: 0.66),
                      AppColors.surface2.withValues(alpha: 0.28),
                      const Color(0x000B0B0F),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 90, 16, 80),
            child: _card(),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://cdnjson.com/images/2023/07/26/p2894000057.webp',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            gaplessPlayback: true,
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surface2.withValues(alpha: 0.72),
                      AppColors.surface2.withValues(alpha: 0.34),
                      AppColors.surface2.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.16, 0.34, 0.52],
                  ),
                ),
              ),
            ),
          ),

          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x000B0B0F),
                      Color(0xB30B0B0F),
                      AppColors.bg,
                    ],
                    stops: [0.42, 0.72, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const SizedBox(height: 12), SizedBox(height: 18)],
            ),
          ),
        ],
      ),
    );
  }
}
