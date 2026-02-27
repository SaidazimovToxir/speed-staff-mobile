import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.iconSize,
    this.padding = const EdgeInsets.all(8.0),
    this.alignment = Alignment.center,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? iconSize;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: icon, onPressed: onPressed, color: color, iconSize: iconSize, padding: padding, alignment: alignment);
  }
}
