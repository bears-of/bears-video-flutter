import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppVectorIconData {
  const AppVectorIconData(this.assetName);

  final String assetName;
}

class AppVectorIcons {
  const AppVectorIcons._();

  static const audioLines = AppVectorIconData('audio-lines');
  static const badgeCheck = AppVectorIconData('badge-check');
  static const check = AppVectorIconData('check');
  static const chevronDown = AppVectorIconData('chevron-down');
  static const chevronLeft = AppVectorIconData('chevron-left');
  static const chevronRight = AppVectorIconData('chevron-right');
  static const circleAlert = AppVectorIconData('circle-alert');
  static const circleCheck = AppVectorIconData('circle-check');
  static const circlePlay = AppVectorIconData('circle-play');
  static const circleX = AppVectorIconData('circle-x');
  static const cloudOff = AppVectorIconData('cloud-off');
  static const film = AppVectorIconData('film');
  static const house = AppVectorIconData('house');
  static const imageOff = AppVectorIconData('image-off');
  static const info = AppVectorIconData('info');
  static const library = AppVectorIconData('library');
  static const play = AppVectorIconData('play');
  static const power = AppVectorIconData('power');
  static const search = AppVectorIconData('search');
  static const searchX = AppVectorIconData('search-x');
  static const star = AppVectorIconData('star');
  static const sun = AppVectorIconData('sun');
  static const trash = AppVectorIconData('trash-2');
  static const user = AppVectorIconData('user');
  static const volume = AppVectorIconData('volume-2');
  static const volumeOff = AppVectorIconData('volume-x');
  static const wifiOff = AppVectorIconData('wifi-off');
  static const x = AppVectorIconData('x');
  static const zap = AppVectorIconData('zap');
}

class AppVectorIcon extends StatelessWidget {
  const AppVectorIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.shadows,
  });

  final AppVectorIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final effectiveSize = size ?? iconTheme.size ?? 24;
    final effectiveColor = color ?? iconTheme.color;

    Widget picture(Color? pictureColor, {String? label}) {
      return SvgPicture.asset(
        'assets/icons/lucide/${icon.assetName}.svg',
        width: effectiveSize,
        height: effectiveSize,
        fit: BoxFit.contain,
        colorFilter: pictureColor == null
            ? null
            : ColorFilter.mode(pictureColor, BlendMode.srcIn),
        semanticsLabel: label,
        excludeFromSemantics: label == null,
      );
    }

    Widget constrainIcon(Widget child) {
      return Align(
        widthFactor: 1,
        heightFactor: 1,
        child: SizedBox.square(dimension: effectiveSize, child: child),
      );
    }

    final iconShadows = shadows;
    if (iconShadows == null || iconShadows.isEmpty) {
      return constrainIcon(picture(effectiveColor, label: semanticLabel));
    }
    return constrainIcon(
      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          for (final shadow in iconShadows)
            Positioned.fill(
              child: Transform.translate(
                offset: shadow.offset,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: shadow.blurRadius / 2,
                    sigmaY: shadow.blurRadius / 2,
                  ),
                  child: picture(shadow.color),
                ),
              ),
            ),
          picture(effectiveColor, label: semanticLabel),
        ],
      ),
    );
  }
}
