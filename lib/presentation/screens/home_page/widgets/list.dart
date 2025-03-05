import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/home_page_controller.dart';

class ListWidget extends StatelessWidget {
  final String text;
  final int value;

  const ListWidget({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<HomePageController>(context, listen: false)
            .setSelectedRadioValue(value);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Provider.of<HomePageController>(context, listen: false)
                      .selectedRadioValue ==
                  value
              ? const Color(0xFFFFFFFF)
              : Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(0.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
