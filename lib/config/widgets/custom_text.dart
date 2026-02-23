import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.fontFamily,
    this.style,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      tr(text),
      style:
          style ??
          TextStyle(
            overflow: overflow,
            decoration: decoration ?? TextDecoration.none,
            decorationColor: CupertinoColors.black,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: letterSpacing,
          ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
