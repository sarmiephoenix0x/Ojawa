import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../../core/widgets/auth_label.dart';
import '../../../../core/widgets/custom_gap.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../controllers/add_pickup_location_controllers.dart';

class AddPickupLocation extends StatefulWidget {
  const AddPickupLocation({super.key});

  @override
  _AddPickupLocationState createState() => _AddPickupLocationState();
}

class _AddPickupLocationState extends State<AddPickupLocation> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final addPickupLocationController =
        Provider.of<AddPickupLocationControllers>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('Add Pick-Up Location',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Pick-Up Location'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addPickupLocationController
                              .pickupLocationController,
                          focusNode: addPickupLocationController
                              .pickupLocationFocusNode,
                          label: 'Add Pick-Up Location',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Name'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.nameController,
                          focusNode: addPickupLocationController.nameFocusNode,
                          label: 'Shipper’s Name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Email'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.emailController,
                          focusNode: addPickupLocationController.emailFocusNode,
                          label: 'Shipper’s Email Address',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Phone Number'),
                        ),
                        const Gap(5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode ? Colors.grey[900] : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(5), // Smoother corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(
                                      0, 2), // Position shadow for depth
                                ),
                              ],
                            ),
                            child: IntlPhoneField(
                              controller: addPickupLocationController
                                  .phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                counterText: '',
                              ),
                              initialCountryCode: 'NG',
                              // Set initial country code
                              onChanged: (phone) {
                                addPickupLocationController.setPhoneNumber(phone
                                    .completeNumber); // Store the phone number
                              },
                              onCountryChanged: (country) {
                                print('Country changed to: ${country.name}');
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'City'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.cityController,
                          focusNode: addPickupLocationController.cityFocusNode,
                          label: 'Pick-Up Location City Name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'State'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.stateController,
                          focusNode: addPickupLocationController.stateFocusNode,
                          label: 'Pick-Up Location State Name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Country'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.countryController,
                          focusNode:
                              addPickupLocationController.countryFocusNode,
                          label: 'Pick-Up Location Country Name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Pin-code'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.pinCodeController,
                          focusNode:
                              addPickupLocationController.pinCodeFocusNode,
                          label: 'Pick-up Location Pin-code',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Address'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.pinCodeController,
                          focusNode:
                              addPickupLocationController.addressFocusNode,
                          label: 'shippers Primary Address Max. 80 Characters',
                          maxLines: 4,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Additional Address'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addPickupLocationController
                              .additionalAddressController,
                          focusNode: addPickupLocationController
                              .additionalAddressFocusNode,
                          label: 'Additional Address Details',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Latitude'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.latitudeController,
                          focusNode:
                              addPickupLocationController.latitudeFocusNode,
                          label: 'Pick-up Location Latitude',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Longitude'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addPickupLocationController.longitudeController,
                          focusNode:
                              addPickupLocationController.longitudeFocusNode,
                          label: 'Pick-up Location Longitude',
                        ),
                        const Gap(50),
                        CustomButton(
                          width: double.infinity,
                          isLoading: addPickupLocationController.isLoading,
                          text: 'Add Pick-Up Location',
                          bgColor: Colors.black,
                          borderColor: Colors.black,
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
