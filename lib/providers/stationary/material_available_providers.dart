import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';

class MaterialAvailable {
  final String id;
  final String materialType;
  final String name;
  final num price;
  final String imageUrl;
  final String imageFileName;
  MaterialAvailable({
    required this.id,
    required this.materialType,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.imageFileName,
  });
}

class MaterialAvailableProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<MaterialAvailable> _materialAvailable = [];

  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  List<MaterialAvailable> get materialsAvailable {
    return [..._materialAvailable];
  }

  Uri materialAvailableUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return Uri.parse('http://192.168.1.25:3000/stationary/availablematerial$end');
    //return Uri.parse('http://172.20.10.3:3000/stationary/availablematerial$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> fetchAllMaterials() async {
    final url = materialAvailableUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body);
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      List<MaterialAvailable> loadedMaterials = [];
      decodedData.forEach((key, value) {
        loadedMaterials.add(
          MaterialAvailable(
            id: value['_id'],
            materialType: value['materialType'],
            name: value['name'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            imageFileName: value['imageFileName'],
          ),
        );
      });
      _materialAvailable = loadedMaterials;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
