import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  bool isLoading = false;
  int? _selectedRadioValue;
  bool _useDefault = false;
  final FocusNode _accountNumberFocusNode = FocusNode();
  final FocusNode _confirmAccountNumberFocusNode = FocusNode();
  final FocusNode _ifscFocusNode = FocusNode();
  final FocusNode _accountHolderNameFocusNode = FocusNode();

  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController confirmAccountNumberController =
      TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: accountNumberController,
                      focusNode: _accountNumberFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Account Number',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: confirmAccountNumberController,
                      focusNode: _confirmAccountNumberFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Confirm Account Number',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: ifscController,
                      focusNode: _ifscFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'IFSC',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: accountHolderNameController,
                      focusNode: _accountHolderNameFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Account Holder Name',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                    ),
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
                        setState(() {
                          phoneNumber = phone.completeNumber;
                        });
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
                          if (accountNumberController.text.isNotEmpty &&
                              phoneNumber.isNotEmpty &&
                              confirmAccountNumberController.text.isNotEmpty &&
                              ifscController.text.isNotEmpty &&
                              accountHolderNameController.text.isNotEmpty) {
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (accountNumberController.text.isNotEmpty &&
                                  phoneNumber.isNotEmpty &&
                                  confirmAccountNumberController
                                      .text.isNotEmpty &&
                                  ifscController.text.isNotEmpty &&
                                  accountHolderNameController.text.isNotEmpty) {
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
                              if (accountNumberController.text.isNotEmpty &&
                                  phoneNumber.isNotEmpty &&
                                  confirmAccountNumberController
                                      .text.isNotEmpty &&
                                  ifscController.text.isNotEmpty &&
                                  accountHolderNameController.text.isNotEmpty) {
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
                              final bool isFilled = accountNumberController
                                      .text.isNotEmpty &&
                                  phoneNumber.isNotEmpty &&
                                  confirmAccountNumberController
                                      .text.isNotEmpty &&
                                  ifscController.text.isNotEmpty &&
                                  accountHolderNameController.text.isNotEmpty;

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
                        child: isLoading
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
