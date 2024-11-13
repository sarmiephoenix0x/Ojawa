import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> with WidgetsBindingObserver {
  bool isLoading = false;
  final FocusNode _cardHolderNameFocusNode = FocusNode();
  final FocusNode _cardNumberFocusNode = FocusNode();
  final FocusNode _expiryDateFocusNode = FocusNode();
  final FocusNode _ccvFocusNode = FocusNode();

  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController ccvController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add New Card"),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Card Holder Name',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: cardHolderNameController,
                      focusNode: _cardHolderNameFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Sarmie Pheonix',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Inter',
                          fontSize: 12.0,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Card Number',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: cardNumberController,
                      focusNode: _cardNumberFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        labelText: '000 000 000 00',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                        ),
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _CardNumberFormatter(),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                TextFormField(
                                  controller: expiryDateController,
                                  focusNode: _expiryDateFocusNode,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    decoration: TextDecoration.none,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'MM/YY',
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
                                    ),
                                    // floatingLabelBehavior:
                                    //     FloatingLabelBehavior.never,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                  cursorColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    _ExpiryDateFormatter(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CCV',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                TextFormField(
                                  controller: ccvController,
                                  focusNode: _ccvFocusNode,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    decoration: TextDecoration.none,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: '000',
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
                                    ),
                                    // floatingLabelBehavior:
                                    //     FloatingLabelBehavior.never,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                  cursorColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Container(
                    width: double.infinity,
                    height: (60 / MediaQuery.of(context).size.height) *
                        MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (cardHolderNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                cardNumberController.text.trim().isNotEmpty &&
                                expiryDateController.text.trim().isNotEmpty &&
                                ccvController.text.trim().isNotEmpty) {
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
                            if (cardHolderNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                cardNumberController.text.trim().isNotEmpty &&
                                expiryDateController.text.trim().isNotEmpty &&
                                ccvController.text.trim().isNotEmpty) {
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
                            final bool isFilled = cardHolderNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                cardNumberController.text.trim().isNotEmpty &&
                                expiryDateController.text.trim().isNotEmpty &&
                                ccvController.text.trim().isNotEmpty;

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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Add Card'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    String formatted = _addSpaces(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addSpaces(String digits) {
    if (digits.length <= 3) {
      return digits;
    } else if (digits.length <= 6) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    } else if (digits.length <= 9) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    } else {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 9)} ${digits.substring(9)}';
    }
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String formatted = _addSlash(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addSlash(String digits) {
    if (digits.length <= 2) {
      return digits;
    } else {
      return '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
  }
}
