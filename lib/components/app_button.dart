import 'package:flutter/material.dart';

import '../utils/app_const.dart';
import '../utils/app_func.dart';
import 'app_text.dart';

class AppButtonRound extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final Color backgroundColor;
  final double radius;
  final double? width;
  final Function() onTap;
  final bool isLoading;
  final Widget? prefix;

  const AppButtonRound(
      {super.key,
      required this.text,
      this.textSize = 18,
      this.textColor = Colors.white,
      this.backgroundColor = Colors.black,
      this.radius = 25,
      this.width,
      this.prefix,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? getSize(context).width,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(radius)),
        child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(prefix!=null)
                      prefix!,
                    if(prefix!=null)
                      const SizedBox(width: 20,),
                    AppText(
                        text,
                        size: textSize,
                        weight: FontWeight.w400,
                        color: textColor,
                        align: TextAlign.center,
                      ),
                  ],
                )),
      ),
    );
  }
}
