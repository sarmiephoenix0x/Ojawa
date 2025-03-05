import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:provider/provider.dart';

import '../../../core/widgets/image_list.dart';
import '../../../core/widgets/product.dart';
import '../../../core/widgets/product_category.dart';
import '../../../core/widgets/size.dart';
import '../../controllers/product_details_controller.dart';
import '../top_categories_details/top_categories_details.dart';
import 'widgets/bottom_sheets/details_sheet.dart';
import 'widgets/bottom_sheets/reviews_sheet.dart';

class Productdetails extends StatefulWidget {
  final int itemId;
  final List<String> img;
  final String name;
  final String details;
  final String amount;
  final String slashedPrice;
  final String rating;
  final String rating2;
  final String discount;
  final String starImg;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const Productdetails(
      {super.key,
      required this.itemId,
      required this.name,
      required this.details,
      required this.amount,
      required this.slashedPrice,
      required this.rating,
      required this.rating2,
      required this.img,
      required this.discount,
      required this.starImg,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails>
    with TickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    // final productDetailsController =
    //     Provider.of<ProductDetailsController>(context);
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (context) => ProductDetailsController(itemId: widget.itemId),
      child: Consumer<ProductDetailsController>(
        builder: (context, productDetailsController, child) {
          return Scaffold(
            body: SafeArea(
              child: productDetailsController.productDetails == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ) // Show a loader while fetching
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 10.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                        productDetailsController.isLiked == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            productDetailsController.isLiked ==
                                                    true
                                                ? Colors.red
                                                : originalIconColor),
                                    onPressed: () async {
                                      final previousState =
                                          productDetailsController.isLiked;

                                      productDetailsController.setIsLiked(
                                          !productDetailsController.isLiked);

                                      try {
                                        await productDetailsController
                                            .updateFavoriteStatus(
                                                context,
                                                productDetailsController
                                                    .productDetails!['id'],
                                                productDetailsController
                                                    .isLiked,
                                                widget.onToggleDarkMode,
                                                widget.isDarkMode);
                                      } catch (error) {
                                        productDetailsController.setIsLiked(
                                            previousState); // Revert if the request fails

                                        print(
                                            'Error updating favorite status: $error');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    onPressed: null,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05),
                                  InkWell(
                                    onTap: () {
                                      productDetailsController.loadCart(
                                          context,
                                          widget.onToggleDarkMode,
                                          widget.isDarkMode);
                                    },
                                    child: Image.asset(
                                      'images/bag.png',
                                      height: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  productDetailsController.refreshData(context);
                                },
                                color: Theme.of(context).colorScheme.onSurface,
                                child: ListView(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    CarouselSlider(
                                      options: CarouselOptions(
                                        enlargeCenterPage: false,
                                        viewportFraction: 1.0,
                                        aspectRatio: 10 / 10,
                                        enableInfiniteScroll: false,
                                        initialPage: 0,
                                        onPageChanged: (index, reason) {
                                          productDetailsController
                                              .setCurrent(index);
                                        },
                                      ),
                                      carouselController:
                                          productDetailsController.controller,
                                      items: productDetailsController
                                              .fullImgList.isNotEmpty
                                          ? productDetailsController.fullImgList
                                              .map((item) {
                                              return Image.network(
                                                item,
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                    child: const Center(
                                                      child: Text(
                                                        'Image not available',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList()
                                          : [
                                              Container(
                                                color: Colors.grey,
                                                child: const Center(
                                                  child: Text(
                                                    'No images available',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        widget.img.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Image.asset(
                                            productDetailsController.current ==
                                                    index
                                                ? "images/Elipses_active.png"
                                                : "images/Elipses.png",
                                            width: (10 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            height: (10 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        productDetailsController
                                            .productDetails!['name'],
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        productDetailsController
                                            .productDetails!['description'],
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/Rating Icon.png',
                                            height: 25,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Text(
                                            productDetailsController
                                                .productDetails!['rating'],
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Text(
                                            "(${productDetailsController.totalPeopleRated})",
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            productDetailsController
                                                .productDetails!['price'],
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
                                          Text(
                                            productDetailsController
                                                    .productDetails![
                                                'slashedPrice'],
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness: 2,
                                              decorationColor: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                          Text(
                                            productDetailsController
                                                    .productDetails![
                                                'discountRate'],
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              color: Color(0xFFEA580C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Color:',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 18.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01),
                                              const Text(
                                                'White',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            'Only ${productDetailsController.productDetails!['quantity']} Left',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ImageList(
                                              img: productDetailsController
                                                  .fullImgList[0]),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Size',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          Stack(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        4.0), // Adjusts the space between text and underline
                                                child: Text(
                                                  'Size Chart',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width, // Match the text width or set a custom width
                                                  height:
                                                      2, // Thickness of the underline
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizeWidget(
                                            text: 'S',
                                            value: 1,
                                            controllerMethod:
                                                productDetailsController
                                                    .setSelectedRadioValue,
                                            controllerVariable:
                                                productDetailsController
                                                    .selectedRadioValue!,
                                          ),
                                          SizeWidget(
                                            text: 'M',
                                            value: 2,
                                            controllerMethod:
                                                productDetailsController
                                                    .setSelectedRadioValue,
                                            controllerVariable:
                                                productDetailsController
                                                    .selectedRadioValue!,
                                          ),
                                          SizeWidget(
                                            text: 'L',
                                            value: 3,
                                            controllerMethod:
                                                productDetailsController
                                                    .setSelectedRadioValue,
                                            controllerVariable:
                                                productDetailsController
                                                    .selectedRadioValue!,
                                          ),
                                          SizeWidget(
                                            text: 'XL',
                                            value: 4,
                                            controllerMethod:
                                                productDetailsController
                                                    .setSelectedRadioValue,
                                            controllerVariable:
                                                productDetailsController
                                                    .selectedRadioValue!,
                                          ),
                                          SizeWidget(
                                            text: 'XXL',
                                            value: 5,
                                            controllerMethod:
                                                productDetailsController
                                                    .setSelectedRadioValue,
                                            controllerVariable:
                                                productDetailsController
                                                    .selectedRadioValue!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.grey[900]
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              12), // Smoother corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.2), // Softer shadow for a clean look
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0,
                                                  2), // Position shadow for depth
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Delivery Options",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 20.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            TextFormField(
                                              controller:
                                                  productDetailsController
                                                      .pinController,
                                              focusNode:
                                                  productDetailsController
                                                      .pinFocusNode,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                              decoration: InputDecoration(
                                                labelText: 'Enter PIN Code',
                                                labelStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16.0,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      width: 3,
                                                      color: Color(0xFF1D4ED8)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      width: 2,
                                                      color: Colors.grey),
                                                ),
                                                suffix: const Text(
                                                  'CHECK',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Color(0xFF1D4ED8),
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              cursorColor:
                                                  const Color(0xFF1D4ED8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 16.0),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.grey[900]
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              12), // Smoother corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.2), // Softer shadow for a clean look
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0,
                                                  2), // Position shadow for depth
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              child: Text(
                                                "Product Details",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04),
                                            const ProductCategory(
                                                title: "Fabric",
                                                name: "Cotton"),
                                            const ProductCategory(
                                                title: "Length",
                                                name: "Regular"),
                                            const ProductCategory(
                                                title: "Neck",
                                                name: "Round Neck"),
                                            const ProductCategory(
                                                title: "Pattern",
                                                name: "Graphic Print"),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const Divider(
                                                color: Colors.grey,
                                                height: 20,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showDetailsSheet(context);
                                                },
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      'View More',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18.0,
                                                        color:
                                                            Color(0xFF1D4ED8),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.navigate_next,
                                                        color:
                                                            Color(0xFF1D4ED8),
                                                        size: 30,
                                                      ),
                                                      onPressed: null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 16.0),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.grey[900]
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              12), // Smoother corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.2), // Softer shadow for a clean look
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0,
                                                  2), // Position shadow for depth
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              child: Text(
                                                "Ratings & Reviews",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const Divider(
                                                color: Colors.grey,
                                                height: 20,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    productDetailsController
                                                        .overallRating,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 28.0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                  const Text(
                                                    '/5',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Overall Rating',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18.0,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${productDetailsController.totalPeopleRated} Ratings',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 18.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: (50 /
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height) *
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          productDetailsController
                                                              .loadWriteReviewPage(
                                                                  context,
                                                                  widget
                                                                      .onToggleDarkMode,
                                                                  widget
                                                                      .isDarkMode);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStateProperty
                                                                  .resolveWith<
                                                                      Color>(
                                                            (Set<WidgetState>
                                                                states) {
                                                              if (states.contains(
                                                                  WidgetState
                                                                      .pressed)) {
                                                                return const Color(
                                                                    0xFF1D4ED8);
                                                              }
                                                              return Colors
                                                                  .white;
                                                            },
                                                          ),
                                                          foregroundColor:
                                                              WidgetStateProperty
                                                                  .resolveWith<
                                                                      Color>(
                                                            (Set<WidgetState>
                                                                states) {
                                                              if (states.contains(
                                                                  WidgetState
                                                                      .pressed)) {
                                                                return Colors
                                                                    .white;
                                                              }
                                                              return const Color(
                                                                  0xFF1D4ED8);
                                                            },
                                                          ),
                                                          elevation:
                                                              WidgetStateProperty
                                                                  .all<double>(
                                                                      4.0),
                                                          shape: WidgetStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            const RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 3,
                                                                  color: Color(
                                                                      0xFF1D4ED8)),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Rate',
                                                          softWrap: false,
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const Divider(
                                                color: Colors.grey,
                                                height: 20,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            if (productDetailsController
                                                    .firstReview !=
                                                null) ...[
                                              // Display rating stars
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Row(
                                                  children: List.generate(
                                                    productDetailsController
                                                            .firstReview![
                                                        'rating'], // Number of stars to display
                                                    (index) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Image.asset(
                                                        'images/star.png',
                                                        height: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 12.0),
                                                child: Text(
                                                  productDetailsController
                                                              .firstReview![
                                                          'headline'] ??
                                                      'No headline',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 12.0),
                                                child: Text(
                                                  productDetailsController
                                                              .firstReview![
                                                          'body'] ??
                                                      'No review provided.',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                      child: ImageList(
                                                          img: productDetailsController
                                                                  .firstReview![
                                                              'userProfilePictureUrl']),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 12.0),
                                                child: Text(
                                                  "${productDetailsController.firstReview!['username'] ?? 'Anonymous'}, ${productDetailsController.firstReview!['dateCreated'] ?? 'N/A'}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 15.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                            ],
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const Divider(
                                                color: Colors.grey,
                                                height: 20,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showReviewsSheet(
                                                      context,
                                                      productDetailsController
                                                          .simplifiedReviews);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'View All ${productDetailsController.simplifiedReviews.length} Reviews',
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18.0,
                                                        color:
                                                            Color(0xFF1D4ED8),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    const IconButton(
                                                      icon: Icon(
                                                        Icons.navigate_next,
                                                        color:
                                                            Color(0xFF1D4ED8),
                                                        size: 30,
                                                      ),
                                                      onPressed: null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'You may like',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopCategoriesDetails(
                                                    key: UniqueKey(),
                                                    discountOnly: true,
                                                    onToggleDarkMode:
                                                        widget.onToggleDarkMode,
                                                    isDarkMode:
                                                        widget.isDarkMode,
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
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.62,
                                        child: productDetailsController
                                                .isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              )
                                            : NotificationListener<
                                                ScrollNotification>(
                                                onNotification:
                                                    (ScrollNotification
                                                        scrollInfo) {
                                                  if (!productDetailsController
                                                          .isFetchingMore &&
                                                      scrollInfo
                                                              .metrics.pixels ==
                                                          scrollInfo.metrics
                                                              .maxScrollExtent) {
                                                    // Trigger loading more products
                                                    //fetchMoreProducts();
                                                    return true;
                                                  }
                                                  return false;
                                                },
                                                child: ListView.builder(
                                                  controller:
                                                      productDetailsController
                                                          .scrollController, // Attach the scroll controller
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      productDetailsController
                                                          .products
                                                          .length, // Set to products.length, no extra item for loader
                                                  itemBuilder:
                                                      (context, index) {
                                                    final product =
                                                        productDetailsController
                                                            .products[index];
                                                    List<String> imgList = [];
                                                    if (product['img'] !=
                                                        null) {
                                                      if (product['img']
                                                          is List<String>) {
                                                        imgList =
                                                            List<String>.from(
                                                                product['img']);
                                                      } else if (product['img']
                                                          is String) {
                                                        imgList = [
                                                          product['img']
                                                        ];
                                                      }
                                                    }
                                                    List<String> fullImgList =
                                                        imgList.map((img) {
                                                      return '$img/download?project=677181a60009f5d039dd';
                                                    }).toList();
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20.0),
                                                      child: Product(
                                                        itemId: product['id'],
                                                        name: product['name']!,
                                                        img: fullImgList,
                                                        details:
                                                            product['details']!,
                                                        amount:
                                                            product['amount']!,
                                                        slashedPrice: product[
                                                            'slashedPrice']!,
                                                        discount: product[
                                                            'discount']!,
                                                        starImg:
                                                            product['starImg']!,
                                                        rating:
                                                            product['rating']!,
                                                        rating2:
                                                            product['rating2']!,
                                                        liked: product[
                                                            'isInFavorite'],
                                                        onToggleDarkMode: widget
                                                            .onToggleDarkMode,
                                                        isDarkMode:
                                                            widget.isDarkMode,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 5,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: (55 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await productDetailsController.addToCart(
                                          context,
                                          widget.itemId,
                                          1,
                                          widget.onToggleDarkMode,
                                          widget.isDarkMode);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF1D4ED8);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.white;
                                          }
                                          return const Color(0xFF1D4ED8);
                                        },
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(4.0),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 3,
                                              color: Color(0xFF1D4ED8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                    ),
                                    child: productDetailsController.isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF1D4ED8),
                                            ),
                                          )
                                        : const Text(
                                            'Add to cart',
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
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: (55 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.white;
                                          }
                                          return const Color(0xFF1D4ED8);
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF1D4ED8);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(4.0),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 3,
                                              color: Color(0xFF1D4ED8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Buy Now',
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
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
