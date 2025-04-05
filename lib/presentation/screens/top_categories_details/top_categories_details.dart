import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_error_message.dart';
import '../../../core/widgets/filter_by.dart';
import '../../../core/widgets/filter_widget.dart';
import '../../../core/widgets/product.dart';
import '../../controllers/top_categories_details_controller.dart';
import 'widgets/bottom_sheets/sort_by_sheet.dart';

class TopCategoriesDetails extends StatefulWidget {
  final int? id;
  final bool discountOnly;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  const TopCategoriesDetails(
      {super.key,
      required this.discountOnly,
      this.id,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  _TopCategoriesDetailsState createState() => _TopCategoriesDetailsState();
}

class _TopCategoriesDetailsState extends State<TopCategoriesDetails> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TopCategoriesDetailsController(
          id: widget.id, discountOnly: widget.discountOnly),
      child: Consumer<TopCategoriesDetailsController>(
          builder: (context, productDetailsController, child) {
        return Scaffold(
          appBar: AppBar(
            title: productDetailsController.isSearching
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: productDetailsController.searchController,
                      focusNode: productDetailsController.searchFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'What are you looking for?',
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
                          icon: const Icon(Icons.search,
                              color: Color(0xFF008000)),
                          onPressed: () {
                            // if (searchController.text.isNotEmpty) {
                            //   _searchProducts(searchController.text.trim());
                            // }
                          },
                        ),
                        suffixIcon: productDetailsController.isSearching
                            ? IconButton(
                                icon: Icon(Icons.close,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                onPressed: () {
                                  setState(() {
                                    productDetailsController
                                        .setIsSearching(false);
                                    productDetailsController.searchController
                                        .clear();
                                    productDetailsController.searchResults
                                        .clear(); // Clear search results
                                  });
                                },
                              )
                            : null,
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      onChanged: (value) {
                        productDetailsController.searchProducts(value);
                      },
                    ),
                  )
                : Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            productDetailsController.setIsSearching(true);
                          });
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      IconButton(
                        icon: Image.asset(
                          'images/bag.png',
                          height: 22,
                        ),
                        onPressed: () {
                          productDetailsController.loadCart(context,
                              widget.onToggleDarkMode, widget.isDarkMode);
                        },
                      ),
                    ],
                  ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      ),
                      child: productDetailsController
                              .isLoading // Check if loading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onSurface,
                            )) // Show loader while loading
                          : Text(
                              "${productDetailsController.isSearching ? productDetailsController.searchResults.length : productDetailsController.getActiveProducts().length} Items",
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    if (productDetailsController.isSearching) ...[
                      if (productDetailsController
                          .searchResults.isNotEmpty) ...[
                        // Show search results
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.62,
                            child: productDetailsController.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  )
                                : productDetailsController.products.isEmpty
                                    ? CustomErrorMessage(
                                        text:
                                            'No products available at the moment.',
                                        onPressed: () =>
                                            productDetailsController
                                                .fetchProducts(overwrite: true),
                                      )
                                    : NotificationListener<ScrollNotification>(
                                        onNotification:
                                            (ScrollNotification scrollInfo) {
                                          if (!productDetailsController
                                                  .isFetchingMore &&
                                              scrollInfo.metrics.pixels ==
                                                  scrollInfo.metrics
                                                      .maxScrollExtent) {
                                            // Trigger loading more products
                                            //fetchMoreProducts();
                                            return true;
                                          }
                                          return false;
                                        },
                                        child: ListView.builder(
                                          controller: productDetailsController
                                              .scrollController, // Attach the scroll controller
                                          scrollDirection: Axis
                                              .vertical, // Vertical scrolling
                                          itemCount: productDetailsController
                                                  .getActiveProducts()
                                                  .isNotEmpty
                                              ? productDetailsController
                                                      .getActiveProducts()
                                                      .length +
                                                  1
                                              : 0, // Avoids index errors when the list is empty

                                          itemBuilder: (context, index) {
                                            final activeProducts =
                                                productDetailsController
                                                    .getActiveProducts();
                                            if (index >=
                                                activeProducts.length) {
                                              // Show loader at the end
                                              return Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: productDetailsController
                                                        .isFetchingMore
                                                    ? CircularProgressIndicator(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      )
                                                    : const SizedBox.shrink(),
                                              );
                                            }

                                            final product =
                                                activeProducts[index];

                                            List<String> imgList = [];
                                            if (product['img'] != null) {
                                              if (product['img']
                                                  is List<String>) {
                                                imgList = List<String>.from(
                                                    product['img']);
                                              } else if (product['img']
                                                  is String) {
                                                imgList = [product['img']];
                                              }
                                            }
                                            List<String> fullImgList =
                                                imgList.map((img) {
                                              return '$img/download?project=677181a60009f5d039dd';
                                            }).toList();

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom:
                                                      20.0), // Add spacing between items
                                              child: Container(
                                                width: double
                                                    .infinity, // Full screen width
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .cardColor, // Optional: background color
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.all(
                                                    10.0), // Content padding
                                                child: Product(
                                                  itemId: product['id'],
                                                  name: product['name']!,
                                                  img: fullImgList,
                                                  details: product['details']!,
                                                  amount: product['amount']!,
                                                  slashedPrice:
                                                      product['slashedPrice']!,
                                                  discount:
                                                      product['discount']!,
                                                  starImg: product['starImg']!,
                                                  rating: product['rating']!,
                                                  rating2: product['rating2']!,
                                                  liked:
                                                      product['isInFavorite'],
                                                  onToggleDarkMode:
                                                      widget.onToggleDarkMode,
                                                  isDarkMode: widget.isDarkMode,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          ),
                        )
                      ] else ...[
                        // Show not found image when no results
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
                                  const SizedBox(height: 20),
                                  Text(
                                    'No results to display',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                    ] else if (widget.discountOnly == true) ...[
                      // Display filtered products
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: productDetailsController.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                )
                              : productDetailsController.products.isEmpty
                                  ? CustomErrorMessage(
                                      text:
                                          'No products available at the moment.',
                                      onPressed: () => productDetailsController
                                          .fetchProducts(overwrite: true),
                                    )
                                  : NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification scrollInfo) {
                                        if (!productDetailsController
                                                .isFetchingMore &&
                                            scrollInfo.metrics.pixels ==
                                                scrollInfo
                                                    .metrics.maxScrollExtent) {
                                          // Trigger loading more products
                                          //fetchMoreProducts();
                                          return true;
                                        }
                                        return false;
                                      },
                                      child: ListView.builder(
                                        controller: productDetailsController
                                            .scrollController, // Attach the scroll controller
                                        scrollDirection:
                                            Axis.vertical, // Vertical scrolling
                                        itemCount: productDetailsController
                                                .getActiveProducts()
                                                .isNotEmpty
                                            ? productDetailsController
                                                    .getActiveProducts()
                                                    .length +
                                                1
                                            : 0, // Avoids index errors when the list is empty

                                        itemBuilder: (context, index) {
                                          final activeProducts =
                                              productDetailsController
                                                  .getActiveProducts();
                                          if (index >= activeProducts.length) {
                                            // Show loader at the end
                                            return Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: productDetailsController
                                                      .isFetchingMore
                                                  ? CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    )
                                                  : const SizedBox.shrink(),
                                            );
                                          }

                                          if (index >= activeProducts.length) {
                                            return const SizedBox(); // Prevents accessing invalid indexes
                                          }

                                          final product = activeProducts[index];

                                          List<String> imgList = [];
                                          if (product['img'] != null) {
                                            if (product['img']
                                                is List<String>) {
                                              imgList = List<String>.from(
                                                  product['img']);
                                            } else if (product['img']
                                                is String) {
                                              imgList = [product['img']];
                                            }
                                          }
                                          List<String> fullImgList =
                                              imgList.map((img) {
                                            return '$img/download?project=677181a60009f5d039dd';
                                          }).toList();

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                    20.0), // Add spacing between items
                                            child: Container(
                                              width: double
                                                  .infinity, // Full screen width
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .cardColor, // Optional: background color
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(
                                                  10.0), // Content padding
                                              child: Product(
                                                itemId: product['id'],
                                                name: product['name']!,
                                                img: fullImgList,
                                                details: product['details']!,
                                                amount: product['amount']!,
                                                slashedPrice:
                                                    product['slashedPrice']!,
                                                discount: product['discount']!,
                                                starImg: product['starImg']!,
                                                rating: product['rating']!,
                                                rating2: product['rating2']!,
                                                liked: product['isInFavorite'],
                                                onToggleDarkMode:
                                                    widget.onToggleDarkMode,
                                                isDarkMode: widget.isDarkMode,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ),
                      )
                    ] else ...[
                      // Display all products
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: productDetailsController.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                )
                              : productDetailsController.products.isEmpty
                                  ? CustomErrorMessage(
                                      text:
                                          'No products available at the moment.',
                                      onPressed: () => productDetailsController
                                          .fetchProducts(overwrite: true),
                                    )
                                  : NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification scrollInfo) {
                                        if (!productDetailsController
                                                .isFetchingMore &&
                                            scrollInfo.metrics.pixels ==
                                                scrollInfo
                                                    .metrics.maxScrollExtent) {
                                          // Trigger loading more products
                                          //fetchMoreProducts();
                                          return true;
                                        }
                                        return false;
                                      },
                                      child: ListView.builder(
                                        controller: productDetailsController
                                            .scrollController, // Attach the scroll controller
                                        scrollDirection:
                                            Axis.vertical, // Vertical scrolling
                                        itemCount: productDetailsController
                                                .getActiveProducts()
                                                .isNotEmpty
                                            ? productDetailsController
                                                    .getActiveProducts()
                                                    .length +
                                                1
                                            : 0, // Avoids index errors when the list is empty

                                        itemBuilder: (context, index) {
                                          final activeProducts =
                                              productDetailsController
                                                  .getActiveProducts();
                                          if (index >= activeProducts.length) {
                                            // Show loader at the end
                                            return Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: productDetailsController
                                                      .isFetchingMore
                                                  ? CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    )
                                                  : const SizedBox.shrink(),
                                            );
                                          }

                                          if (index >= activeProducts.length) {
                                            return const SizedBox(); // Prevents accessing invalid indexes
                                          }

                                          final product = activeProducts[index];

                                          List<String> imgList = [];
                                          if (product['img'] != null) {
                                            if (product['img']
                                                is List<String>) {
                                              imgList = List<String>.from(
                                                  product['img']);
                                            } else if (product['img']
                                                is String) {
                                              imgList = [product['img']];
                                            }
                                          }
                                          List<String> fullImgList =
                                              imgList.map((img) {
                                            return '$img/download?project=677181a60009f5d039dd';
                                          }).toList();

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                    20.0), // Add spacing between items
                                            child: Container(
                                              width: double
                                                  .infinity, // Full screen width
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .cardColor, // Optional: background color
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(
                                                  10.0), // Content padding
                                              child: Product(
                                                itemId: product['id'],
                                                name: product['name']!,
                                                img: fullImgList,
                                                details: product['details']!,
                                                amount: product['amount']!,
                                                slashedPrice:
                                                    product['slashedPrice']!,
                                                discount: product['discount']!,
                                                starImg: product['starImg']!,
                                                rating: product['rating']!,
                                                rating2: product['rating2']!,
                                                liked: product['isInFavorite'],
                                                onToggleDarkMode:
                                                    widget.onToggleDarkMode,
                                                isDarkMode: widget.isDarkMode,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        filterBy(context);
                      },
                      child: const FilterWidget(
                          img: 'images/Filter.png', text: 'Filter'),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        sortBy(context);
                      },
                      child: const FilterWidget(
                          img: 'images/sort.png', text: 'Sort By'),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
