import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_gap.dart';
import '../../controllers/orders_page_controller.dart';

class OrdersPage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  // final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const OrdersPage(
      {super.key,
      required this.goToOrdersPage,
      required this.goToCategoriesPage,
      required this.goToProfilePage,
      // required this.scaffoldKey,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    //final ordersPageController = Provider.of<OrdersPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => OrdersPageController(
        onToggleDarkMode: widget.onToggleDarkMode,
        isDarkMode: widget.isDarkMode,
      ),
      child: Consumer<OrdersPageController>(
        builder: (context, ordersPageController, child) {
          return Scaffold(
            body: Stack(
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
                              Text('Orders',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text('All Orders',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  )),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller:
                                    ordersPageController.searchController,
                                focusNode: ordersPageController.searchFocusNode,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Search Order',
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
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
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Color(0xFF008000)),
                                    onPressed: () {
                                      if (ordersPageController
                                          .searchController.text.isNotEmpty) {
                                        ordersPageController.performSearch(
                                            ordersPageController
                                                .searchController.text
                                                .trim());
                                      }
                                    },
                                  ),
                                  suffixIcon: ordersPageController.isSearching
                                      ? IconButton(
                                          icon: Icon(Icons.close,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                          onPressed: () {
                                            ordersPageController
                                                .searchController
                                                .clear();
                                            ordersPageController
                                                .setIsSearching(false);
                                          },
                                        )
                                      : null,
                                ),
                                cursorColor:
                                    Theme.of(context).colorScheme.onSurface,
                                onChanged: (value) {
                                  ordersPageController.setIsSearching(true);
                                },
                              ),
                            ),
                            const Gap(5, isHorizontal: true),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 6.0, top: 2.0, bottom: 2.0),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Flexible(
                                      child: Text(
                                        "Export",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (ordersPageController.isSearching) ...[
                      if (ordersPageController.searchLoading) ...[
                        Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onSurface,
                            ),
                            strokeWidth: 4.0,
                          ),
                        )
                      ] else ...[
                        if (ordersPageController.searchResults.isNotEmpty) ...[
                          ListView.builder(
                            itemCount:
                                ordersPageController.searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  ordersPageController.searchResults[index]
                                          ['title'] ??
                                      'No Title',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                subtitle: Text(
                                  ordersPageController.searchResults[index]
                                          ['description'] ??
                                      'No Description',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              );
                            },
                          )
                        ] else ...[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/NoOrderFound.png',
                                    height: 200,
                                  ),
                                  const SizedBox(height: 20),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'No Orders Found!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromARGB(113, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Currently, you do not have any orders. When you order something, it will appear here',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(113, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: (60 /
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
                                              return const Color(0xFF1D4ED8);
                                            },
                                          ),
                                          foregroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return const Color(0xFF1D4ED8);
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Start Shopping',
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
                        ]
                      ]
                    ] else ...[
                      const Gap(20),
                      Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ordersPageController.buildHeaders(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: HorizontalDataTable(
                          leftHandSideColumnWidth: 50,
                          rightHandSideColumnWidth: 950,
                          isFixedHeader: false,
                          leftSideChildren:
                              ordersPageController.buildLeftColumn(),
                          rightSideChildren:
                              ordersPageController.buildRightColumns(),
                          itemCount: ordersPageController.orders.length,
                          elevation: 5,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
