import 'package:flutter/material.dart';

/// Immutable data class representing a single banner in the carousel.
class BannerItem {
  final String imagePath;
  final String backgroundImage;
  final String title;
  final String buttonText;
  final void Function(BuildContext context) onTap;

  const BannerItem({
    required this.imagePath,
    required this.backgroundImage,
    required this.title,
    required this.buttonText,
    required this.onTap,
  });
}
