import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final FontWeight weight;
  final TextAlign align;
  final int? maxLines;
  final bool isNormal;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.weight = FontWeight.normal,
    this.align = TextAlign.start,
    this.size = 15,
    this.isNormal = true,
    this.maxLines,
    this.decoration,
  });

  // condition?re_if_true:res_if_false
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      style: isNormal
          ? TextStyle(
              color: color,
              fontSize: size,
              fontWeight: weight,
              decoration: decoration)
          : GoogleFonts.poppins(
              color: color,
              fontSize: size,
              decoration: decoration,
              fontWeight: weight,
            ),
    );
  }
}
