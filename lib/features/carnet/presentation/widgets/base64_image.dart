// lib/widgets/base64_image.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class Base64Image extends StatelessWidget {
  final String base64String;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const Base64Image({
    required this.base64String,
    this.fit,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // Gérer les préfixes data:image/png;base64, si présents
      final cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      final bytes = base64Decode(cleanBase64);

      return Image.memory(
        bytes,
        fit: fit,
        width: double.infinity,
        errorBuilder: (_, __, ___) => errorWidget ??
            const Center(child: Icon(Icons.broken_image_outlined)),
      );
    } catch (e) {
      return errorWidget ??
          const Center(child: Icon(Icons.error_outline, color: Colors.red));
    }
  }
}