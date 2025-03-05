import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/widgets/custom_snackbar.dart';

class ApplyCouponService {
  static final _storage = const FlutterSecureStorage();

  static Future<List> fetchCoupons(BuildContext context, String query) async {
    final String? accessToken = await _storage.read(key: 'accessToken');
    final url = 'https://signal.payguru.com.ng/api/search?query=$query';
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      CustomSnackbar.show("No results found or an error occurred!",
          isError: true);
      return [];
    }
  }
}
