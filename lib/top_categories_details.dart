import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ojawa/my_cart.dart';
import 'package:ojawa/productDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ojawa/sign_in_page.dart';

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
  Map<String, bool> _isLikedMap = {};
  List<Map<String, dynamic>> products = [];
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  List<Map<String, dynamic>> filteredProducts = [];
  bool _isSearching = false; // To track if the search is active
  String _searchQuery = ''; // To store the current search query
  List<Map<String, dynamic>> searchResults = []; // To store the search results
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int pageNum = 1;
  bool _isFetchingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        if (products.isEmpty) {
          fetchProducts(overwrite: true);
        }
      }
    });
    fetchProducts(overwrite: true);
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        !_isFetchingMore) {
      fetchMoreProducts(); // Trigger fetching more products
    }
  }

  Future<void> fetchProducts({bool overwrite = false}) async {
    if (_isLoading) return; // Prevent multiple fetches

    setState(() {
      _isLoading = true;
    });

    if (overwrite) {
      // Clear existing products and reset pagination
      products.clear();
      pageNum = 1;
      hasMore = true; // Reset `hasMore` for a fresh fetch
    }

    try {
      if (widget.id != null) {
        await _fetchProductsForPageBasedOnCategory(pageNum);
      } else {
        await _fetchProductsForPage(pageNum);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> fetchMoreProducts() async {
    if (!hasMore || _isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    pageNum++; // Increment the page number for the next fetch

    try {
      if (widget.id != null) {
        await _fetchProductsForPageBasedOnCategory(pageNum);
      } else {
        await _fetchProductsForPage(pageNum);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  Future<void> _fetchProductsForPage(int page) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products?page=$page';

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
          if (responseData.isEmpty) {
            hasMore = false; // No more pages to fetch
          } else {
            // Filter out duplicate products
            final newProducts = responseData.where((product) {
              return !products.any(
                  (existingProduct) => existingProduct['id'] == product['id']);
            }).map((product) {
              String discount = product['hasDiscount'] == true
                  ? '${product['discountRate']}% OFF'
                  : '';
              String uptoDiscount = product['hasDiscount'] == true
                  ? 'Upto ${product['discountRate']}% OFF'
                  : '';
              return {
                'id': product['id'],
                'name': product['name'],
                'img': product['productImageUrl'],
                'details': product['description'],
                'amount': '\$${product['price']}',
                'slashedPrice': product['hasDiscount'] == true
                    ? '\$${product['discountPrice']}'
                    : '',
                'isInFavorite': product['isInFavorite'] ?? false,
                'discount': discount,
                'uptoDiscount': uptoDiscount,
                'starImg': 'images/Rating Icon.png',
                'rating': product['rating'].toString(),
                'rating2': '(0)',
                'hasDiscount': product['hasDiscount'],
              };
            }).toList();

            if (newProducts.isNotEmpty) {
              products.addAll(newProducts);
            } else {
              hasMore = false; // No new products means end of list
            }
          }
        });
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchProductsForPageBasedOnCategory(int page) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url =
        'https://ojawa-api.onrender.com/api/Products/category/${widget.id}?page=$page';

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
          if (responseData.isEmpty) {
            hasMore = false;
          } else {
            final newProducts = responseData.where((product) {
              return !products.any(
                  (existingProduct) => existingProduct['id'] == product['id']);
            }).map((product) {
              String discount = product['hasDiscount'] == true
                  ? '${product['discountRate']}% OFF'
                  : '';
              String uptoDiscount = product['hasDiscount'] == true
                  ? 'Upto ${product['discountRate']}% OFF'
                  : '';
              return {
                'id': product['id'],
                'name': product['name'],
                'img': product['productImageUrl'],
                'details': product['description'],
                'amount': '\$${product['price']}',
                'slashedPrice': product['hasDiscount'] == true
                    ? '\$${product['discountPrice']}'
                    : '',
                'isInFavorite': product['isInFavorite'] ?? false,
                'discount': discount,
                'uptoDiscount': uptoDiscount,
                'starImg': 'images/Rating Icon.png',
                'rating': product['rating'].toString(),
                'rating2': '(0)',
                'hasDiscount': product['hasDiscount'],
              };
            }).toList();

            if (newProducts.isNotEmpty) {
              products.addAll(newProducts);
            } else {
              hasMore = false;
            }
          }
        });
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateFavoriteStatus(int productId, bool isFavorite) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Favorites/$productId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode == 200) {
        print('Favorite status updated successfully.');
      } else {
        print(
            'Failed to update favorite status: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    onPressed: () async {
                      final String? accessToken =
                          await storage.read(key: 'accessToken');
                      if (accessToken == null) {
                        _showCustomSnackBar(
                          context,
                          'You are not logged in.',
                          isError: true,
                        );
                        // await prefs.remove('user');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(
                                key: UniqueKey(),
                                onToggleDarkMode: widget.onToggleDarkMode,
                                isDarkMode: widget.isDarkMode),
                          ),
                        );

                        return;
                      }
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
                          "${_isSearching ? searchResults.length : (widget.discountOnly ? filteredProducts.length : products.length)} Items", // Show item count based on search or filter
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
                        height: MediaQuery.of(context).size.height * 0.62,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!_isFetchingMore &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    // Trigger loading more products
                                    //fetchMoreProducts();
                                    return true;
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  controller:
                                      _scrollController, // Attach the scroll controller
                                  scrollDirection:
                                      Axis.vertical, // Vertical scrolling
                                  itemCount: products.length +
                                      1, // Add one for the loader
                                  itemBuilder: (context, index) {
                                    if (index == products.length) {
                                      // Show loader at the end
                                      return Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        child: _isFetchingMore
                                            ? CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              )
                                            : const SizedBox.shrink(),
                                      );
                                    }

                                    final product = products[index];
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
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(
                                            10.0), // Content padding
                                        child: hot(
                                            product['id'],
                                            product['name']!,
                                            fullImgList,
                                            product['details']!,
                                            product['amount']!,
                                            product['slashedPrice']!,
                                            product['discount']!,
                                            product['starImg']!,
                                            product['rating']!,
                                            product['rating2']!,
                                            product['isInFavorite']),
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
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!_isFetchingMore &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  // Trigger loading more products
                                  //fetchMoreProducts();
                                  return true;
                                }
                                return false;
                              },
                              child: ListView.builder(
                                controller:
                                    _scrollController, // Attach the scroll controller
                                scrollDirection:
                                    Axis.vertical, // Vertical scrolling
                                itemCount: products.length +
                                    1, // Add one for the loader
                                itemBuilder: (context, index) {
                                  if (index == products.length) {
                                    // Show loader at the end
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10.0),
                                      child: _isFetchingMore
                                          ? CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            )
                                          : const SizedBox.shrink(),
                                    );
                                  }

                                  final product = products[index];
                                  List<String> imgList = [];
                                  if (product['img'] != null) {
                                    if (product['img'] is List<String>) {
                                      imgList =
                                          List<String>.from(product['img']);
                                    } else if (product['img'] is String) {
                                      imgList = [product['img']];
                                    }
                                  }
                                  List<String> fullImgList = imgList.map((img) {
                                    return '$img/download?project=677181a60009f5d039dd';
                                  }).toList();

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom:
                                            20.0), // Add spacing between items
                                    child: Container(
                                      width:
                                          double.infinity, // Full screen width
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .cardColor, // Optional: background color
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(
                                          10.0), // Content padding
                                      child: hot(
                                          product['id'],
                                          product['name']!,
                                          fullImgList,
                                          product['details']!,
                                          product['amount']!,
                                          product['slashedPrice']!,
                                          product['discount']!,
                                          product['starImg']!,
                                          product['rating']!,
                                          product['rating2']!,
                                          product['isInFavorite']),
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
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!_isFetchingMore &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  // Trigger loading more products
                                  //fetchMoreProducts();
                                  return true;
                                }
                                return false;
                              },
                              child: ListView.builder(
                                controller:
                                    _scrollController, // Attach the scroll controller
                                scrollDirection:
                                    Axis.vertical, // Vertical scrolling
                                itemCount: products.length +
                                    1, // Add one for the loader
                                itemBuilder: (context, index) {
                                  if (index == products.length) {
                                    // Show loader at the end
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10.0),
                                      child: _isFetchingMore
                                          ? CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            )
                                          : const SizedBox.shrink(),
                                    );
                                  }

                                  final product = products[index];
                                  List<String> imgList = [];
                                  if (product['img'] != null) {
                                    if (product['img'] is List<String>) {
                                      imgList =
                                          List<String>.from(product['img']);
                                    } else if (product['img'] is String) {
                                      imgList = [product['img']];
                                    }
                                  }
                                  List<String> fullImgList = imgList.map((img) {
                                    return '$img/download?project=677181a60009f5d039dd';
                                  }).toList();

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom:
                                            20.0), // Add spacing between items
                                    child: Container(
                                      width:
                                          double.infinity, // Full screen width
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .cardColor, // Optional: background color
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(
                                          10.0), // Content padding
                                      child: hot(
                                          product['id'],
                                          product['name']!,
                                          fullImgList,
                                          product['details']!,
                                          product['amount']!,
                                          product['slashedPrice']!,
                                          product['discount']!,
                                          product['starImg']!,
                                          product['rating']!,
                                          product['rating2']!,
                                          product['isInFavorite']),
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
      int itemId,
      String name,
      List<String> img,
      String details,
      String amount,
      String slashedPrice,
      String discount,
      String starImg,
      String rating,
      String rating2,
      bool liked) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    //bool isLiked = _isLikedMap[img[0]] ?? false;
    ValueNotifier<bool> isLikedNotifier;
    isLikedNotifier = ValueNotifier<bool>(liked);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetails(
                key: UniqueKey(),
                itemId: itemId,
                name: name,
                details: details,
                amount: amount,
                slashedPrice: slashedPrice,
                rating: rating,
                rating2: rating2,
                img: img,
                discount: discount,
                starImg: starImg,
                onToggleDarkMode: widget.onToggleDarkMode,
                isDarkMode: widget.isDarkMode),
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
                    right: 5,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLikedNotifier,
                      builder: (context, isLiked, child) {
                        return Container(
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
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : originalIconColor,
                            ),
                            onPressed: () async {
                              final previousState = isLiked;
                              isLikedNotifier.value = !isLiked;
                              try {
                                await _updateFavoriteStatus(
                                    itemId, isLikedNotifier.value);
                              } catch (error) {
                                isLikedNotifier.value =
                                    previousState; // Revert if the request fails
                                print('Error updating favorite status: $error');
                              }
                            },
                          ),
                        );
                      },
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
