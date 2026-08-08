import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/ui/featured_hero.dart';
import 'package:bears_video/src/rust/models/recommend_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FeaturedCarousel extends HookWidget {
  const FeaturedCarousel({super.key, required this.items});

  final List<BannerItem> items;

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(viewportFraction: 0.96);
    final activeIndex = useState(0);

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 238,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            onPageChanged: (value) => activeIndex.value = value,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FeaturedHero(item: items[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (index) {
            final isActive = index == activeIndex.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.outline,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}
