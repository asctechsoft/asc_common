import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'app_layout.dart';
import 'app_modifier.dart';

/// Icon from an asset path (`.svg` via `flutter_svg`, anything else via
/// `Image.asset`) or an [IconData] - one widget instead of picking between
/// `SvgPicture.asset`/`Image.asset`/`Icon` by hand at every call site.
///
/// [onClick] wraps the icon in a tappable [clickZone]-sized hit area (via
/// [IconButton]) even when [size] itself is smaller than the platform's
/// minimum recommended touch target. [autoMirror] flips the icon
/// horizontally under RTL - for directional glyphs (arrows, chevrons) that
/// should visually reverse, not for logos/photos.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.iconPath, {
    super.key,
    this.size = 24,
    this.clickZone = 48,
    this.tint,
    this.onClick,
    this.autoMirror = false,
    this.clickZonePadding,
    this.modifier = Modifier,
  }) : iconData = null,
       assert(iconPath != '', 'Icon path must not be empty');

  const AppIcon.iconData(
    this.iconData, {
    super.key,
    this.size = 24,
    this.clickZone = 48,
    this.tint,
    this.onClick,
    this.autoMirror = false,
    this.clickZonePadding,
    this.modifier = Modifier,
  }) : iconPath = '';

  final String iconPath;
  final IconData? iconData;
  final double size;
  final double clickZone;
  final Color? tint;
  final VoidCallback? onClick;
  final bool autoMirror;
  final EdgeInsetsGeometry? clickZonePadding;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    Widget icon = iconData != null
        ? Icon(iconData, size: size, color: tint)
        : iconPath.endsWith('.svg')
        ? SvgPicture.asset(
            iconPath,
            width: size,
            height: size,
            colorFilter: tint != null
                ? ColorFilter.mode(tint!, BlendMode.srcIn)
                : null,
          )
        : Image.asset(
            iconPath,
            width: size,
            height: size,
            color: tint,
            colorBlendMode: tint != null ? BlendMode.srcIn : null,
          );

    if (autoMirror && Directionality.of(context) == TextDirection.rtl) {
      icon = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1, 1),
        child: icon,
      );
    }

    if (onClick != null) {
      return AppBoxCentered(
        modifier: Modifier.size(clickZone),
        children: [
          IconButton(onPressed: onClick, icon: icon, padding: clickZonePadding),
        ],
      ).apply(modifier);
    }

    return icon.apply(modifier);
  }
}
