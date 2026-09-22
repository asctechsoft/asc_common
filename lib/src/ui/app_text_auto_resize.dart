import 'package:flutter/material.dart';

import 'app_text.dart';

/// [AppText] tự thu nhỏ cỡ chữ để vừa khung chứa, dùng `FittedBox` thay vì
/// tự đo đạc/binary-search cỡ chữ như bản cũ - đơn giản, không cần thư viện
/// ngoài, và Flutter tự lo việc đo lại khi layout đổi.
class AppTextAutoResize extends StatelessWidget {
  const AppTextAutoResize(
    this.data, {
    super.key,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines = 1,
    this.alignment = Alignment.center,
  });

  final String data;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int maxLines;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: AppText(
        data,
        style: style,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}
