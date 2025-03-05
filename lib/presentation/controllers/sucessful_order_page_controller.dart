import 'package:flutter/material.dart';

class SucessfulOrderPageController extends ChangeNotifier {
  final ValueNotifier<String> selectedSizeNotifier = ValueNotifier<String>("L");
  final ValueNotifier<int> quantityNotifier = ValueNotifier<int>(1);
}
