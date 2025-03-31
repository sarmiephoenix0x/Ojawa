import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart' show Gap;

class OrderActions extends StatelessWidget {
  final double width;

  const OrderActions({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility, color: Color(0xFFF24822)),
            onPressed: () {},
          ),
          const Gap(
            5,
            isHorizontal: true,
          ),
          IconButton(
            icon: const Icon(Icons.print, color: Color(0xFF14AE5C)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
