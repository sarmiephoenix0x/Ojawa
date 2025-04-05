import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_gap.dart';
import '../../controllers/categories_page_controller.dart';
import '../categories_details/categories_details.dart';
import 'widgets/products_button.dart';
import '../../../core/widgets/custom_filter.dart';
import 'widgets/products_page_products.dart';

class ProductsPage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  // final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedImageIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const ProductsPage(
      {super.key,
      required this.goToCategoriesPage,
      required this.goToOrdersPage,
      required this.goToProfilePage,
      // required this.scaffoldKey,
      required this.selectedImageIndex,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final categoriesPageController =
    //     Provider.of<CategoriesPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => CategoriesPageController(
          mainSelectedImageIndex: widget.selectedImageIndex),
      child: Consumer<CategoriesPageController>(
          builder: (context, categoriesPageController, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Main content
              Column(
                children: [
                  Container(
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
                    child: const Row(
                      children: [
                        Text('Products',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: const [
                        Gap(20),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                CustomFilter(
                                  text: 'All',
                                  isActive: true,
                                ),
                                Gap(
                                  15,
                                  isHorizontal: true,
                                ),
                                CustomFilter(text: 'Sold Out'),
                                Gap(
                                  15,
                                  isHorizontal: true,
                                ),
                                CustomFilter(text: 'Low In Stock'),
                              ],
                            )),
                        Gap(20),
                        ProductsPageProducts(
                          name: 'Adidas White Sneakers',
                          img: 'images/Img6.png',
                          price: '6,000,000',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
