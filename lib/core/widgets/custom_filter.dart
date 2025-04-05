import 'package:flutter/material.dart';

class CustomFilter extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isActive;
  final double radius;

  const CustomFilter(
      {super.key,
      this.onTap,
      required this.text,
      this.isActive = false,
      this.radius = 8});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(radius), // Smoother corners
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Softer shadow for a clean look
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2), // Position shadow for depth
          ),
        ],
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: isActive ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
