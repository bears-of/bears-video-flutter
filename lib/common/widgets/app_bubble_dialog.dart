import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

Future<T?> showAppBubbleDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.overlay,
    transitionDuration: reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 180),
    pageBuilder: (_, _, _) => Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 38),
            child: AppBubbleSurface(child: child),
          ),
        ),
      ),
    ),
    transitionBuilder: (_, animation, _, dialog) {
      if (reduceMotion) return dialog;
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
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (destructive) ...[
                  const AppVectorIcon(
                    AppVectorIcons.trash,
                    color: AppColors.danger,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: AppColors.ink, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            _ConfirmationActions(
              cancelLabel: cancelLabel,
              confirmLabel: confirmLabel,
              destructive: destructive,
              onCancel: () => Navigator.of(context).pop(false),
              onConfirm: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

class _ConfirmationActions extends StatelessWidget {
  const _ConfirmationActions({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.destructive,
    required this.onCancel,
    required this.onConfirm,
  });

  final String cancelLabel;
  final String confirmLabel;
  final bool destructive;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final scaledLabelSize = MediaQuery.textScalerOf(context).scale(14);

    Widget button({required bool confirm}) {
      return SizedBox(
        height: 48,
        child: confirm
            ? destructive
                  ? AppButton.danger(
                      expand: true,
                      onPressed: onConfirm,
                      child: Text(confirmLabel),
                    )
                  : AppButton(
                      expand: true,
                      onPressed: onConfirm,
                      child: Text(confirmLabel),
                    )
            : AppButton.secondary(
                expand: true,
                onPressed: onCancel,
                child: Text(cancelLabel),
              ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final stackActions = constraints.maxWidth < 280 || scaledLabelSize > 18;
        if (stackActions) {
          return Column(
            children: [
              SizedBox(width: double.infinity, child: button(confirm: false)),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: button(confirm: true)),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: button(confirm: false)),
            const SizedBox(width: 10),
            Expanded(child: button(confirm: true)),
          ],
        );
      },
    );
  }
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
