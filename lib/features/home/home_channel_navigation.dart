import 'package:flutter/widgets.dart';

class HomeChannelType {
  const HomeChannelType(this.label, this.typeId);

  final String label;
  final int? typeId;
}

const homeChannelTypes = <HomeChannelType>[
  HomeChannelType('首页', null),
  HomeChannelType('电影', 1),
  HomeChannelType('电视剧', 2),
  HomeChannelType('综艺', 3),
  HomeChannelType('动漫', 4),
  HomeChannelType('纪录片', 5),
  HomeChannelType('少儿', 208),
];

/// Moves between neighboring channels with a short animation, but jumps across
/// distant channels so intermediate pages are never presented to the user.
Future<void> navigateToHomeChannel({
  required PageController controller,
  required int currentIndex,
  required int targetIndex,
  required bool disableAnimations,
}) {
  if (!controller.hasClients || currentIndex == targetIndex) {
    return Future<void>.value();
  }

  final visiblePage = controller.page;
  final sourceIndex = visiblePage?.round() ?? currentIndex;
  final crossesIntermediatePages = (targetIndex - sourceIndex).abs() > 1;

  if (disableAnimations || crossesIntermediatePages) {
    controller.jumpToPage(targetIndex);
    return Future<void>.value();
  }

  return controller.animateToPage(
    targetIndex,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  );
}
