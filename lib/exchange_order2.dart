import 'package:flutter/material.dart';
import 'package:ojawa/new_account.dart';
import 'package:ojawa/orders_page.dart';
import 'package:ojawa/productDetails.dart';

class ExchangeOrder2 extends StatefulWidget {
  final Function goToOrdersPage;
  const ExchangeOrder2({super.key, required this.goToOrdersPage});

  @override
  _ExchangeOrder2State createState() => _ExchangeOrder2State();
}

class _ExchangeOrder2State extends State<ExchangeOrder2> {
  Map<String, bool> _isLikedMap = {};
  int? _selectedRadioValue = 0;
  final TextEditingController _commentController = TextEditingController();

  void _submittedReview() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/Tick.png', // Replace with the item's image asset or network path
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(
                height: (28 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Center(
              child: Text(
                'Review Submitted Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
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
                  _trackOrder();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return const Color(0xFF1D4ED8);
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF1D4ED8);
                      }
                      return Colors.white;
                    },
                  ),
                  elevation: WidgetStateProperty.all<double>(4.0),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                child: const Text(
                  'Track Status',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
                height: (20 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            Container(
              width: double.infinity,
              height: (60 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.goToOrdersPage();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF1D4ED8);
                      }
                      return Colors.white;
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return const Color(0xFF1D4ED8);
                    },
                  ),
                  elevation: WidgetStateProperty.all<double>(4.0),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Color(0xFF1D4ED8)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 14.0,
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
  }

  void _trackOrder() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Track Order',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    _buildOrderStep(
                      timeStamp: "10:30 AM",
                      title: "Order Confirmed",
                      subText: "Your order has been confirmed",
                      isCompleted: true,
                    ),
                    _buildConnectingLine(isCompleted: true),
                    _buildOrderStep(
                      timeStamp: "01:00 PM",
                      title: "Order Shipped",
                      subText: "Order shipped from [destination]",
                      isCompleted: true,
                    ),
                    _buildConnectingLine(isCompleted: false),
                    _buildOrderStep(
                      timeStamp: "",
                      title: "Out for Delivery",
                      subText: "",
                      isCompleted: false,
                    ),
                    _buildConnectingLine(isCompleted: false),
                    _buildOrderStep(
                      timeStamp: "",
                      title: "Order Delivered",
                      subText: "",
                      isCompleted: false,
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
                        orderCards('Pickup Address', "[Name of the Receiver]",
                            "[Address of the Receiver]", false),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Exchange expected to be delivered 21st Jan 2025",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
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
                                  _submittedReview();
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
                                'Proceed to Exchange',
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

  Widget orderCards(
      String type, String prodDetails, String prodDetails2, bool refund) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.2), // Softer shadow for a clean look
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2), // Position shadow for depth
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        prodDetails,
                        softWrap: true,
                        style: const TextStyle(fontSize: 16.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      if (refund == false)
                        Expanded(
                          flex: 5,
                          child: Container(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    prodDetails2,
                    softWrap: true,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            if (refund) ...[
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: (50 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewAccount(key: UniqueKey()),
                            ),
                          );
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2, color: Color(0xFF1D4ED8)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        child: const Text(
                          '+ Add New Account',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStep({
    required String timeStamp,
    required String title,
    required String subText,
    required bool isCompleted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column for vertical alignment
          if (timeStamp.isNotEmpty) ...[
            Text(
              timeStamp,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ] else ...[
            SizedBox(width: MediaQuery.of(context).size.width * 0.145),
          ],
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),

          Icon(
            Icons.check_circle,
            color: isCompleted ? Colors.blue : Colors.grey,
            size: 24,
          ),

          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          // Title and subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: isCompleted ? Colors.black : Colors.grey,
                  ),
                ),
                if (subText.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    subText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLine({required bool isCompleted}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 40, // Height of the line
          width: 2,
          color: isCompleted ? Colors.blue : Colors.grey,
          margin: const EdgeInsets.only(left: 74.0), // Align with ticks
        ));
  }
}
