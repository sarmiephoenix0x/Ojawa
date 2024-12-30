import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:ojawa/productDetails.dart';
import 'package:ojawa/top_categories_details.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CategoriesDetails extends StatefulWidget {
  const CategoriesDetails({super.key});

  @override
  _CategoriesDetailsState createState() => _CategoriesDetailsState();
}

class _CategoriesDetailsState extends State<CategoriesDetails> {
  List<String> imagePaths = [
    "images/Banner.png",
    "images/Banner.png",
    "images/Banner.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  Map<String, bool> _isLikedMap = {};
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url =
        'https://ojawa-api.onrender.com/api/Products/categories'; // Update with your categories endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          categories = responseData.map((category) {
            return {
              'id': category['id'],
              'name': category['name'],
              'description': category['description'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String _getImageUrl(int index) {
    switch (index) {
      case 0:
        return 'images/Img4.png';
      case 1:
        return 'images/Img5.png';
      case 2:
        return 'images/Img6.png';
      case 3:
        return 'images/Img4.png';
      case 4:
        return 'images/Img5.png';
      case 5:
        return 'images/Img6.png';
      default:
        return '';
    }
  }

  String _getImageLabel(int index) {
    switch (index) {
      case 0:
        return 'Formal Wear';
      case 1:
        return 'Ethnic Wear';
      case 2:
        return 'Sports Wear';
      case 3:
        return 'Casual Wear';
      case 4:
        return 'Footwear';
      case 5:
        return 'Accessories';
      default:
        return '';
    }
  }

  Future<void> fetchProducts() async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          products = responseData.map((product) {
            // Calculate discount strings
            String discount = product['hasDiscount'] == true
                ? '${product['discountRate']}% OFF'
                : '';

            String uptoDiscount = product['hasDiscount'] == true
                ? 'Upto ${product['discountRate']}% OFF'
                : '';

            return {
              'name': product['name'],
              'img': product['productImageUrl'],
              'details': product['description'],
              'amount': '\$${product['price']}',
              'slashedPrice': product['hasDiscount'] == true
                  ? '\$${product['discountPrice']}'
                  : '',
              'discount': discount,
              'uptoDiscount': uptoDiscount, // New field for "Upto X% OFF"
              'starImg':
                  'images/Rating Icon.png', // Assuming a static image for rating
              'rating': product['rating'].toString(),
              'rating2': '(0)', // Placeholder for review count
              'hasDiscount': product['hasDiscount'], // Include hasDiscount
            };
          }).toList();
        });
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          _current = index;
                        });
                      },
                    ),
                    carouselController: _controller,
                    items: imagePaths.map((item) {
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
                      imagePaths.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(
                          _current == index
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
                    child: _isLoading // Check if loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ) // Show loader while loading
                        : GridView.builder(
                            padding: const EdgeInsets.only(top: 20.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Number of columns in the grid
                              childAspectRatio: 1, // Aspect ratio of each item
                              crossAxisSpacing: 8.0, // Space between columns
                              mainAxisSpacing: 8.0, // Space between rows
                            ),
                            itemCount: categories
                                .length, // Use the length of categories
                            itemBuilder: (context, index) {
                              final category =
                                  categories[index]; // Get the category
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
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15), // Rounded edges for the card
                                      ),
                                      elevation: 4, // Shadow effect
                                      child: Container(
                                        height:
                                            108, // Set the height of the image
                                        width: double
                                            .infinity, // Make the image take the full width
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15), // Ensure the image respects the card's shape
                                          image: DecorationImage(
                                            image: AssetImage(_getImageUrl(index %
                                                5)), // Use modulo to cycle through your images
                                            fit: BoxFit
                                                .cover, // Fit the image within the container
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 4), // Space between card and text
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // Padding around the text
                                    child: Text(
                                      category[
                                          'name'], // Display the category name
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                    child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        List<String> imgList = [];

                        // Check if product['img'] is not null
                        if (product['img'] != null) {
                          if (product['img'] is List<String>) {
                            // If it's already a List<String>, use it directly
                            imgList = List<String>.from(product['img']);
                          } else if (product['img'] is String) {
                            // If it's a String, convert it to a List<String>
                            imgList = [
                              product['img']
                            ]; // Create a list with the single image
                          }
                        }

                        // Append the download string to each image URL in imgList
                        List<String> fullImgList = imgList.map((img) {
                          return '$img/download?project=677181a60009f5d039dd';
                        }).toList();
                        return Container(
                          width: MediaQuery.of(context).size.width *
                              0.6, // Set a fixed width for each item
                          margin: const EdgeInsets.only(
                              right: 20.0), // Space between items
                          child: hot(
                            product['name']!,
                            fullImgList,
                            product['details']!,
                            product['amount']!,
                            product['slashedPrice']!,
                            product['discount']!,
                            product['starImg']!,
                            product['rating']!,
                            product['rating2']!,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hot(
      String name,
      List<String> img,
      String details,
      String amount,
      String slashedPrice,
      String discount,
      String starImg,
      String rating,
      String rating2) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    bool isLiked = _isLikedMap[img[0]] ?? false;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetails(
              key: UniqueKey(),
              name: name,
              details: details,
              amount: amount,
              slashedPrice: slashedPrice,
              rating: rating,
              rating2: rating2,
              img: img,
              discount: discount,
              starImg: starImg,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: [
                  Image.network(
                    img[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                      ); // Fallback if image fails
                    },
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 5,
                    right: MediaQuery.of(context).padding.right + 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 0.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(55.0),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                            isLiked == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked == true
                                ? Colors.red
                                : originalIconColor),
                        onPressed: () {
                          setState(() {
                            _isLikedMap[img[0]] = !isLiked;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: MediaQuery.of(context).padding.left + 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA580C),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: const Text(
                        "Top Seller",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              details,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Text(
                  slashedPrice,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 2,
                    decorationColor: Colors.grey,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Text(
                  discount,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              children: [
                Image.asset(
                  starImg,
                  height: 23,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  rating,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  rating2,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
