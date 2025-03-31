import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';

class OrderSetup extends StatelessWidget {
  final String text;
  final String? text2;
  final double width;
  final String? img;

  const OrderSetup({
    super.key,
    required this.text,
    required this.width,
    this.text2,
    this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (img != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                img!,
                fit: BoxFit.cover,
              ),
            ),
          const Gap(5, isHorizontal: true),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                softWrap: true,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (text2 != null)
                Text(
                  text2!,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
