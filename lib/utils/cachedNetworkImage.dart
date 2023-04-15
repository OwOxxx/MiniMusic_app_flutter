import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedImage(String url) {
  return CachedNetworkImage(
    // 设置图片缓存
    imageUrl: url,
    placeholder: (context, url) => Container(
      padding: const EdgeInsets.all(5),
      child: const CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
