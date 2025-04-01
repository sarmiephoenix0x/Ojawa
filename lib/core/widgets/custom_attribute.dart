import 'package:flutter/material.dart';

class CustomAttribute extends StatelessWidget {
  final String text;
  final String text2;
  final FontWeight? fontWeightTxt;
  final FontWeight? fontWeightTxt2;
  final bool isPaddingActive;

  const CustomAttribute({
    super.key,
    required this.text,
    required this.text2,
    this.fontWeightTxt,
    this.fontWeightTxt2,
    this.isPaddingActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isPaddingActive ? 15.0 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$text: ',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.0,
              fontWeight: fontWeightTxt,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            text2,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.0,
              fontWeight: fontWeightTxt2,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
