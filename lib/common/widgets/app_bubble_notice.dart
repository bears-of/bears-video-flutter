import 'package:bears_video/common/widgets/app_vector_icon.dart';
import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

enum AppBubbleNoticeType { info, success, error }

const _defaultNoticeDuration = Duration(milliseconds: 3200);
const _defaultErrorNoticeDuration = Duration(milliseconds: 4800);
const _snackBarTransitionDuration = Duration(milliseconds: 250);

void showAppBubbleNotice(
  BuildContext context,
  String message, {
  AppBubbleNoticeType type = AppBubbleNoticeType.info,
  Duration? duration,
}) {
  final effectiveDuration =
      duration ??
      (type == AppBubbleNoticeType.error
          ? _defaultErrorNoticeDuration
          : _defaultNoticeDuration);
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  final transitionDuration = reduceMotion
      ? const Duration(milliseconds: 25)
      : _snackBarTransitionDuration * 2;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: _AppBubbleNotice(
            message: message,
            type: type,
            progressDuration: effectiveDuration + transitionDuration,
          ),
        ),
      ),
      duration: effectiveDuration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: EdgeInsets.zero,
      dismissDirection: DismissDirection.horizontal,
      clipBehavior: Clip.none,
    ),
  );
}

class _AppBubbleNotice extends StatefulWidget {
  const _AppBubbleNotice({
    required this.message,
    required this.type,
    required this.progressDuration,
  });

  final String message;
  final AppBubbleNoticeType type;
  final Duration progressDuration;

  @override
  State<_AppBubbleNotice> createState() => _AppBubbleNoticeState();
}

class _AppBubbleNoticeState extends State<_AppBubbleNotice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.progressDuration,
      animationBehavior: AnimationBehavior.preserve,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = switch (widget.type) {
      AppBubbleNoticeType.info => AppColors.primaryDark,
      AppBubbleNoticeType.success => AppColors.primary,
      AppBubbleNoticeType.error => AppColors.danger,
    };
    final icon = switch (widget.type) {
      AppBubbleNoticeType.info => AppVectorIcons.info,
      AppBubbleNoticeType.success => AppVectorIcons.circleCheck,
      AppBubbleNoticeType.error => AppVectorIcons.circleAlert,
    };
    final semanticPrefix = switch (widget.type) {
      AppBubbleNoticeType.info => '提示',
      AppBubbleNoticeType.success => '成功',
      AppBubbleNoticeType.error => '错误',
    };

    return Semantics(
      container: true,
      liveRegion: true,
      excludeSemantics: true,
      label: '$semanticPrefix：${widget.message}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadii.bubble,
          boxShadow: const [
            BoxShadow(
              color: Color(0x24103331),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.bubble,
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 16, 11),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppVectorIcon(icon, color: accent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ExcludeSemantics(
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: 1 - _progressController.value,
                      minHeight: 3,
                      backgroundColor: AppColors.surfaceMuted,
                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
