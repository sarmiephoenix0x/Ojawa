import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';

class Coupon extends StatelessWidget {
  final String title;
  final String content;

  const Coupon({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(MediaQuery.of(context).size.width * 0.04,
                  isHorizontal: true, useMediaQuery: false),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: (50 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color(0xFF1D4ED8);
                          }
                          return Colors.white;
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white;
                          }
                          return const Color(0xFF1D4ED8);
                        },
                      ),
                      elevation: WidgetStateProperty.all<double>(4.0),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Color(0xFF1D4ED8)),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(MediaQuery.of(context).size.height * 0.03, useMediaQuery: false),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          Gap(MediaQuery.of(context).size.height * 0.03, useMediaQuery: false),
          const Text(
            "View More",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.0,
              color: Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }
}
