import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controllers/intro_page_controller.dart';
import '../auth/sign_in_page.dart';
import '../auth/sign_up_page.dart';

class IntroPage extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  const IntroPage(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    //final introPageController = Provider.of<IntroPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => IntroPageController(
          context: context,
          onToggleDarkMode: widget.onToggleDarkMode,
          isDarkMode: widget.isDarkMode,
          vsync: this),
      child: Consumer<IntroPageController>(
        builder: (context, introPageController, child) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return PopScope(
                canPop: false,
                child: Scaffold(
                  body: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              enlargeCenterPage: false,
                              height: MediaQuery.of(context).size.height,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: false,
                              initialPage: 0,
                              onPageChanged: (index, reason) {
                                introPageController.setCurrent(index);
                              },
                            ),
                            carouselController: introPageController.controller,
                            items: introPageController.imagePaths.map((item) {
                              return SingleChildScrollView(
                                child: SizedBox(
                                  height: orientation == Orientation.portrait
                                      ? MediaQuery.of(context).size.height
                                      : MediaQuery.of(context).size.height *
                                          2.6,
                                  child: Column(
                                    children: [
                                      const Spacer(),
                                      Image.asset(
                                        item,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                      const Spacer(),
                                      Text(
                                        introPageController.imageHeaders[
                                            introPageController.current],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontFamily: 'Inconsolata',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      if (introPageController.current != 2)
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            introPageController
                                                    .imageSubheadings[
                                                introPageController.current],
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontFamily: 'Inconsolata',
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      if (introPageController.current == 2)
                                        const Spacer(),
                                      if (introPageController.current == 2)
                                        Container(
                                          width: double.infinity,
                                          height: (60 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height) *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpPage(
                                                          key: UniqueKey(),
                                                          onToggleDarkMode: widget
                                                              .onToggleDarkMode,
                                                          isDarkMode: widget
                                                              .isDarkMode),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
                                                    return Colors.white;
                                                  }
                                                  return Colors.black;
                                                },
                                              ),
                                              foregroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
                                                    return Colors.black;
                                                  }
                                                  return Colors.white;
                                                },
                                              ),
                                              elevation: WidgetStateProperty
                                                  .all<double>(4.0),
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Get Started',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (introPageController.current == 2)
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05),
                                      if (introPageController.current == 2)
                                        Container(
                                          width: double.infinity,
                                          height: (60 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height) *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInPage(
                                                          key: UniqueKey(),
                                                          onToggleDarkMode: widget
                                                              .onToggleDarkMode,
                                                          isDarkMode: widget
                                                              .isDarkMode),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
                                                    return Colors.black;
                                                  }
                                                  return Colors.white;
                                                },
                                              ),
                                              foregroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
                                                    return Colors.white;
                                                  }
                                                  return Colors.black;
                                                },
                                              ),
                                              elevation: WidgetStateProperty
                                                  .all<double>(4.0),
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                  side: BorderSide(width: 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Sign in',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          // if (_current != 2)
                          //   Positioned(
                          //     bottom: MediaQuery.of(context).padding.bottom + 5,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: List.generate(
                          //         imagePaths.length,
                          //         (index) => Padding(
                          //           padding:
                          //               const EdgeInsets.symmetric(horizontal: 8.0),
                          //           child: Image.asset(
                          //             _current == index
                          //                 ? "images/Active.png"
                          //                 : "images/Inactive.png",
                          //             width: (10 / MediaQuery.of(context).size.width) *
                          //                 MediaQuery.of(context).size.width,
                          //             height:
                          //                 (10 / MediaQuery.of(context).size.height) *
                          //                     MediaQuery.of(context).size.height,
                          //             color: Theme.of(context).colorScheme.onSurface,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // if (_current != 2)
                          //   Positioned(
                          //     top: MediaQuery.of(context).padding.top + 0,
                          //     right: MediaQuery.of(context).padding.right + 0,
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          //       child: SizedBox(
                          //         width: MediaQuery.of(context).size.width * 0.8,
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => SignInPage(
                          //                     key: UniqueKey(),
                          //                     onToggleDarkMode:
                          //                         widget.onToggleDarkMode,
                          //                     isDarkMode: widget.isDarkMode),
                          //               ),
                          //             );
                          //           },
                          //           child: Row(
                          //             children: [
                          //               const Spacer(),
                          //               Text(
                          //                 'Skip',
                          //                 style: TextStyle(
                          //                   fontFamily: 'Inconsolata',
                          //                   fontSize: 20,
                          //                   color: Theme.of(context)
                          //                       .colorScheme
                          //                       .onSurface,
                          //                 ),
                          //               ),
                          //               IconButton(
                          //                 icon: Icon(
                          //                   Icons.navigate_next,
                          //                   color: Theme.of(context)
                          //                       .colorScheme
                          //                       .onSurface,
                          //                 ),
                          //                 onPressed: null,
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
