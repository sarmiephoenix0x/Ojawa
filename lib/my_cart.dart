import 'package:flutter/material.dart';
import 'package:ojawa/apply_coupon.dart';
import 'package:ojawa/new_address.dart';
import 'package:ojawa/payment_method.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  bool isLoading = false;
  int? _selectedRadioValue;
  bool isCouponEnabled = false;

  List<Map<String, String>> items = [
    {
      'img': 'images/Img2.png',
      'details': 'Calvin Clein Regular fit slim fit shirt',
      'amount': '\$52',
      'slashedPrice': '\$60',
      'discount': '20% off',
    },

    {
      'img': 'images/Img3.png',
      'details': 'Calvin Clein Regular fit slim fit shirt',
      'amount': '\$62',
      'slashedPrice': '\$60',
      'discount': '40% off',
    },
    // You can add more items here
  ];

  // Method to remove an item from the list
  void _removeItem(int index) {
    setState(() {
      items.removeAt(index); // Remove the item from the list
    });
  }

  void _changeAddress() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Change Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                        height: (28 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    address(
                      "Home",
                      "[Receiver’s Name]",
                      "2917 Anywhere You Choose, Rd. St. Frestine, State, Country",
                      1,
                      setState, // Pass the setState function
                    ),
                    address(
                      "Work",
                      "[Receiver’s Name]",
                      "1234 Some Other Place, Rd. City, State, Country",
                      2,
                      setState, // Pass the setState function
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewAddress(key: UniqueKey()),
                              ),
                            );
                          },
                          child: const Text(
                            '+ Add New Address',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: (28 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    Container(
                      width: double.infinity,
                      height: (60 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedRadioValue != null) {
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (_selectedRadioValue != null) {
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
                              if (_selectedRadioValue != null) {
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
                              final bool isFilled = _selectedRadioValue != null;

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
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Deliver To:",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "[Name of Users]",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Text(
                              "[Address of the recipient of the above]",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: (55 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _changeAddress();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const Color(0xFF1D4ED8);
                                  }
                                  return Colors.white;
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.white;
                                  }
                                  return const Color(0xFF1D4ED8);
                                },
                              ),
                              elevation: WidgetStateProperty.all<double>(4.0),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 3, color: Color(0xFF1D4ED8)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Change',
                              softWrap: false,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  // Wrap ListView.builder with Expanded to let it take available space
                  SizedBox(
                    height: (200 / MediaQuery.of(context).size.height) *
                        MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return item(
                          items[index]['img']!,
                          items[index]['details']!,
                          items[index]['amount']!,
                          items[index]['slashedPrice']!,
                          items[index]['discount']!,
                          onRemove: () =>
                              _removeItem(index), // Pass the remove function
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplyCoupon(key: UniqueKey()),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'images/Coupon.png',
                                height: 22,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                'Apply Coupon',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.navigate_next,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 30,
                            ),
                            onPressed: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Price Details (2 Items)',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  priceDetails("Total Price ", "\$87"),
                  priceDetails("Discount", "\$12"),
                  priceDetails("Delivery Fee", "\$8"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  if (isCouponEnabled)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "FIRST30 [Applied]",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          const Text(
                            "Get 30% Cashback on your first order. Apply Code to activate... Hurry Now!",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4, // Adjust flex for title width distribution
                            child: Text(
                              "Total Amount",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 4, // Adjust flex for name width distribution
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "\$87",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentMethodPage(key: UniqueKey()),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        elevation: 4.0,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 3, color: Color(0xFF1D4ED8)),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: const Text(
                        'Continue',
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

  Widget item(
    String img,
    String details,
    String amount,
    String slashedPrice,
    String discount, {
    required VoidCallback onRemove, // Callback to remove the item
  }) {
    final ValueNotifier<String> selectedSizeNotifier =
        ValueNotifier<String>("L");
    final ValueNotifier<int> quantityNotifier = ValueNotifier<int>(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left-side Image with Remove button below
            Column(
              children: [
                // Image with dynamic height based on content
                Image.asset(
                  img,
                  width: 100,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(
                width: (16.0 / MediaQuery.of(context).size.width) *
                    MediaQuery.of(context).size.width),
            // Right-side Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details,
                    style: TextStyle(fontSize: 16.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                      height: (10.0 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  Row(
                    children: [
                      Text(
                        amount,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(
                          width: (16.0 / MediaQuery.of(context).size.width) *
                              MediaQuery.of(context).size.width),
                      Text(
                        slashedPrice,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          decorationColor: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width: (16.0 / MediaQuery.of(context).size.width) *
                              MediaQuery.of(context).size.width),
                      Text(
                        discount,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: (10.0 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  // Size Dropdown and Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Size Dropdown
                      ValueListenableBuilder<String>(
                        valueListenable: selectedSizeNotifier,
                        builder: (context, selectedSize, child) {
                          return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(20, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  value: selectedSize,
                                  underline:
                                      SizedBox(), // Remove default underline
                                  items: ['S', 'M', 'L', 'XL', 'XXL']
                                      .map((String size) {
                                    return DropdownMenuItem<String>(
                                      value: size,
                                      child: Text(size),
                                    );
                                  }).toList(),
                                  onChanged: (String? newSize) {
                                    if (newSize != null) {
                                      selectedSizeNotifier.value =
                                          newSize; // Update size
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Quantity Selector
                      ValueListenableBuilder<int>(
                        valueListenable: quantityNotifier,
                        builder: (context, quantity, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(20, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      quantityNotifier.value =
                                          quantity - 1; // Decrease quantity
                                    }
                                  },
                                ),
                                Text('$quantity',
                                    style: const TextStyle(fontSize: 18)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    quantityNotifier.value =
                                        quantity + 1; // Increase quantity
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align Remove to the right
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove, // Call the callback on press
            ),
            const Text(
              "Remove",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget priceDetails(String title, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 4, // Adjust flex for title width distribution
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 4, // Adjust flex for name width distribution
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget address(String type, String name, String address, int value,
      StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRadioValue = value; // Update selected value
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              width: 0.8,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55.0),
                      border: Border.all(
                        width: _selectedRadioValue == value ? 3 : 0.8,
                        color: _selectedRadioValue == value
                            ? const Color(0xFF1D4ED8)
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(
                  height: (28 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height),
              Text(
                address,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
