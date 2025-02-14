import 'package:flutter/material.dart';

class ImagePanel extends StatelessWidget {
  const ImagePanel({
    super.key,
    required this.image,
    required this.onTap,
  });

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(image, height: 200),
      )
    );
  }
}