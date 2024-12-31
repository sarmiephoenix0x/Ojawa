import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ojawa/my_cart.dart';
import 'package:ojawa/productDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TopCategoriesDetails extends StatefulWidget {
  final int? id;
  final bool discountOnly;
  const TopCategoriesDetails({super.key, required this.discountOnly, this.id});

  @override
  _TopCategoriesDetailsState createState() => _TopCategoriesDetailsState();
}

class _TopCategoriesDetailsState extends State<TopCategoriesDetails> {
  Map<String, bool> _isLikedMap = {};
  List<Map<String, dynamic>> products = [];
  final storage = const FlutterSecureStorage();
  bool _isLoading = true;
  List<Map<String, dynamic>> filteredProducts = [];
  bool _isSearching = false; // To track if the search is active
  String _searchQuery = ''; // To store the current search query
  List<Map<String, dynamic>> searchResults = []; // To store the search results
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchProducts();
      }
    });
    fetchProducts();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _isSearching = false; // Reset search state
      searchResults.clear(); // Clear search results
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty; // Set searching state based on query

      if (_isSearching) {
        // Check if products are filtered
        List<Map<String, dynamic>> sourceList =
            widget.discountOnly ? filteredProducts : products;

        searchResults = sourceList.where((product) {
          // Check for null to avoid NoSuchMethodError
          final productName = product['name'];
          return productName != null &&
              productName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        searchResults.clear(); // Clear search results if query is empty
      }
    });
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        // Add your filtering logic here
        return product['hasDiscount'] == true;
      }).toList();
    });
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
              'categoryId': product['category'] != null
                  ? product['category']['id']
                  : null,
            };
          }).toList();
          _isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        print('Error fetching products: ${response.statusCode}');
        if (mounted) {
          setState(() {
            _isLoading = false; // Set loading to false on error
          });
        }
      }
    } catch (error) {
      print('Error: $error');
      if (mounted) {
        setState(() {
          _isLoading = false; // Set loading to false on error
        });
      }
    }
  }

  void _sortBy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
              title: Text(
            'Sort By',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
          ListTile(
            title: const Text('Most Helpful'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Most Useful'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Highest Rating'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Lowest Rating'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _filterBy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
                title: Text(
              'Filter By',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )),
            ListTile(
              title: const Text('All Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('5 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('4 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('3 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('2 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('1 Star'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.discountOnly == true) {
      _filterProducts();
    }
    List<Map<String, dynamic>> displayedProducts = widget.id != null
        ? products
            .where((product) => product['categoryId'] == widget.id)
            .toList()
        : products;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: searchController,
                  focusNode: _searchFocusNode,
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
                      icon: const Icon(Icons.search, color: Color(0xFF008000)),
                      onPressed: () {
                        // if (searchController.text.isNotEmpty) {
                        //   _searchProducts(searchController.text.trim());
                        // }
                      },
                    ),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: Icon(Icons.close,
                                color: Theme.of(context).colorScheme.onSurface),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                searchController.clear();
                                searchResults.clear(); // Clear search results
                              });
                            },
                          )
                        : null,
                  ),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  onChanged: (value) {
                    _searchProducts(value);
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                        _isSearching = true;
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCart(key: UniqueKey()),
                        ),
                      );
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
                  child: _isLoading // Check if loading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        )) // Show loader while loading
                      : Text(
                          "${_isSearching ? searchResults.length : (widget.discountOnly ? filteredProducts.length : displayedProducts.length)} Items", // Show item count based on search or filter
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                if (_isSearching) ...[
                  if (searchResults.isNotEmpty) ...[
                    // Show search results
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.67,
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final product = searchResults[index];
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
                                  bottom: 20.0), // Space between items
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
                ] else if (widget.discountOnly == true) ...[
                  // Display filtered products
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.67,
                      child: ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
                                bottom: 20.0), // Space between items
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
                  )
                ] else ...[
                  // Display all products
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.67,
                      child: _isLoading // Check if loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ) // Show loader while loading
                          : ListView.builder(
                              itemCount: displayedProducts.length,
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
                                      bottom: 20.0), // Space between items
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
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                    _filterBy();
                  },
                  child: filter('images/Filter.png', 'Filter'),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    _sortBy();
                  },
                  child: filter('images/sort.png', 'Sort By'),
                ),
                const Spacer(),
              ],
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
                    top: 5,
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
                          fontSize: 16.0,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Text(
                  slashedPrice,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 2,
                    decorationColor: Colors.grey,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Text(
                  discount,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Image.asset(
                  starImg,
                  height: 25,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  rating,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  rating2,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
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

  Widget filter(String img, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          img,
          height: 22,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
