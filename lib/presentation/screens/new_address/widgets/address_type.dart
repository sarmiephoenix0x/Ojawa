import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/new_address_controller.dart';

class AddressType extends StatelessWidget {
  final String text;
  final int value;

  const AddressType({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Provider.of<NewAddressController>(context, listen: false)
                  .setSelectedRadioValue(value); // Update selected value
            },
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width:
                      Provider.of<NewAddressController>(context, listen: false)
                                  .selectedRadioValue ==
                              value
                          ? 3
                          : 0.8,
                  color:
                      Provider.of<NewAddressController>(context, listen: false)
                                  .selectedRadioValue ==
                              value
                          ? const Color(0xFF1D4ED8)
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
