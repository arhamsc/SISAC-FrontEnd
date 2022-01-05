import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';

class Availability {
  final String id;
  final String materialType;
  bool isAvailable = true;
  Availability({
    required this.id,
    required this.materialType,
    required this.isAvailable,
  });
}

class AvailabilityProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<Availability> _availableItems = [];

  void update(token, userId) {
    _authToken = token;
    _userId = userId;
    notifyListeners();
  }

  List<Availability> get availableItems {
    return [..._availableItems];
  }

  Uri availabilityUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return Uri.parse('http://192.168.1.25:3000/stationary/availability$end');
    //return Uri.parse('http://172.20.10.3:3000/cafetaria/orders$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> fetchAvailableItems() async {
    final url = availabilityUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body);

      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      List<Availability> loadedItems = [];
      decodedData.forEach(
        (key, value) {
          loadedItems.add(
            Availability(
              id: value['_id'],
              materialType: value['materialType'],
              isAvailable: value['isAvailable'],
            ),
          );
        },
      );
      _availableItems = loadedItems;
      
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
