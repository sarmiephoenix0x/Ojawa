import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/payment_method_controller.dart';
import '../add_new_card/add_new_card.dart';
import '../successful_order_page/successful_order_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final double totalWithDiscount;
  const PaymentMethodPage({super.key, required this.totalWithDiscount});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    final paymentMethodController =
        Provider.of<PaymentMethodController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              // Credit/Debit Card Section
              ExpansionTile(
                leading: const Icon(Icons.credit_card),
                title: const Text("Credit/Debit Card"),
                trailing: Icon(paymentMethodController.isCreditCardExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
                onExpansionChanged: (expanded) {
                  paymentMethodController.setIsCreditCardExpanded(expanded);
                },
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.add, color: Colors.blue),
                    ),
                    title: const Text("Add New Card"),
                    trailing: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddNewCard(key: UniqueKey()),
                            ),
                          );
                        },
                        child: const Icon(Icons.navigate_next)),
                    onTap: () {
                      // Navigate to Add New Card page
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: const Text("... ... ... 1234"),
                    trailing: Radio<int>(
                      value: 1,
                      groupValue: paymentMethodController.selectedPaymentMethod,
                      onChanged: (value) {
                        paymentMethodController
                            .setSelectedPaymentMethod(value!);
                        paymentMethodController.setButtonText("Make Payment");
                      },
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Net Banking Section
              ExpansionTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("Net Banking"),
                trailing: Icon(paymentMethodController.isNetBankingExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
                onExpansionChanged: (expanded) {
                  paymentMethodController.setIsNetBankingExpanded(expanded);
                },
                children: [
                  // Add bank options here if needed
                ],
              ),
              const Divider(),

              // Wallet Section
              ExpansionTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text("Wallet"),
                trailing: Icon(paymentMethodController.isWalletExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
                onExpansionChanged: (expanded) {
                  paymentMethodController.setIsWalletExpanded(expanded);
                },
                children: [
                  // Add wallet options here if needed
                ],
              ),
              const Divider(),

              // Cash on Delivery Section
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text("Cash On Delivery"),
                trailing: Radio<int>(
                  value: 2,
                  groupValue: paymentMethodController.selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethodController.setSelectedPaymentMethod(value!);
                      paymentMethodController.setButtonText("Place Order");
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Amount",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "\$${widget.totalWithDiscount}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (paymentMethodController.selectedPaymentMethod ==
                            1) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         AddNewCard(key: UniqueKey()),
                          //   ),
                          // );
                        } else if (paymentMethodController
                                .selectedPaymentMethod ==
                            2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SuccessfulOrderPage(key: UniqueKey()),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            paymentMethodController.selectedPaymentMethod != 0
                                ? const Color(0xFF1D4ED8)
                                : Colors.grey,
                        foregroundColor: Colors.white,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 3,
                              color: paymentMethodController
                                          .selectedPaymentMethod !=
                                      0
                                  ? const Color(0xFF1D4ED8)
                                  : Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: Text(
                        paymentMethodController.buttonText,
                        style: TextStyle(
                          fontSize: 13.0,
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
        ],
      ),
    );
  }
}
