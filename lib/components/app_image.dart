import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppImage(
      {super.key,
      required this.url,
      this.fit = BoxFit.contain,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return url.startsWith("http")
        ? CachedNetworkImage(
            imageUrl: url,
            fit: fit,
            width: width,
            height: height,
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : url.startsWith("assets")
            ? Image.asset(
                url,
                fit: fit,
                width: width,
                height: height,
              )
            : Image.file(
                File(url),
                fit: fit,
                width: width,
                height: height,
              );
  }
}
