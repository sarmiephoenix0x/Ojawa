import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_gap.dart';
import '../../controllers/apply_coupon_controller.dart';
import 'widgets/coupon.dart';

class ApplyCoupon extends StatefulWidget {
  const ApplyCoupon({super.key});

  @override
  _ApplyCouponState createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  @override
  Widget build(BuildContext context) {
    final applyCouponController = Provider.of<ApplyCouponController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply Coupon',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: applyCouponController.searchController,
                  focusNode: applyCouponController.searchFocusNode,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Search Coupon',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF008000)),
                      onPressed: () {
                        if (applyCouponController
                            .searchController.text.isNotEmpty) {
                          applyCouponController.performSearch(context);
                        }
                      },
                    ),
                    suffixIcon: applyCouponController.isSearching
                        ? IconButton(
                            icon: Icon(Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface), // White close icon
                            onPressed: () {
                              applyCouponController.searchController.clear();
                              applyCouponController.setIsSearching(false);
                            },
                          )
                        : null,
                  ),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  onChanged: (value) {
                    applyCouponController.setIsSearching(true);
                  },
                ),
              ),
              if (applyCouponController.isSearching) ...[
                if (applyCouponController.searchLoading) ...[
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onSurface,
                      ), // Use primary color
                      strokeWidth: 4.0,
                    ),
                  )
                ] else ...[
                  if (applyCouponController.searchResults.isNotEmpty) ...[
                    ListView.builder(
                      itemCount: applyCouponController.searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            applyCouponController.searchResults[index]
                                    ['title'] ??
                                'No Title',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            applyCouponController.searchResults[index]
                                    ['description'] ??
                                'No Description',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    )
                  ] else ...[
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/NotFound.png',
                                height: 300,
                              ),
                              Gap(MediaQuery.of(context).size.height * 0.03,
                                  useMediaQuery: false),
                              Text(
                                'No Coupon Found!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                ]
              ] else ...[
                Flexible(
                  child: ListView(children: const [
                    Coupon(
                        title: "FIRST30",
                        content:
                            "Get 30% Cashback on your first order. Apply Code to activate... Hurry Now!"),
                    Coupon(
                        title: "ALL15",
                        content:
                            "Get 15% on listed brands. Apply coupon to activate. Hurry Up."),
                  ]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
