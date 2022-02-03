//This Contains all the methods related to the restaurant side of the cafetaria.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../utils/helpers/http_exception.dart';
import '../user_provider.dart';

import '../../constants/request_url.dart' as req_url;

//Model to store the specific order Item.
class OrderedItems {
  final String id;
  final String name;
  final String imageUrl;
  bool isAvailable;
  OrderedItems({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isAvailable,
  });
}

//Model for the ordered Items from all the users
class ReceivedOrderItem {
  final int quantity;
  final int itemPrice;
  final OrderedItems items;
  final String id;
  ReceivedOrderItem({
    required this.id,
    required this.items,
    required this.quantity,
    required this.itemPrice,
  });
}

//Model for the overall received Order
class ReceivedOrder {
  final String id;
  final User user;
  final List<ReceivedOrderItem> menuOrders;
  final int totalAmount;
  final String paymentStatus;
  final String transactionId;
  final DateTime createdOn;
  ReceivedOrder({
    required this.id,
    required this.user,
    required this.menuOrders,
    required this.totalAmount,
    required this.paymentStatus,
    required this.transactionId,
    required this.createdOn,
  });
}

class RestaurantProvider with ChangeNotifier {
  List<ReceivedOrder> _receivedOrders = [];
  List<ReceivedOrderItem> _receivedOrderItem = [];
  late String _authToken;
  late String _userId;

  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';

    notifyListeners();
  }

  Uri restaurantUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('cafetaria/orders/restaurant$end');
  }

  List<ReceivedOrder> get receivedOrders {
    return [..._receivedOrders];
  }

  List<ReceivedOrderItem> get receivedOrderItem {
    return [..._receivedOrderItem];
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  //Method to fetch ALL orders from the server
  Future<void> getReceivedOrders() async {
    final url = restaurantUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = req_url.checkResponseError(response);
      List<ReceivedOrder> loadedOrders = [];
      List<ReceivedOrderItem> loadedOrderItems = [];
      OrderedItems loadedOrderedItems =
          OrderedItems(id: '', name: '', imageUrl: '', isAvailable: true);
      User loadedUser = User(id: '', name: '', role: '', username: '',);
      decodedData.forEach(
        (key, value) {
          loadedOrderItems = [];
          value['orderItems'].forEach(
            (val) {
              getLoadedOrderedItem() {
                for (var key in val['orderedItem'].keys) {
                  loadedOrderedItems = OrderedItems(
                    id: val['orderedItem']['_id'],
                    name: val['orderedItem']['name'],
                    imageUrl: val['orderedItem']['imageUrl'],
                    isAvailable: val['orderedItem']['isAvailable'],
                  );
                  return loadedOrderedItems;
                }
              }

              loadedOrderItems.add(
                ReceivedOrderItem(
                  id: val['_id'],
                  items: getLoadedOrderedItem()!,
                  itemPrice: val['price'],
                  quantity: val['quantity'],
                ),
              );
              return loadedOrderItems;
            },
          );
          getLoadedUser() {
            for (var key in value['user'].keys) {
              loadedUser = User(
                id: value['user']['_id'],
                username: value['user']['username'],
                name: value['user']['name'],
                role: value['user']['role'],
              );
              return loadedUser;
            }
          }
          loadedOrders.add(
            ReceivedOrder(
              id: value['_id'],
              user: getLoadedUser()!,
              menuOrders: loadedOrderItems,
              totalAmount: value['amount'],
              paymentStatus: value['paymentStatus'],
              transactionId: value['transactionId'],
              createdOn: DateTime.parse(
                value['createdOn'],
              ),
            ),
          );
        },
      );
      _receivedOrderItem = loadedOrderItems;
      _receivedOrders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  //Method to Add a New Menu Item
  Future<void> newMenuItem(
      String name, String price, String description, File image) async {
    final url = req_url.url('cafetaria/');
    try {
      var req = http.MultipartRequest('POST', url);

      req.files.add(http.MultipartFile(
        'image', //form field name
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      req.headers.addAll({
        'secret_token': _authToken,
        "Content-type": "multipart/form-data",
      });

      req.fields.addAll({
        'menuItem[name]': name,
        'menuItem[price]': price,
        'menuItem[description]': description,
      });

      await req.send();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  //Method to patch a menuItem
  Future<void> patchMenuitem(
    String id,
    String name,
    String price,
    String description, {
    required bool imageChanged,
    File? image,
  }) async {
    final url = req_url.url('cafetaria/$id');
    if (imageChanged && image != null) {
      try {
        var req = http.MultipartRequest('PATCH', url);

        req.files.add(http.MultipartFile(
          'image', //form field name
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path,
          contentType: MediaType('image', 'jpeg'),
        ));

        req.headers.addAll({
          'secret_token': _authToken,
          "Content-type": "multipart/form-data",
        });

        req.fields.addAll({
          'menuItem[name]': name,
          'menuItem[price]': price,
          'menuItem[description]': description,
        });

        await req.send();
      } catch (error) {
        throw HttpException(error.toString());
      }
    } else {
      try {
        final response = await http.patch(
          url,
          headers: _headers,
          body: jsonEncode(
            {
              'menuItem': {
                'name': name,
                'price': price,
                'description': description,
              }
            },
          ),
        );
        req_url.checkResponseError(response);
      } catch (error) {
        throw HttpException(error.toString());
      }
    }
  }

  //Method to delete a particular order from the Database after it has been prepared.
  Future<void> deleteOrder(String id) async {
    final url = restaurantUrl(id);
    try {
      final response = await http.delete(url, headers: _headers);
      final decodedData = req_url.checkResponseError(response);
      if (decodedData['message'] != null) {
        throw HttpException(decodedData['message']);
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
