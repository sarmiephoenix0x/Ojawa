import 'package:flutter/material.dart';

import 'custom_gap.dart';

class FilterWidget extends StatelessWidget {
  final String img;
  final String text;

  const FilterWidget({
    super.key,
    required this.img,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          img,
          height: 22,
        ),
        Gap(MediaQuery.of(context).size.height * 0.02, useMediaQuery: false),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
