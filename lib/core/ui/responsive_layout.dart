import 'package:flutter/material.dart';

/// Shared, content-driven layout rules for phone, tablet, and desktop windows.
abstract final class ResponsiveLayout {
  static const double desktopBreakpoint = 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  static int posterColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1500) return 7;
    if (width >= 1240) return 6;
    if (width >= 1024) return 5;
    if (width >= 720) return 4;
    return 3;
  }

  static EdgeInsets pagePadding(BuildContext context) => isDesktop(context)
      ? const EdgeInsets.symmetric(horizontal: 32)
      : EdgeInsets.zero;
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 1180,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
