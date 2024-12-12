import 'package:flutter/material.dart';
import 'package:ojawa/exchange_order2.dart';
import 'package:ojawa/productDetails.dart';

class ExchangeOrder extends StatefulWidget {
  final Function goToOrdersPage;
  const ExchangeOrder({super.key, required this.goToOrdersPage});

  @override
  _ExchangeOrderState createState() => _ExchangeOrderState();
}

class _ExchangeOrderState extends State<ExchangeOrder> {
  Map<String, bool> _isLikedMap = {};
  int? _selectedRadioValue;
  int? _selectedRadioValue2 = 3;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
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
                            icon: Icon(
                              Icons.arrow_back,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('Exchange Order',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
                          Container(
                            height: (40 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () {},
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
                                        width: 2, color: Color(0xFF1D4ED8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'images/Help.png',
                                    height: 22,
                                    color: const Color(0xFF1D4ED8),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  const Text(
                                    "Help",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16.0,
                                      color: Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "ORDER ID: 12123353555176",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Copy",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          child: Container(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8F1FB),
                              borderRadius:
                                  BorderRadius.circular(12), // Smoother corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.2), // Softer shadow for a clean look
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(
                                      0, 2), // Position shadow for depth
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Order Delivered",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "21st December, 2024",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                  "images/Img4.png",
                                  width: 100,
                                  height:
                                      MediaQuery.of(context).size.height * 0.21,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                  width: (16.0 /
                                          MediaQuery.of(context).size.width) *
                                      MediaQuery.of(context).size.width),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.21,
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                      flex: 0,
                                      child: Text(
                                        "Allen Solly",
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14.0),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Allen Solly Regular fit cotton shirt",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Text(
                                            '\$35',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                          const Text(
                                            '\$40.25',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness: 2,
                                              decorationColor: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Size:",
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  width: (6.0 /
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width) *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width),
                                              const Text(
                                                "L",
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              width: (20.0 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width),
                                          Row(
                                            children: [
                                              const Text(
                                                "Color:",
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  width: (6.0 /
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width) *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width),
                                              const Text(
                                                "Black",
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Reason for exchange",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Please, tell us correct reason for the exchange. This information is to only improve our service",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        reason("Size/Fit Issue", 1),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        reason("Received wrong product (color/size)", 2),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        reason("Received defective product", 3),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              labelText: 'Additional Comment',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Choose another size",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Please select another size",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Current Size: L',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              size('S', 1),
                              size('M', 2),
                              size('L', 3),
                              size('XL', 4),
                              size('XXL', 5),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: (60 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_selectedRadioValue != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExchangeOrder2(
                                          key: UniqueKey(),
                                          goToOrdersPage:
                                              widget.goToOrdersPage),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (_selectedRadioValue != null) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
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
                                      if (states
                                          .contains(WidgetState.pressed)) {
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
                                    final bool isFilled =
                                        _selectedRadioValue != null;

                                    return RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 3,
                                        color: isFilled
                                            ? const Color(0xFF1D4ED8)
                                            : Colors.grey,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    );
                                  },
                                ),
                              ),
                              child: const Text(
                                'Continue',
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
          ],
        ),
      ),
    );
  }

  Widget reason(String text, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRadioValue = value; // Update selected value
          });
        },
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
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
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget size(String text, int value) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedRadioValue2 = value;
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: _selectedRadioValue2 == value
                  ? const Color(0xFF1D4ED8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 0.8,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
