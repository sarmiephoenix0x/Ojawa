import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_error_message.dart';
import '../../../core/widgets/product.dart';
import '../../controllers/categories_details_controller.dart';
import '../top_categories_details/top_categories_details.dart';

class CategoriesDetails extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  const CategoriesDetails(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  _CategoriesDetailsState createState() => _CategoriesDetailsState();
}

class _CategoriesDetailsState extends State<CategoriesDetails> {
  @override
  Widget build(BuildContext context) {
    final categoriesDetailsController =
        Provider.of<CategoriesDetailsController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Men's",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                categoriesDetailsController.refreshData(context);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            categoriesDetailsController.setCurrent(index);
                          });
                        },
                      ),
                      carouselController:
                          categoriesDetailsController.controller,
                      items: categoriesDetailsController.imagePaths.map((item) {
                        return Image.asset(
                          item,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        categoriesDetailsController.imagePaths.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(
                            categoriesDetailsController.current == index
                                ? "images/Elipses_active.png"
                                : "images/Elipses.png",
                            width: (10 / MediaQuery.of(context).size.width) *
                                MediaQuery.of(context).size.width,
                            height: (10 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        Text(
                          'Top Categories',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SizedBox(
                      height: (350 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      child: categoriesDetailsController.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          : categoriesDetailsController.categories.isEmpty
                              ? CustomErrorMessage(
                                  text:
                                      'No categories available at the moment.',
                                  onPressed: () => categoriesDetailsController
                                      .fetchCategories(),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: categoriesDetailsController
                                      .categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categoriesDetailsController
                                        .categories[index];
                                    List<String> imgList = [];
                                    if (category['categoryImageUrl'] != null) {
                                      if (category['categoryImageUrl']
                                          is List<String>) {
                                        imgList = List<String>.from(
                                            category['categoryImageUrl']);
                                      } else if (category['categoryImageUrl']
                                          is String) {
                                        imgList = [
                                          category['categoryImageUrl']
                                        ];
                                      }
                                    }
                                    List<String> fullImgList =
                                        imgList.map((img) {
                                      return '$img/download?project=677181a60009f5d039dd';
                                    }).toList();

                                    // Ensure the image URL is not empty
                                    final imageUrl = fullImgList.isNotEmpty
                                        ? fullImgList[0]
                                        : null;

                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TopCategoriesDetails(
                                                  key: UniqueKey(),
                                                  id: category['id'],
                                                  discountOnly: false,
                                                  onToggleDarkMode:
                                                      widget.onToggleDarkMode,
                                                  isDarkMode: widget.isDarkMode,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            elevation: 4,
                                            child: Container(
                                              height: 108,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: imageUrl != null
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                            imageUrl), // Use the first image URL
                                                        fit: BoxFit.cover,
                                                      )
                                                    : null, // Handle cases where no image is available
                                                color: imageUrl == null
                                                    ? Colors.grey.shade300
                                                    : null, // Placeholder color if no image
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            category['name'],
                                            style:
                                                const TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Recommended for you',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TopCategoriesDetails(
                                  key: UniqueKey(),
                                  discountOnly: false,
                                  onToggleDarkMode: widget.onToggleDarkMode,
                                  isDarkMode: widget.isDarkMode,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: categoriesDetailsController.isLoading2
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          : categoriesDetailsController.products.isEmpty
                              ? CustomErrorMessage(
                                  text: 'No products available at the moment.',
                                  onPressed: () => categoriesDetailsController
                                      .fetchProducts(),
                                )
                              : NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    if (!categoriesDetailsController
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
                                    controller: categoriesDetailsController
                                        .scrollController, // Attach the scroll controller
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoriesDetailsController
                                        .products
                                        .length, // Set to products.length
                                    itemBuilder: (context, index) {
                                      final product =
                                          categoriesDetailsController.products[
                                              index]; // Access product safely
                                      List<String> imgList = [];
                                      if (product['img'] != null) {
                                        if (product['img'] is List<String>) {
                                          imgList =
                                              List<String>.from(product['img']);
                                        } else if (product['img'] is String) {
                                          imgList = [product['img']];
                                        }
                                      }
                                      List<String> fullImgList =
                                          imgList.map((img) {
                                        return '$img/download?project=677181a60009f5d039dd';
                                      }).toList();

                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
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
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
