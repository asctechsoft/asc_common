import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Compose-style "chain of widget wrappers, apply once" modifier - lets
/// `AppRow`/`AppColumn`/`AppBox`/`AppIcon`/`AppSpacer` (and any widget, via
/// [ModifierApply.apply]) take a single declarative `modifier:` argument
/// instead of manually nesting `Padding`/`DecoratedBox`/`GestureDetector`/...
/// around them.
///
/// This is the one legacy-flavoured piece in this otherwise GetX-free,
/// screenutil-free package - kept because it's the actual, working
/// convention this package's consumer apps already build UI around, not
/// because it's this package's preferred style for new code.
typedef AppModifierWrap = Widget Function(Widget child);

@immutable
class AppModifier {
  const AppModifier() : _ops = const [];
  const AppModifier._(this._ops);
  final List<AppModifierWrap> _ops;

  AppModifier then(AppModifierWrap op) => AppModifier._([..._ops, op]);
  AppModifier operator +(AppModifier other) =>
      AppModifier._([..._ops, ...other._ops]);

  Widget apply(Widget child) =>
      _ops.reversed.fold<Widget>(child, (w, op) => op(w));

  /// `true` when this modifier has no operations - lets a widget skip
  /// wrapping its child in a no-op builder when nothing was chained.
  bool get isEmpty => _ops.isEmpty;
}

// ignore: constant_identifier_names
const AppModifier Modifier = AppModifier();

extension ModifierApply on Widget {
  Widget apply(AppModifier modifier) => modifier.apply(this);
}

extension AppModifierOps on AppModifier {
  /// Applies a random background color with low opacity - handy to spot a
  /// widget's real bounds while iterating on layout, never wired to any
  /// flag automatically; call it explicitly and remove it again.
  AppModifier backgroundColorDebug() {
    final random = Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      0.3,
    );
    return background(color: color);
  }

  AppModifier borderColorDebug() {
    final random = Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      0.3,
    );
    return border(color: color);
  }

  /// Conditionally applies one of two modifiers based on a boolean condition
  AppModifier conditional(
    bool condition, {
    required AppModifier Function(AppModifier) onTrue,
    AppModifier Function(AppModifier)? onFalse,
  }) {
    if (condition) {
      return this + onTrue(Modifier);
    } else if (onFalse != null) {
      return this + onFalse(Modifier);
    } else {
      return this;
    }
  }

  AppModifier paddingAll(double all) => padding(all: all);

  AppModifier paddingVertical(double vertical) => padding(vertical: vertical);

  AppModifier paddingHorizontal(double horizontal) =>
      padding(horizontal: horizontal);

  AppModifier paddingLR({double left = 0, double right = 0}) {
    final insets = EdgeInsets.fromLTRB(left, 0, right, 0);
    return then((c) => Padding(padding: insets, child: c));
  }

  AppModifier padding({
    double? all,
    double? horizontal,
    double? vertical,
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    final insets = all != null
        ? EdgeInsetsDirectional.all(all)
        : (horizontal != null || vertical != null)
        ? EdgeInsetsDirectional.symmetric(
            horizontal: horizontal ?? 0,
            vertical: vertical ?? 0,
          )
        : EdgeInsetsDirectional.only(
            start: start,
            top: top,
            end: end,
            bottom: bottom,
          );
    return then((c) => Padding(padding: insets, child: c));
  }

  AppModifier paddingEdgeInsets(EdgeInsets insets) =>
      then((c) => Padding(padding: insets, child: c));

  /// Ink ripple / material "clickable" with visual feedback, without
  /// requiring a `Material` ancestor.
  AppModifier appClickable({
    VoidCallback? onTap,
    double radius = 8,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
    bool enableFeedback = true,
  }) {
    return then(
      (c) => Stack(
        children: [
          c,
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                splashColor: splashColor,
                highlightColor: highlightColor,
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
                enableFeedback: enableFeedback,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // background(Color, shape)
  AppModifier background({
    required Color color,
    double radius = 0,
    BorderRadiusGeometry? borderRadius,
  }) {
    return then(
      (c) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
        ),
        child: c,
      ),
    );
  }

  // border(width, color, shape)
  AppModifier border({
    required Color color,
    double width = 1,
    double radius = 0,
    BorderRadiusGeometry? borderRadius,
  }) {
    return then(
      (c) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: width, color: color),
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
        ),
        child: c,
      ),
    );
  }

  AppModifier boxDecoration({
    Color? color,
    BorderRadius? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) {
    return then(
      (c) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow,
          gradient: gradient,
        ),
        child: c,
      ),
    );
  }

  AppModifier clip(BorderRadius radius) =>
      then((c) => ClipRRect(borderRadius: radius, child: c));

  AppModifier clipCorner(double radius) =>
      then((c) => ClipRRect(borderRadius: BorderRadius.circular(radius), child: c));

  AppModifier size(double size) =>
      then((c) => SizedBox(width: size, height: size, child: c));

  AppModifier width(double width) =>
      then((c) => SizedBox(width: width, child: c));

  AppModifier height(double height) =>
      then((c) => SizedBox(height: height, child: c));

  AppModifier minWidth(double width) => then(
    (c) => ConstrainedBox(constraints: BoxConstraints(minWidth: width), child: c),
  );
  AppModifier minHeight(double height) => then(
    (c) => ConstrainedBox(constraints: BoxConstraints(minHeight: height), child: c),
  );
  AppModifier minSize(double size) => then(
    (c) => ConstrainedBox(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      child: c,
    ),
  );
  AppModifier maxSize(double size) => then(
    (c) => ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size, maxHeight: size),
      child: c,
    ),
  );
  AppModifier maxWidth(double width) => then(
    (c) => ConstrainedBox(constraints: BoxConstraints(maxWidth: width), child: c),
  );
  AppModifier maxHeight(double height) => then(
    (c) => ConstrainedBox(constraints: BoxConstraints(maxHeight: height), child: c),
  );

  AppModifier fillMaxWidth([double fraction = 1.0]) =>
      then((c) => FractionallySizedBox(widthFactor: fraction, child: c));

  AppModifier fillMaxHeight([double fraction = 1.0]) =>
      then((c) => FractionallySizedBox(heightFactor: fraction, child: c));

  AppModifier fillMaxSize() => then((c) => SizedBox.expand(child: c));

  AppModifier weight([int flex = 1]) => then((c) => Expanded(flex: flex, child: c));

  AppModifier expanded({int flex = 1}) => then((c) => Expanded(flex: flex, child: c));

  AppModifier wrapContentSize([Alignment alignment = Alignment.center]) => then(
    (c) => Align(
      alignment: alignment,
      child: IntrinsicWidth(child: IntrinsicHeight(child: c)),
    ),
  );

  AppModifier intrinsicWidth() => then((c) => IntrinsicWidth(child: c));

  AppModifier intrinsicHeight() => then((c) => IntrinsicHeight(child: c));

  AppModifier centered() => then((c) => Center(child: c));

  AppModifier offset({double x = 0, double y = 0}) =>
      then((c) => Transform.translate(offset: Offset(x, y), child: c));

  AppModifier alpha(double value) => then((c) => Opacity(opacity: value, child: c));

  AppModifier clickable(
    VoidCallback? onTap, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) => then((c) => GestureDetector(behavior: behavior, onTap: onTap, child: c));

  AppModifier scrollable({
    ScrollPhysics? physics,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    Clip clipBehavior = Clip.hardEdge,
    HitTestBehavior hitTestBehavior = HitTestBehavior.opaque,
    String? restorationId,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) => then(
    (c) => SingleChildScrollView(
      physics: physics,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      hitTestBehavior: hitTestBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: c,
    ),
  );

  AppModifier container({
    AlignmentGeometry? alignment,
    EdgeInsets? padding,
    Color? color,
    BoxDecoration? decoration,
    BoxDecoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsets? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return then(
      (c) => Container(
        alignment: alignment,
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: c,
      ),
    );
  }

  AppModifier graphicsLayer({
    double? alpha,
    double scaleX = 1,
    double scaleY = 1,
    double rotationZ = 0,
    Offset? transformOrigin,
  }) {
    return then((c) {
      final origin = transformOrigin ?? Offset.zero;
      return Transform(
        alignment: Alignment.topLeft,
        transform: Matrix4.identity()
          ..translate(origin.dx, origin.dy)
          ..rotateZ(rotationZ)
          ..scale(scaleX, scaleY)
          ..translate(-origin.dx, -origin.dy),
        child: alpha != null ? Opacity(opacity: alpha, child: c) : c,
      );
    });
  }
}
