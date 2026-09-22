import 'package:flutter/material.dart';

/// Bọc [Container] với API ngắn gọn cho các trường hợp hay dùng (padding,
/// margin, màu nền, bo góc) - thay cho việc lặp lại `BoxDecoration` khắp nơi.
class AppBox extends StatelessWidget {
  const AppBox({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.width,
    this.height,
    this.alignment,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: (color != null || borderRadius != null)
          ? BoxDecoration(color: color, borderRadius: borderRadius)
          : null,
      child: child,
    );
  }
}

/// [Row] với `mainAxisSize: MainAxisSize.min` mặc định - lỗi hay gặp nhất khi
/// dùng `Row` trực tiếp là quên set min nên tràn ngang khi đặt trong
/// `Row`/`Wrap` khác; đặt sẵn ở đây, cần `max` thì tự truyền đè.
class AppRow extends StatelessWidget {
  const AppRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
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
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}

/// Icon ăn theo `IconTheme` hiện tại, chỉ thêm tiện lợi đặt nhanh size/color
/// mà không cần bọc thêm `IconTheme.merge`.
class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.size, this.color});

  final IconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) => Icon(icon, size: size, color: color);
}

/// Khoảng trống một chiều - thay cho việc phải nhớ chiều nào là `width`,
/// chiều nào là `height` của `SizedBox` trần.
class AppSpacer extends StatelessWidget {
  const AppSpacer.horizontal(this.value, {super.key}) : _vertical = false;

  const AppSpacer.vertical(this.value, {super.key}) : _vertical = true;

  final double value;
  final bool _vertical;

  @override
  Widget build(BuildContext context) =>
      _vertical ? SizedBox(height: value) : SizedBox(width: value);
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
