import 'package:flutter/material.dart';

class ImageList extends StatelessWidget {
  final String img;

  const ImageList({
    super.key,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return img.startsWith('http')
        ? Image.network(
            img,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey, // Fallback UI if the image fails to load
              );
            },
          )
        : Image.asset(
            img,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          );
  }
}
