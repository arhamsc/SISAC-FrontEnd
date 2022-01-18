import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/request_url.dart' as req_url;
import '../../utils/helpers/http_exception.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final num rating;
  final int price;
  final String imageUrl;
  final String imageFileName;
  bool isAvailable = true;
  MenuItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.rating,
      required this.price,
      required this.imageUrl,
      required this.isAvailable,
      required this.imageFileName});
}

class Recommendations {
  final String id;
  final String itemId;
  final int count;
  Recommendations({
    required this.id,
    required this.itemId,
    required this.count,
  });
}

class MenuItemProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<MenuItem> _menuItems = [];
  List<Recommendations> _recommendations = [];
  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  List<MenuItem> get items {
    return [..._menuItems];
  }

  List<Recommendations> get recommendations {
    return [..._recommendations];
  }

  Uri cafetariaUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('cafetaria$end');
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
        //print(decodedData);
        throw HttpException(decodedData['error']['message']);
      }
      // print(decodedData);
      List<MenuItem> loadedItems = [];
      // print(decodedData);
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
                imageFileName: value['imageFileName']),
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
    //print(menuId);
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

  Future<void> updateIsAvailable(String id, bool currentStatus) async {
    final url = cafetariaUrl('$id/isAvailable');
    final oldStatus = currentStatus;

    currentStatus = !currentStatus;

    notifyListeners();
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(
          {
            'isAvailable': currentStatus,
          },
        ),
      );
      final decodedData = jsonDecode(response.body);
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      if (response.statusCode >= 400) {
        currentStatus = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      currentStatus = oldStatus;
      throw HttpException(error.toString());
    }
  }

  Future<void> getRecommendations() async {
    final url = cafetariaUrl('recommendation');
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      List<Recommendations> loadedRecoms = [];
      decodedData.forEach((key, value) {
        loadedRecoms.add(
          Recommendations(
            id: value['_id'],
            itemId: value['item'],
            count: value['count'],
          ),
        );
      });
      _recommendations = loadedRecoms;
      
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
