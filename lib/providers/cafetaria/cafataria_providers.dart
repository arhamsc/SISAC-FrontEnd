import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../user_provider.dart';
import '../../utils/helpers/http_exception.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final num rating;
  final int price;
  final String imageUrl;
  final bool isAvailable;
  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  // @override
  // String toString() {
  //   return '[id: $id, name: $name, description: $description, rating: $rating, price: $price, imageUrl: $imageUrl, isAvailable: $isAvailable]';
  // }
}

class MenuItemProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<MenuItem> _menuItems = [];
  void update(token, userId) {
    _authToken = token;
    _userId = userId;
    notifyListeners();
  }

  List<MenuItem> get items {
    return [..._menuItems];
  }

  Uri cafetariaUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    //return Uri.parse('http://192.168.1.25:3000/cafetaria$end');
    return Uri.parse('http://172.20.10.3:3000/cafetaria$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> fetchMenu() async {
    final url = cafetariaUrl();
    try {
      final response = await http.get(url, headers: _headers);
      var decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] != null) {
        print(decodedData);
        throw HttpException(decodedData['error']['message']);
      }
      List<MenuItem> loadedItems = [];
      //print(decodedData);
      //print(decodedData['items']);
      decodedData.forEach(
        (key, value) {
          loadedItems.add(
            MenuItem(
              id: value['_id'],
              name: value['name'],
              description: value['description'],
              rating: value['rating'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isAvailable: value['isAvailable'],
            ),
          );
        },
      );

      _menuItems = loadedItems;

      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> updateRating(String menuId, num rating) async {
    print(menuId);
    final url = cafetariaUrl('$menuId/rate');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(
          {
            'rating': rating,
          },
        ),
      );
      //print(response.body);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

   MenuItem findMenu(String id) {
    return _menuItems.firstWhere((element) => element.id == id);
  }
}
