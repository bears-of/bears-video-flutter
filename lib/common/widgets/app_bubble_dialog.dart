import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

Future<T?> showAppBubbleDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.overlay,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, _, _) => SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 38),
          child: AppBubbleSurface(child: child),
        ),
      ),
    ),
    transitionBuilder: (_, animation, _, dialog) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.94, end: 1.0).animate(curved),
          child: dialog,
        ),
      );
    },
  );
}

Future<bool> showAppConfirmationBubble({
  required BuildContext context,
  required String title,
  required String message,
  String cancelLabel = '取消',
  String confirmLabel = '确定',
  bool destructive = false,
}) async {
  final result = await showAppBubbleDialog<bool>(
    context: context,
    barrierDismissible: true,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    expand: true,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: destructive
                      ? AppButton.danger(
                          expand: true,
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(confirmLabel),
                        )
                      : AppButton(
                          expand: true,
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(confirmLabel),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

class AppBubbleSurface extends StatelessWidget {
  const AppBubbleSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.bubble,
            border: Border.all(color: AppColors.outline),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22103331),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
        const Positioned(
          bottom: -8,
          child: CustomPaint(size: Size(22, 10), painter: _BubbleTailPainter()),
        ),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;
    // Paint over the surface edge so the tail has no outlined seam below it.
    final path = Path()
      ..moveTo(0, -2)
      ..quadraticBezierTo(size.width / 2, size.height * 1.8, size.width, 0)
      ..close();
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
