import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/theme/app_radii.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// A button with an authored press response instead of Material ink effects.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.compact = false,
    this.expand = false,
    this.semanticLabel,
  });

  const AppButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
    this.compact = false,
    this.expand = false,
    this.semanticLabel,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.onPressed,
    required this.child,
    this.compact = true,
    this.expand = false,
    this.semanticLabel,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.onPressed,
    required this.child,
    this.compact = false,
    this.expand = false,
    this.semanticLabel,
  }) : variant = AppButtonVariant.danger;

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final bool compact;
  final bool expand;
  final String? semanticLabel;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_enabled || _pressed == value) return;
    setState(() => _pressed = value);
  }

  void _activate() {
    if (_enabled) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors();
    final height = widget.compact ? 34.0 : 42.0;
    final horizontalPadding = widget.compact ? 10.0 : 16.0;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget button = Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      onKeyEvent: (_, event) {
        final activationKey =
            event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space;
        if (!activationKey) return KeyEventResult.ignored;
        if (event is KeyDownEvent) _activate();
        return KeyEventResult.handled;
      },
      child: MouseRegion(
        cursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          onTap: _enabled ? _activate : null,
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1,
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 90),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 110),
              curve: Curves.easeOutCubic,
              constraints: BoxConstraints(minHeight: height),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _pressed ? colors.pressed : colors.background,
                borderRadius: AppRadii.control,
                border: Border.all(
                  color: _focused ? AppColors.focus : colors.border,
                  width: _focused ? 1.5 : 1,
                ),
              ),
              foregroundDecoration: !_enabled
                  ? BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.52),
                      borderRadius: AppRadii.control,
                    )
                  : null,
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: widget.compact ? 13 : 14,
                ),
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: colors.foreground,
                    size: widget.compact ? 17 : 19,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expand) button = SizedBox(width: double.infinity, child: button);
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: button,
    );
  }

  _AppButtonColors _resolveColors() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return const _AppButtonColors(
          background: AppColors.primaryDark,
          pressed: AppColors.primaryPressed,
          foreground: Colors.white,
          border: AppColors.primaryDark,
        );
      case AppButtonVariant.secondary:
        return const _AppButtonColors(
          background: AppColors.primarySoft,
          pressed: AppColors.surfacePressed,
          foreground: AppColors.primaryDark,
          border: AppColors.outline,
        );
      case AppButtonVariant.ghost:
        return const _AppButtonColors(
          background: Colors.transparent,
          pressed: AppColors.primarySoft,
          foreground: AppColors.primaryDark,
          border: Colors.transparent,
        );
      case AppButtonVariant.danger:
        return const _AppButtonColors(
          background: AppColors.danger,
          pressed: AppColors.dangerPressed,
          foreground: Colors.white,
          border: AppColors.danger,
        );
    }
  }
}

class _AppButtonColors {
  const _AppButtonColors({
    required this.background,
    required this.pressed,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color pressed;
  final Color foreground;
  final Color border;
}
