import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllers/add_new_product_controller.dart';
import '../new_address/widgets/address_type.dart';
import 'widgets/bottom_sheets/deliverable_type.dart';
import 'widgets/bottom_sheets/product_made_in.dart';
import 'widgets/bottom_sheets/select_indicator.dart';
import 'widgets/bottom_sheets/select_tax.dart';
import 'widgets/product_option.dart';

class AddNewProduct2 extends StatefulWidget {
  const AddNewProduct2({super.key});

  @override
  _AddNewProduct2State createState() => _AddNewProduct2State();
}

class _AddNewProduct2State extends State<AddNewProduct2> {
  @override
  Widget build(BuildContext context) {
    final addNewProductController =
        Provider.of<AddNewProductControllers>(context);
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
                          const Text('Add New Product',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
                          const Text('Step 2 of 4',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              )),
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
                          child: AuthLabel(title: 'Total Allowed Quantity'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController
                              .totalAllowedQuantityController,
                          focusNode: addNewProductController
                              .totalAllowedQuantityFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Minimum Order Quantity'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController
                              .minimumOrderQuantityController,
                          focusNode: addNewProductController
                              .minimumOrderQuantityFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Quantity Step Size'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController
                              .quantityStepSizeController,
                          focusNode:
                              addNewProductController.quantityStepSizeFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Warranty Period'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.warrantyPeriodController,
                          focusNode:
                              addNewProductController.warrantyPeriodFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Guarantee Period'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.guaranteePeriodController,
                          focusNode:
                              addNewProductController.guaranteePeriodFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Deliverable Type'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.deliverableTypeController,
                          focusNode:
                              addNewProductController.deliverableTypeFocusNode,
                          label: 'All',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              deliverableType(context);
                            },
                          ),
                          readOnly: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Select ZipCode'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController.zipCodeController,
                          focusNode: addNewProductController.zipCodeFocusNode,
                          label: 'Not Selected Yet',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              selectTax(context);
                            },
                          ),
                          readOnly: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Select Category'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.categoryController,
                          focusNode: addNewProductController.categoryFocusNode,
                          label: 'Not Selected Yet (e.g. Vegetable, Fashion)',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              selectIndicator(context);
                            },
                          ),
                          readOnly: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Select Brand'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController.brandController,
                          focusNode: addNewProductController.brandFocusNode,
                          label:
                              'Not Selected Yet (e.g. TaTa, Apple, Microsoft)',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              productMadeIn(
                                  context,
                                  addNewProductController
                                      .productMadeInController,
                                  addNewProductController
                                      .productMadeInFocusNode);
                            },
                          ),
                          readOnly: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Select Pick-Up Location'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.pickUpLocationController,
                          focusNode:
                              addNewProductController.pickUpLocationFocusNode,
                          label: 'Pict-Up Location Not Selected Yet',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              productMadeIn(
                                  context,
                                  addNewProductController
                                      .productMadeInController,
                                  addNewProductController
                                      .productMadeInFocusNode);
                            },
                          ),
                          readOnly: true,
                        ),
                        const Gap(30),
                        Column(
                          children: [
                            ProductOption(
                              text: "Is Product Returnable?",
                              value: 1,
                              selectedRadioValue:
                                  addNewProductController.selectedRadioValue,
                              setSelectedRadioValue:
                                  addNewProductController.setSelectedRadioValue,
                            ),
                            const Gap(20),
                            ProductOption(
                              text: "Is Product COD Allowed?",
                              value: 2,
                              selectedRadioValue:
                                  addNewProductController.selectedRadioValue,
                              setSelectedRadioValue:
                                  addNewProductController.setSelectedRadioValue,
                            ),
                            const Gap(20),
                            ProductOption(
                              text: "Tax Included in price?",
                              value: 3,
                              selectedRadioValue:
                                  addNewProductController.selectedRadioValue,
                              setSelectedRadioValue:
                                  addNewProductController.setSelectedRadioValue,
                            ),
                            const Gap(20),
                            ProductOption(
                              text: "Is Product Cancelable? (Till Received)",
                              value: 4,
                              selectedRadioValue:
                                  addNewProductController.selectedRadioValue,
                              setSelectedRadioValue:
                                  addNewProductController.setSelectedRadioValue,
                            ),
                            const Gap(20),
                            ProductOption(
                              text: "Is Attachment Required?",
                              value: 5,
                              selectedRadioValue:
                                  addNewProductController.selectedRadioValue,
                              setSelectedRadioValue:
                                  addNewProductController.setSelectedRadioValue,
                            ),
                          ],
                        ),
                        const Gap(50),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                    isLoading:
                                        addNewProductController.isLoading,
                                    text: 'Back',
                                    bgColor: Colors.white,
                                    fgColor: Colors.black,
                                    borderColor: Colors.black,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              const Gap(10, isHorizontal: true),
                              Expanded(
                                child: CustomButton(
                                  isLoading: addNewProductController.isLoading,
                                  text: 'Next',
                                  bgColor: Colors.black,
                                  borderColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
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
