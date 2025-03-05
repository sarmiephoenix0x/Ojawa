import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/auth_text_field.dart';
import '../../controllers/new_account_controller.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  @override
  Widget build(BuildContext context) {
    final newAccountController = Provider.of<NewAccountController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Account',
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
                    label: 'Account Number',
                    controller: newAccountController.accountNumberController,
                    focusNode: newAccountController.accountNumberFocusNode,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'Confirm Account Number',
                    controller:
                        newAccountController.confirmAccountNumberController,
                    focusNode:
                        newAccountController.confirmAccountNumberFocusNode,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'IFSC',
                    controller: newAccountController.ifscController,
                    focusNode: newAccountController.ifscFocusNode,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AuthTextField(
                    label: 'Account Holder Name',
                    controller:
                        newAccountController.accountHolderNameController,
                    focusNode: newAccountController.accountHolderNameFocusNode,
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
                        newAccountController
                            .setPhoneNumber(phone.completeNumber);
                      },
                      onCountryChanged: (country) {},
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: (60 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (newAccountController
                                  .accountNumberController.text.isNotEmpty &&
                              newAccountController.phoneNumber.isNotEmpty &&
                              newAccountController
                                  .confirmAccountNumberController
                                  .text
                                  .isNotEmpty &&
                              newAccountController
                                  .ifscController.text.isNotEmpty &&
                              newAccountController.accountHolderNameController
                                  .text.isNotEmpty) {
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (newAccountController.accountNumberController
                                      .text.isNotEmpty &&
                                  newAccountController.phoneNumber.isNotEmpty &&
                                  newAccountController
                                      .confirmAccountNumberController
                                      .text
                                      .isNotEmpty &&
                                  newAccountController
                                      .ifscController.text.isNotEmpty &&
                                  newAccountController
                                      .accountHolderNameController
                                      .text
                                      .isNotEmpty) {
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
                              if (newAccountController.accountNumberController
                                      .text.isNotEmpty &&
                                  newAccountController.phoneNumber.isNotEmpty &&
                                  newAccountController
                                      .confirmAccountNumberController
                                      .text
                                      .isNotEmpty &&
                                  newAccountController
                                      .ifscController.text.isNotEmpty &&
                                  newAccountController
                                      .accountHolderNameController
                                      .text
                                      .isNotEmpty) {
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
                              final bool isFilled = newAccountController
                                      .accountNumberController
                                      .text
                                      .isNotEmpty &&
                                  newAccountController.phoneNumber.isNotEmpty &&
                                  newAccountController
                                      .confirmAccountNumberController
                                      .text
                                      .isNotEmpty &&
                                  newAccountController
                                      .ifscController.text.isNotEmpty &&
                                  newAccountController
                                      .accountHolderNameController
                                      .text
                                      .isNotEmpty;

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
                        child: newAccountController.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Add New Account',
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
