import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_gap.dart';
import '../../controllers/order_details_controller.dart';
import 'widgets/order_attribute.dart';
import 'widgets/order_setup.dart';

class OrderDetails extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  final String id;
  final String name;
  final String date;
  final String date2;
  final String amount;
  final String amountStatus;
  final String orderType;
  final String orderStatus;
  final String? profileImage;
  final List<Map<String, String>> order;
  const OrderDetails(
      {super.key,
      required this.onToggleDarkMode,
      required this.isDarkMode,
      required this.order,
      required this.id,
      required this.name,
      required this.date,
      required this.date2,
      required this.amount,
      required this.amountStatus,
      required this.orderType,
      required this.orderStatus,
      this.profileImage});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    final orderDetailsController = Provider.of<OrderDetailsController>(context);
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          Text('Orders Details',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              )),
                          Spacer(),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.id,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                          )),
                                      Text(
                                        "${widget.date}, ${widget.date}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: (40 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return Colors.white;
                                            }

                                            return const Color(0xFF14AE5C);
                                          },
                                        ),
                                        foregroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return const Color(0xFF14AE5C);
                                            }
                                            return Colors.white;
                                          },
                                        ),
                                        elevation:
                                            WidgetStateProperty.all<double>(
                                                4.0),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Color(0xFF14AE5C)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: IconButton(
                                              icon: Icon(Icons.print,
                                                  color: Colors.white),
                                              onPressed: null,
                                            ),
                                          ),
                                          Gap(5, isHorizontal: true),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              "Print Invoice",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OrderAttribute(
                                text: 'Payment Status',
                                text2: widget.amountStatus,
                              ),
                              const OrderAttribute(
                                text: 'Cutlery',
                                text2: 'No',
                              ),
                              const OrderAttribute(
                                text: 'Payment Method',
                                text2: 'Cash On Delivery',
                              ),
                              OrderAttribute(
                                text: 'Order Type',
                                text2: widget.orderType,
                              ),
                              OrderAttribute(
                                text: 'Order Status',
                                text2: widget.orderStatus,
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Row(
                                  children: [
                                    Text('Order Setup',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                        )),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: (40 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return Colors.white;
                                              }

                                              return const Color(0xFF14AE5C);
                                            },
                                          ),
                                          foregroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return const Color(0xFF14AE5C);
                                              }
                                              return Colors.white;
                                            },
                                          ),
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  4.0),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Color(0xFF14AE5C)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Confirm This Order",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(15, isHorizontal: true),
                                    Container(
                                      height: (40 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return Colors.white;
                                              }

                                              return const Color(0xFFFF0000);
                                            },
                                          ),
                                          foregroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return const Color(0xFFFF0000);
                                              }
                                              return Colors.white;
                                            },
                                          ),
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  4.0),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Color(0xFFFF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel This Order",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Container(
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children:
                                        orderDetailsController.buildHeaders(),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: HorizontalDataTable(
                                  leftHandSideColumnWidth: 50,
                                  rightHandSideColumnWidth: 750,
                                  isFixedHeader: false,
                                  leftSideChildren:
                                      orderDetailsController.buildLeftColumn(2),
                                  rightSideChildren:
                                      orderDetailsController.buildRightColumns(
                                          2, widget.name, widget.amount),
                                  itemCount: 2,
                                  elevation: 5,
                                ),
                              ),
                              const Gap(20),
                              const Divider(
                                  color: Colors.grey,
                                  height: 1.0,
                                  thickness: 2.0),
                              const Gap(20),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderAttribute(
                                      text: 'Item Price',
                                      text2: widget.amount,
                                      isAmount: true),
                                  const OrderAttribute(
                                      text: 'Addon Cost', text2: ''),
                                ],
                              ),
                              const Gap(20),
                              const Divider(
                                  color: Colors.grey,
                                  height: 1.0,
                                  thickness: 2.0),
                              const Gap(20),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderAttribute(
                                      text: 'Subtotal (Tax Included)',
                                      text2: '00.00',
                                      isAmount: true),
                                  OrderAttribute(
                                      text: 'Discount',
                                      text2: '00.00',
                                      isAmount: true),
                                  OrderAttribute(
                                      text: 'Coupon Discount',
                                      text2: '00.00',
                                      isAmount: true),
                                  OrderAttribute(
                                      text: 'Delivery man tip',
                                      text2: '00.00',
                                      isAmount: true),
                                  OrderAttribute(
                                      text: 'Delivery fee',
                                      text2: '00.00',
                                      isAmount: true),
                                ],
                              ),
                              const Gap(20),
                              const Divider(
                                  color: Colors.grey,
                                  height: 1.0,
                                  thickness: 2.0),
                              const Gap(20),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const OrderAttribute(
                                      text: 'Additional Charges',
                                      text2: '00.00',
                                      isAmount: true),
                                  OrderAttribute(
                                      text: 'Total',
                                      text2: widget.amount,
                                      isAmount: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Row(
                                  children: [
                                    Text('Delivery Man',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                        )),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(113, 255, 0, 0),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: const Color(0xFFFF0000)),
                                ),
                                child: const Text(
                                  "Deliveryman Not Found",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0,
                                    color: Color(0xFFFF0000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Row(
                                  children: [
                                    Text('Customer',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                        )),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Row(
                                children: [
                                  if (widget.profileImage == null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: Container(
                                        width: (65 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width) *
                                            MediaQuery.of(context).size.width,
                                        height: (65 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) *
                                            MediaQuery.of(context).size.height,
                                        color: Colors.grey,
                                        child: Image.asset(
                                          'images/Profile.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  else if (widget.profileImage != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: Container(
                                        width: (55 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width) *
                                            MediaQuery.of(context).size.width,
                                        height: (55 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) *
                                            MediaQuery.of(context).size.height,
                                        color: Colors.grey,
                                        child: Image.network(
                                          widget.profileImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                            ); // Fallback if image fails
                                          },
                                        ),
                                      ),
                                    ),
                                  const Gap(5, isHorizontal: true),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'User',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          '8 Orders Delivered',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          '09016482578',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          'test@gmail.com',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const Gap(30),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Row(
                                  children: [
                                    Text('Delivery Info',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                        )),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              const Gap(20),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderAttribute(
                                    text: 'Name',
                                    text2: 'Not Available',
                                  ),
                                  OrderAttribute(
                                    text: 'Contact',
                                    text2: 'Not Available',
                                  ),
                                  OrderAttribute(
                                    text: 'Floor',
                                    text2: 'Not Available',
                                  ),
                                  OrderAttribute(
                                    text: 'House',
                                    text2: 'Not Available',
                                  ),
                                  OrderAttribute(
                                    text: 'Road',
                                    text2: 'Not Available',
                                  ),
                                ],
                              ),
                            ],
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
}
