import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/auth_text_field.dart';
import '../../controllers/new_address_controller.dart';
import 'widgets/address_type.dart';
import 'widgets/bottom_sheets/submitted_address_sheet.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  @override
  Widget build(BuildContext context) {
    final newAddressController = Provider.of<NewAddressController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthTextField(
                    label: 'Name',
                    controller: newAddressController.nameController,
                    focusNode: newAddressController.nameFocusNode,
                    labelFontSize: 16.0,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        counterText: '',
                      ),
                      initialCountryCode: 'NG',
                      // Set initial country code
                      onChanged: (phone) {
                        newAddressController
                            .setPhoneNumber(phone.completeNumber);
                      },
                      onCountryChanged: (country) {
                        print('Country changed to: ${country.name}');
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'Flat No. Street Address',
                    controller: newAddressController.streetController,
                    focusNode: newAddressController.streetFocusNode,
                    labelFontSize: 16.0,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'Landmark',
                    controller: newAddressController.landmarkController,
                    focusNode: newAddressController.landmarkFocusNode,
                    labelFontSize: 16.0,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'State',
                    controller: newAddressController.stateController,
                    focusNode: newAddressController.stateFocusNode,
                    labelFontSize: 16.0,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'City/District',
                    controller: newAddressController.cityController,
                    focusNode: newAddressController.cityFocusNode,
                    labelFontSize: 16.0,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'Postal Code',
                    controller: newAddressController.postalController,
                    focusNode: newAddressController.postalFocusNode,
                    labelFontSize: 16.0,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "Address Type",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      const AddressType(text: "Home", value: 1),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      const AddressType(text: "Office", value: 2),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: const Color(0xFF1D4ED8),
                        checkColor: Colors.white,
                        value: newAddressController.useDefault,
                        onChanged: (bool? value) {
                          newAddressController.setUseDefault(value!);
                        },
                      ),
                      Text(
                        "Use as default",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: (60 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (newAddressController.nameController.text.isNotEmpty &&
                              newAddressController.phoneNumber.isNotEmpty &&
                              newAddressController
                                  .streetController.text.isNotEmpty &&
                              newAddressController
                                  .landmarkController.text.isNotEmpty &&
                              newAddressController
                                  .stateController.text.isNotEmpty &&
                              newAddressController
                                  .cityController.text.isNotEmpty &&
                              newAddressController
                                  .postalController.text.isNotEmpty &&
                              newAddressController.selectedRadioValue != null) {
                            submittedAddress(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (newAddressController.nameController.text.isNotEmpty &&
                                  newAddressController.phoneNumber.isNotEmpty &&
                                  newAddressController
                                      .streetController.text.isNotEmpty &&
                                  newAddressController
                                      .landmarkController.text.isNotEmpty &&
                                  newAddressController
                                      .stateController.text.isNotEmpty &&
                                  newAddressController
                                      .cityController.text.isNotEmpty &&
                                  newAddressController
                                      .postalController.text.isNotEmpty &&
                                  newAddressController.selectedRadioValue !=
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
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (newAddressController.nameController.text.isNotEmpty &&
                                  newAddressController.phoneNumber.isNotEmpty &&
                                  newAddressController
                                      .streetController.text.isNotEmpty &&
                                  newAddressController
                                      .landmarkController.text.isNotEmpty &&
                                  newAddressController
                                      .stateController.text.isNotEmpty &&
                                  newAddressController
                                      .cityController.text.isNotEmpty &&
                                  newAddressController
                                      .postalController.text.isNotEmpty &&
                                  newAddressController.selectedRadioValue !=
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
                              final bool isFilled = newAddressController
                                      .nameController.text.isNotEmpty &&
                                  newAddressController.phoneNumber.isNotEmpty &&
                                  newAddressController
                                      .streetController.text.isNotEmpty &&
                                  newAddressController
                                      .landmarkController.text.isNotEmpty &&
                                  newAddressController
                                      .stateController.text.isNotEmpty &&
                                  newAddressController
                                      .cityController.text.isNotEmpty &&
                                  newAddressController
                                      .postalController.text.isNotEmpty &&
                                  newAddressController.selectedRadioValue !=
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
                        child: newAddressController.isLoading
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
