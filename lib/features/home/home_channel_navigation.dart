import 'package:flutter/widgets.dart';

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
