import 'package:bears_video/core/theme/app_colors.dart';
import 'package:bears_video/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// A compact cyan field with a stable rounded silhouette and custom focus ring.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.enableInteractiveSelection = true,
    this.maxLength,
    this.textInputAction,
    this.onTap,
    this.onSubmitted,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final bool enableInteractiveSelection;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _attachFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (_ownsFocusNode) _focusNode.dispose();
      _attachFocusNode(widget.focusNode);
    }
  }

  void _attachFocusNode(FocusNode? focusNode) {
    _ownsFocusNode = focusNode == null;
    _focusNode = focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.field,
        border: Border.all(
          color: focused ? AppColors.focus : AppColors.outline,
          width: focused ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        maxLength: widget.maxLength,
        buildCounter: widget.maxLength == null
            ? null
            : (_, {required currentLength, required isFocused, maxLength}) =>
                  null,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        style:
            widget.style ?? const TextStyle(fontSize: 13, color: AppColors.ink),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          prefixIconConstraints: const BoxConstraints(
            minHeight: 34,
            minWidth: 36,
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 34,
            minWidth: 36,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
        ),
      ),
    );
  }
}
