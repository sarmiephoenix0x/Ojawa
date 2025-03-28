import 'package:flutter/material.dart';

class ProductsFilter extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isActive;

  const ProductsFilter(
      {super.key, this.onTap, required this.text, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(8), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.2), // Softer shadow for a clean look
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
      ),
    );
  }
}
