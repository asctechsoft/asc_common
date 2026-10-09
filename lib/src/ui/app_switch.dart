import 'package:flutter/material.dart';

/// Toggle switch: ON = [activeColors] gradient, OFF = [inactiveColor] track,
/// with a white knob that floats with a drop shadow. Colors default to the
/// theme's `colorScheme` so an app only passes them when it has its own
/// palette.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColors,
    this.inactiveColor,
    this.width = 42,
    this.height = 24,
    this.padding = 3,
    this.semanticLabel = 'Toggle switch',
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// Gradient stops for the ON track (one color = solid). Defaults to the
  /// theme's primary color.
  final List<Color>? activeColors;

  /// OFF track color. Defaults to the theme's `outlineVariant`.
  final Color? inactiveColor;

  final double width;
  final double height;
  final double padding;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final on = activeColors == null || activeColors!.isEmpty
        ? [scheme.primary, scheme.primary]
        : activeColors!.length == 1
        ? [activeColors!.first, activeColors!.first]
        : activeColors!;
    final off = inactiveColor ?? scheme.outlineVariant;
    final knob = height - (padding * 2);

    return Semantics(
      toggled: value,
      label: semanticLabel,
      onTap: () => onChanged(!value),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          width: width,
          height: height,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            // Always a gradient (OFF = solid-colour gradient) so
            // AnimatedContainer tweens gradient→gradient smoothly instead of
            // flickering on a gradient↔color decoration swap.
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: value ? on : [off, off],
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: knob,
              height: knob,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
