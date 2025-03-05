import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesDetailsService {
  static final _storage = const FlutterSecureStorage();

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final String? accessToken = await _storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products/categories';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchProducts(
      {int pageNum = 1}) async {
    final String? accessToken = await _storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products?page=$pageNum';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
    return [];
  }
}
