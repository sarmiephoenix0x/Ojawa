import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const HomePage(
      {super.key,
      required this.selectedIndex,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
