import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../controllers/add_new_card_controller.dart';
import 'card_formatters.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final addNewCardController = Provider.of<AddNewCardController>(context);
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
                  Gap(MediaQuery.of(context).size.height * 0.05,
                      useMediaQuery: false),
                  const AuthLabel(
                    title: 'Card Holder Name',
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.04,
                      useMediaQuery: false),
                  AuthTextField(
                    label: 'Sarmie Pheonix',
                    fontFamily: 'Inter',
                    controller: addNewCardController.cardHolderNameController,
                    focusNode: addNewCardController.cardHolderNameFocusNode,
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.04,
                      useMediaQuery: false),
                  const AuthLabel(
                    title: 'Card Number',
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.04,
                      useMediaQuery: false),
                  AuthTextField(
                    label: '000 000 000 00',
                    fontFamily: 'Inter',
                    controller: addNewCardController.cardNumberController,
                    focusNode: addNewCardController.cardNumberFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardNumberFormatter(),
                    ],
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.04,
                      useMediaQuery: false),
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
                                const AuthLabel(
                                  title: 'Expiry Date',
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  isPaddingActive: false,
                                ),
                                Gap(MediaQuery.of(context).size.height * 0.04,
                                    useMediaQuery: false),
                                AuthTextField(
                                  label: 'MM/YY',
                                  fontFamily: 'Inter',
                                  controller:
                                      addNewCardController.expiryDateController,
                                  focusNode:
                                      addNewCardController.expiryDateFocusNode,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    ExpiryDateFormatter(),
                                  ],
                                  isPaddingActive: false,
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
                                const AuthLabel(
                                  title: 'CCV',
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  isPaddingActive: false,
                                ),
                                Gap(MediaQuery.of(context).size.height * 0.04,
                                    useMediaQuery: false),
                                AuthTextField(
                                  label: '000',
                                  fontFamily: 'Inter',
                                  controller:
                                      addNewCardController.ccvController,
                                  focusNode: addNewCardController.ccvFocusNode,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  isPaddingActive: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.07,
                      useMediaQuery: false),
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
                            if (addNewCardController
                                    .cardHolderNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.cardNumberController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.expiryDateController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.ccvController.text
                                    .trim()
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
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (addNewCardController
                                    .cardHolderNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.cardNumberController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.expiryDateController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.ccvController.text
                                    .trim()
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
                            final bool isFilled = addNewCardController
                                    .cardHolderNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.cardNumberController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.expiryDateController.text
                                    .trim()
                                    .isNotEmpty &&
                                addNewCardController.ccvController.text
                                    .trim()
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
                      child: addNewCardController.isLoading
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
