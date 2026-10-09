import 'package:flutter/material.dart';

/// A strip as tall as the bottom system inset (gesture bar / home indicator),
/// painted [color]. Put it under content that must clear the inset.
class BottomSafeArea extends StatelessWidget {
  const BottomSafeArea({super.key, this.color = Colors.transparent});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    return Container(width: double.infinity, height: bottomPadding, color: color);
  }
}
