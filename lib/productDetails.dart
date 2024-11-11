import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails>
    with TickerProviderStateMixin, RouteAware {
  List<String> imagePaths = [
    "images/Img2.png",
    "images/Img5.png",
    "images/Img5.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isLiked = false;
  int? _selectedRadioValue;

  @override
  Widget build(BuildContext context) {
    Color originalIconColor = IconTheme.of(context).color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                            isLiked == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked == true
                                ? Colors.red
                                : originalIconColor),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      IconButton(
                        icon: Icon(
                          Icons.share_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: null,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Image.asset(
                        'images/bag.png',
                        height: 22,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CarouselSlider(
                        options: CarouselOptions(
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
                          aspectRatio: 10 / 10,
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          imagePaths.length,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.asset(
                              _current == index
                                  ? "images/Elipses_active.png"
                                  : "images/Elipses.png",
                              width: (10 / MediaQuery.of(context).size.width) *
                                  MediaQuery.of(context).size.width,
                              height:
                                  (10 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Calvin Clein",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Calvin Clein Regular fit slim fit shirt",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/Rating Icon.png',
                              height: 25,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              '4.4',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              '87 Reviews',
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
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              '\$35',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.04),
                            Text(
                              '\$40.25',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2,
                                decorationColor: Colors.grey,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.04),
                            Text(
                              '15% OFF',
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
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    width: MediaQuery.of(context).size.width *
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
                            const Text(
                              'Only 5 Left',
                              style: TextStyle(
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
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            imgList('images/Img5.png'),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              'Size',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Size Chart',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                decorationColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            size('S', 1),
                            size('M', 2),
                            size('L', 3),
                            size('XL', 4),
                            size('XXL', 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imgList(String img) {
    return Image.asset(
      img,
      height: 100,
      width: 100,
      fit: BoxFit.contain,
    );
  }

  Widget size(String text, int value) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedRadioValue = value;
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: _selectedRadioValue == value
                  ? const Color(0xFF1D4ED8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 0.8,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
