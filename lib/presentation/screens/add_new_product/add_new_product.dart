import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllers/add_new_product_controller.dart';
import 'add_new_product2.dart';
import 'widgets/bottom_sheets/product_made_in.dart';
import 'widgets/bottom_sheets/product_type.dart';
import 'widgets/bottom_sheets/select_indicator.dart';
import 'widgets/bottom_sheets/select_tax.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
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
                          const Text('Step 1 of 4',
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
                          child: AuthLabel(title: 'Product Name'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.productNameController,
                          focusNode:
                              addNewProductController.productNameFocusNode,
                          label: 'Add New Product Name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(
                              title:
                                  'Tags (these tags helps in search result)'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController.tagsController,
                          focusNode: addNewProductController.tagsFocusNode,
                          label:
                              'Type in some tags for example AC, Cooler, Fridge',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Product Type'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.productTypeController,
                          focusNode:
                              addNewProductController.productTypeFocusNode,
                          label: 'Physical Product',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              productType(context);
                            },
                          ),
                          readOnly: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Select Tax'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.selectTaxController,
                          focusNode: addNewProductController.selectTaxFocusNode,
                          label: 'Select Tax 0%',
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
                          child: AuthLabel(title: 'Select Indicator'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.selectIndicatorController,
                          focusNode:
                              addNewProductController.selectIndicatorFocusNode,
                          label: 'Select Indicator',
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
                          child: AuthLabel(title: 'Product Made In'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.productMadeInController,
                          focusNode:
                              addNewProductController.productMadeInFocusNode,
                          label: 'Product Made In',
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
                          child: AuthLabel(title: 'HSN Code'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: addNewProductController.hsnCodeController,
                          focusNode: addNewProductController.hsnCodeFocusNode,
                          label: 'HSN Code',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Short Description'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              addNewProductController.descriptionController,
                          focusNode:
                              addNewProductController.descriptionFocusNode,
                          label: 'Description',
                          maxLines: 4,
                        ),
                        const Gap(50),
                        CustomButton(
                            width: double.infinity,
                            isLoading: addNewProductController.isLoading,
                            text: 'Next',
                            bgColor: Colors.black,
                            borderColor: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewProduct2(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            }),
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
