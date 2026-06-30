import 'package:bears_video/core/ui/featured_hero.dart';
import 'package:flutter/material.dart';

class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(height: 540, child: Stack(children: [_buildPager()])),
    );
  }

  Widget _buildPager() {
    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: pageController,
        builder: (context, _) {
          return _hero();
        },
      ),
    );
  }

  Widget _hero() => FeaturedHero();
}
