import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';

class UserDetails extends StatelessWidget {
  final String title;
  final String img;
  final double value;

  const UserDetails({
    super.key,
    required this.title,
    required this.img,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const Gap(
          5,
          isHorizontal: true,
        ),
        Image.asset(img, height: 15)
      ]),
      const Gap(10),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          value.toString(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      )
    ]);
  }
}
