import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String img;
  final String text;

  const Category({
    super.key,
    required this.img,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          img,
          height: 55,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
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
