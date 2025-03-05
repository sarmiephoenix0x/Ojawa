import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../presentation/screens/auth/sign_in_page.dart';
import '../../presentation/screens/productDetails/productDetails.dart';
import 'custom_gap.dart';
import 'custom_snackbar.dart';

class Product extends StatefulWidget {
  final int itemId;
  final String name;
  final List<String> img;
  final String details;
  final String amount;
  final String slashedPrice;
  final String discount;
  final String starImg;
  final String rating;
  final String rating2;
  final bool liked;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const Product({
    super.key,
    required this.itemId,
    required this.name,
    required this.img,
    required this.details,
    required this.amount,
    required this.slashedPrice,
    required this.discount,
    required this.starImg,
    required this.rating,
    required this.rating2,
    required this.liked,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  _HotWidgetState createState() => _HotWidgetState();
}

class _HotWidgetState extends State<Product> {
  late ValueNotifier<bool> isLikedNotifier;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    isLikedNotifier = ValueNotifier<bool>(widget.liked);
  }

  @override
  void dispose() {
    isLikedNotifier.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetails(
                key: UniqueKey(),
                itemId: widget.itemId,
                name: widget.name,
                details: widget.details,
                amount: widget.amount,
                slashedPrice: widget.slashedPrice,
                rating: widget.rating,
                rating2: widget.rating2,
                img: widget.img,
                discount: widget.discount,
                starImg: widget.starImg,
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
                    widget.img[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey);
                    },
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLikedNotifier,
                      builder: (context, isLiked, child) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(55.0)),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              final previousState = isLiked;
                              try {
                                final String? accessToken =
                                    await storage.read(key: 'accessToken');
                                if (accessToken == null) {
                                  CustomSnackbar.show(
                                    'You are not logged in.',
                                    isError: true,
                                  );
                                  // await prefs.remove('user');

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInPage(
                                          key: UniqueKey(),
                                          onToggleDarkMode:
                                              widget.onToggleDarkMode,
                                          isDarkMode: widget.isDarkMode),
                                    ),
                                  );
                                  return;
                                }
                                isLikedNotifier.value = !isLiked;
                                await _updateFavoriteStatus(
                                    widget.itemId, isLikedNotifier.value);
                              } catch (error) {
                                isLikedNotifier.value = previousState;
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
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA580C),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
            Gap(MediaQuery.of(context).size.height * 0.02,
                useMediaQuery: false),
            Text(
              widget.details,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Gap(MediaQuery.of(context).size.height * 0.01,
                useMediaQuery: false),
            Row(
              children: [
                Text(
                  widget.amount,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Gap(MediaQuery.of(context).size.width * 0.03,
                    isHorizontal: true, useMediaQuery: false),
                Text(
                  widget.slashedPrice,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 2,
                    decorationColor: Colors.grey,
                  ),
                ),
                Gap(MediaQuery.of(context).size.width * 0.03,
                    isHorizontal: true, useMediaQuery: false),
                Text(
                  widget.discount,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
            Gap(MediaQuery.of(context).size.height * 0.01,
                useMediaQuery: false),
            Row(
              children: [
                Image.asset(
                  widget.starImg,
                  height: 23,
                ),
                Gap(MediaQuery.of(context).size.width * 0.02,
                    isHorizontal: true, useMediaQuery: false),
                Text(
                  widget.rating,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Gap(MediaQuery.of(context).size.width * 0.02,
                    isHorizontal: true, useMediaQuery: false),
                Text(
                  widget.rating2,
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
