import 'package:flutter/material.dart';

class CategoriesPageController extends ChangeNotifier {
  bool _isSidebarOpen = true;
  int _selectedImageIndex = 0;
  String? _userName;
  String? _profileImg;
  final int mainSelectedImageIndex;

  CategoriesPageController({required this.mainSelectedImageIndex}) {
    initialize();
  }

  //public getters
  bool get isSidebarOpen => _isSidebarOpen;
  int get selectedImageIndex => _selectedImageIndex;
  String? get userName => _userName;
  String? get profileImg => _profileImg;

  void setIsSidebarOpen(bool value) {
    _isSidebarOpen = value;
    notifyListeners();
  }

  void setSelectedImageIndex(int value) {
    _selectedImageIndex = value;
    notifyListeners();
  }

  void initialize() {
    _selectedImageIndex = mainSelectedImageIndex;
    notifyListeners();
  }

  String getImageUrl(int index) {
    switch (index) {
      case 0:
        return 'images/Fashion.png';
      case 1:
        return 'images/Electronics.png';
      case 2:
        return 'images/Appliances.png';
      case 3:
        return 'images/Beauty.png';
      case 4:
        return 'images/Furniture.png';
      default:
        return '';
    }
  }

  String getImageLabel(int index) {
    switch (index) {
      case 0:
        return 'Fashion';
      case 1:
        return 'Electronics';
      case 2:
        return 'Appliances';
      case 3:
        return 'Beauty';
      case 4:
        return 'Furniture';
      default:
        return '';
    }
  }

  String getImageUrl2(int index) {
    switch (index) {
      case 0:
        return 'images/Img4.png';
      case 1:
        return 'images/Img5.png';
      case 2:
        return 'images/Img6.png';
      default:
        return '';
    }
  }

  String getImageLabel2(int index) {
    switch (index) {
      case 0:
        return "Men's";
      case 1:
        return "Women's";
      case 2:
        return 'Kids';
      default:
        return '';
    }
  }
}
