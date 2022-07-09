//This contains all the methods for fetching the availability of Bluebooks and records.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';

import '../../constants/request_url.dart' as req_url;

//Model for each item
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
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  List<Availability> get availableItems {
    return [..._availableItems];
  }

  Uri availabilityUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('stationary/availability$end');
  }

  Map<String, String> get _headers {
    return req_url.headers(_authToken);
  }

  //method to fetch the items along with their availability.
  Future<void> fetchAvailableItems() async {
    final url = availabilityUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = req_url.checkResponseError(response);
      if (decodedData.isEmpty) {
        throw HttpException("No Items");
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

  /* 
    Method to update the Availability of Bluebook or Record
   */
  Future<void> updateAvailability(String id, bool available) async {
    final url = availabilityUrl(id);
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {'isAvailable': available},
        ),
        headers: _headers,
      );
      req_url.checkResponseError(response);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
