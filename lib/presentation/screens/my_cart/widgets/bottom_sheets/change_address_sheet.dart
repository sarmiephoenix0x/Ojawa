import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/my_cart_controller.dart';
import '../../../new_address/new_address.dart';
import '../address.dart';

void changeAddress(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                      height: (28 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  Address(
                    type: "Home",
                    name: "[Receiver’s Name]",
                    address:
                        "2917 Anywhere You Choose, Rd. St. Frestine, State, Country",
                    value: 1,
                    setState: setState, // Pass the setState function
                  ),
                  Address(
                    type: "Work",
                    name: "[Receiver’s Name]",
                    address: "1234 Some Other Place, Rd. City, State, Country",
                    value: 2,
                    setState: setState, // Pass the setState function
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewAddress(key: UniqueKey()),
                            ),
                          );
                        },
                        child: const Text(
                          '+ Add New Address',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: (28 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  Container(
                    width: double.infinity,
                    height: (60 / MediaQuery.of(context).size.height) *
                        MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (Provider.of<MyCartController>(context,
                                    listen: false)
                                .selectedRadioValue !=
                            null) {
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (Provider.of<MyCartController>(context,
                                        listen: false)
                                    .selectedRadioValue !=
                                null) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.white;
                              }
                              return const Color(0xFF1D4ED8);
                            } else {
                              return Colors.grey;
                            }
                          },
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (Provider.of<MyCartController>(context,
                                        listen: false)
                                    .selectedRadioValue !=
                                null) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color(0xFF1D4ED8);
                              }
                              return Colors.white;
                            } else {
                              return Colors.white;
                            }
                          },
                        ),
                        elevation: WidgetStateProperty.all<double>(4.0),
                        shape: WidgetStateProperty.resolveWith<
                            RoundedRectangleBorder>(
                          (Set<WidgetState> states) {
                            final bool isFilled = Provider.of<MyCartController>(
                                        context,
                                        listen: false)
                                    .selectedRadioValue !=
                                null;

                            return RoundedRectangleBorder(
                              side: BorderSide(
                                width: 3,
                                color: isFilled
                                    ? const Color(0xFF1D4ED8)
                                    : Colors.grey,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            );
                          },
                        ),
                      ),
                      child:
                          Provider.of<MyCartController>(context, listen: false)
                                  .isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
