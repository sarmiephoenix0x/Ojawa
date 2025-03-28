import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';

class ProfileOptions extends StatelessWidget {
  final String title;
  final String img;
  final void Function()? onTap;

  const ProfileOptions({
    super.key,
    required this.title,
    required this.img,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(img, height: 30),
            const Gap(
              10,
              isHorizontal: true,
            ),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
