import 'package:flutter/material.dart';

import 'app_modifier.dart';

/// Builds its child lazily so a `modifier:` chain wraps this element, not
/// the `Row`/`Column` itself - keeps `Expanded`/`Flexible` children working
/// (they need a direct `Flex` parent; wrapping the `Row`/`Column` itself in
/// e.g. a `Padding` would break that).
class _FlexModifierWrapper extends StatelessWidget {
  const _FlexModifierWrapper({required this.builder});

  final Widget Function() builder;

  @override
  Widget build(BuildContext context) => builder();
}

/// [Row] với `mainAxisSize: MainAxisSize.min` mặc định - lỗi hay gặp nhất khi
/// dùng `Row` trực tiếp là quên set min nên tràn ngang khi đặt trong
/// `Row`/`Wrap` khác; đặt sẵn ở đây, cần `max` thì tự truyền đè. Nhận thêm
/// `modifier:` (xem [AppModifier]) để bọc `Padding`/`DecoratedBox`/... quanh
/// chính `Row` mà không phá vòng cha `Flex` mà `Expanded`/`Flexible` con cần.
class AppRow extends StatelessWidget {
  const AppRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    this.modifier = Modifier,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double spacing;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: children,
    );
    if (modifier.isEmpty) return row;
    return modifier.apply(_FlexModifierWrapper(builder: () => row));
  }
}

/// [AppRow] with `mainAxisAlignment`/`crossAxisAlignment` pinned to center.
class AppRowCentered extends StatelessWidget {
  const AppRowCentered({
    super.key,
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    this.modifier = Modifier,
  });

  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double spacing;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: children,
    );
    if (modifier.isEmpty) return row;
    return modifier.apply(_FlexModifierWrapper(builder: () => row));
  }
}

/// Tương tự [AppRow] nhưng theo chiều dọc.
class AppColumn extends StatelessWidget {
  const AppColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    this.modifier = Modifier,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double spacing;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: children,
    );
    if (modifier.isEmpty) return column;
    return modifier.apply(_FlexModifierWrapper(builder: () => column));
  }
}

/// [AppColumn] with `mainAxisAlignment`/`crossAxisAlignment` pinned to center.
class AppColumnCentered extends StatelessWidget {
  const AppColumnCentered({
    super.key,
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    this.modifier = Modifier,
  });

  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double spacing;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: children,
    );
    if (modifier.isEmpty) return column;
    return modifier.apply(_FlexModifierWrapper(builder: () => column));
  }
}

/// [Stack] of freely overlapping [children], sized/decorated through a
/// `modifier:` chain (see [AppModifier]) instead of separate
/// padding/color/borderRadius fields - compose
/// `Modifier.padding(...).background(...)` instead.
class AppBox extends StatelessWidget {
  const AppBox({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.children = const <Widget>[],
    this.modifier = Modifier,
  });

  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit fit;
  final Clip clipBehavior;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    final stack = Stack(
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );
    return stack.apply(modifier);
  }
}

/// [AppBox] with `alignment` pinned to [Alignment.center].
class AppBoxCentered extends StatelessWidget {
  const AppBoxCentered({
    super.key,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.children = const <Widget>[],
    this.modifier = Modifier,
  });

  final List<Widget> children;
  final TextDirection? textDirection;
  final StackFit fit;
  final Clip clipBehavior;
  final AppModifier modifier;

  @override
  Widget build(BuildContext context) {
    final stack = Stack(
      alignment: Alignment.center,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );
    return stack.apply(modifier);
  }
}

/// [Divider] mỏng, màu ăn theo `DividerTheme`/`ColorScheme` hiện tại thay vì
/// hardcode xám như bản cũ.
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.thickness = 1,
    this.indent,
    this.endIndent,
  });

  final double thickness;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) => Divider(
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    height: thickness,
  );
}
