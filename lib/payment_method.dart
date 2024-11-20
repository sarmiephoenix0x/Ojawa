import 'package:flutter/material.dart';
import 'package:ojawa/add_new_card.dart';
import 'package:ojawa/successful_order_page.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  bool _isCreditCardExpanded = false;
  bool _isNetBankingExpanded = false;
  bool _isWalletExpanded = false;
  int _selectedPaymentMethod = 0;
  String buttonText = "Continue";

  @override
  Widget build(BuildContext context) {
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
                trailing: Icon(_isCreditCardExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isCreditCardExpanded = expanded;
                  });
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
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                          buttonText = "Make Payment";
                        });
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
                trailing: Icon(_isNetBankingExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isNetBankingExpanded = expanded;
                  });
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
                trailing: Icon(_isWalletExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isWalletExpanded = expanded;
                  });
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
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                      buttonText = "Place Order";
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
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "\$87",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
                        if (_selectedPaymentMethod == 1) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         AddNewCard(key: UniqueKey()),
                          //   ),
                          // );
                        } else if (_selectedPaymentMethod == 2) {
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
                        backgroundColor: _selectedPaymentMethod != 0
                            ? const Color(0xFF1D4ED8)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 3,
                              color: _selectedPaymentMethod != 0
                                  ? const Color(0xFF1D4ED8)
                                  : Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: Text(
                        buttonText,
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
