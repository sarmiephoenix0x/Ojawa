import 'package:flutter/material.dart';

class HeaderCell extends StatelessWidget {
  final String title;
  final double width;

  const HeaderCell({
    super.key,
    required this.title,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
