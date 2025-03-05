import 'package:flutter/material.dart';

import 'custom_gap.dart';

class ProductCategory extends StatelessWidget {
  final String title;
  final String name;

  const ProductCategory({
    super.key,
    required this.title,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            height: 8.0,
            width: 8.0,
            decoration: const BoxDecoration(
              color: Colors.grey, // Grey color for bullet
              shape: BoxShape.circle,
            ),
          ),
          const Gap(8.0, isHorizontal: true),
          Expanded(
            flex: 4, // Adjust flex for title width distribution
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3, // Centered dash
            child: Text(
              "-",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 4, // Adjust flex for name width distribution
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
