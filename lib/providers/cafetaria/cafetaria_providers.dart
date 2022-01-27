//These are cafetaria providers, to handle everything related to cafetaria for student and faculty.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/request_url.dart' as req_url;
import '../../utils/helpers/http_exception.dart';

//menu model, which is declared using the class.
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

//to store the recommended dishes.
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

//This is the main provider which handles all the logic and Provider package makes use of change notifier built in flutter, to notify the changes to all the listeners.
class MenuItemProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<MenuItem> _menuItems = [];
  List<Recommendations> _recommendations = [];
  //These are the required details we receive from the auth provider in main dart file.
  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  //The main list shouldn't change in case something happens so we define a getter here for the private List to access it outside. It is a good practice.
  List<MenuItem> get items {
    return [..._menuItems];
  }

  List<Recommendations> get recommendations {
    return [..._recommendations];
  }

//the main URL is defined in the Constants Folder to make it manageable at one place
  Uri cafetariaUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('cafetaria$end');
  }

//the headers which are required by the backend-server are stores in this Map.
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

//The Future (similar to promises in JS) function to fetch the menu items from out data base by sending a request to our server
  Future<void> fetchMenu() async {
    final url = cafetariaUrl();
    try {
      //HTTP package is used to send the requests.
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
      //Looping over the decoded data to store the values in the local List
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
      //notifies the listeners or users of this function or provider.
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

//Method to update the rating of a dish.
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

  //method to find a menuitem with a given string.
  MenuItem findMenuById(String id) {
    return _menuItems.firstWhere((element) => element.id == id);
  }

  //Method to update the availability status of a dish.
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

  Future<void> deleteMenuItem(String id) async {
    final url = cafetariaUrl(id);
    try {
      final response = await http.delete(url, headers: _headers);
      final data = req_url.checkResponseError(response);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  //method to get the recommended dishes from the data base.
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
