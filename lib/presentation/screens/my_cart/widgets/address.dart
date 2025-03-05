import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/my_cart_controller.dart';

class Address extends StatelessWidget {
  final String type;
  final String name;
  final String address;
  final int value;
  final StateSetter setState;

  const Address({
    super.key,
    required this.type,
    required this.name,
    required this.address,
    required this.value,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: InkWell(
        onTap: () {
          Provider.of<MyCartController>(context, listen: false)
              .setSelectedRadioValue(value); // Update selected value
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              width: 0.8,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55.0),
                      border: Border.all(
                        width: Provider.of<MyCartController>(context,
                                        listen: false)
                                    .selectedRadioValue ==
                                value
                            ? 3
                            : 0.8,
                        color: Provider.of<MyCartController>(context,
                                        listen: false)
                                    .selectedRadioValue ==
                                value
                            ? const Color(0xFF1D4ED8)
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              Text(
                address,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
