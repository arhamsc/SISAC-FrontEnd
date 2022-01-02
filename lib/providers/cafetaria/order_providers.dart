import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';
import '../user_provider.dart';
import './cafataria_providers.dart';

class MenuOrder {
  final int quantity;
  final int itemPrice;
  final String itemId;
  MenuOrder({
    required this.itemId,
    required this.quantity,
    required this.itemPrice,
  });
  factory MenuOrder.fromJson(Map<String, dynamic> parsedJson) {
    return MenuOrder(
        itemId: parsedJson['_id'],
        itemPrice: parsedJson['price'],
        quantity: parsedJson['quantity']);
  }
}

class Order {
  final String id;
  final String user;
  final List<MenuOrder> menuOrders;
  final int totalAmount;
  final String paymentStatus;
  final String transactionId;
  final DateTime createdOn;
  Order({
    required this.id,
    required this.user,
    required this.menuOrders,
    required this.totalAmount,
    required this.paymentStatus,
    required this.transactionId,
    required this.createdOn,
  });
}

class OrderProvider with ChangeNotifier {
  List<Order> _userOrders = [];
  late String _authToken;
  late String _userId;

  void update(token, userId) {
    _authToken = token;
    _userId = userId;
    notifyListeners();
  }

  List<Order> get userOrders {
    return [..._userOrders];
  }

  Uri orderUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return Uri.parse('http://192.168.1.25:3000/cafetaria/orders$end');
    //return Uri.parse('http://172.20.10.3:3000/cafetaria$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> makeOrder(MenuItem menu, int quantity, String paymentStatus,
      String txnId, String createdOn) async {
    final url = orderUrl();
    final price = menu.price * quantity;
    try {
      final response = await http.post(url,
          headers: _headers,
          body: jsonEncode({
            // TODO: when implementing cart send array of menu Items
            'orderItem': //*use .map method on the list when creating a cart to send data.
                [
              {
                '_id': menu.id,
                'quantity': quantity,
                'price': price,
              }
            ],
            'order': {
              'amount': price,
              'paymentStatus': paymentStatus,
              'transactionId': txnId,
              'createdOn': createdOn,
            }
          }));
      var decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] != null) {
        //print(decodedData['error']['message']);
        throw HttpException(decodedData['error']['message']);
      }
      //print(decodedData);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> fetchUserOrders() async {
    final url = orderUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      List<Order> loadedOrders = [];
      List<MenuOrder> loadedMap = [];
      decodedData.forEach(
        (key, value) {
          value['orderItems'].forEach(
            (val) {
              loadedMap.add(
                MenuOrder(
                  itemId: val['_id'],
                  itemPrice: val['price'],
                  quantity: val['quantity'],
                ),
              );
              return loadedMap;
            },
          );
          loadedOrders.add(
            Order(
                id: value['_id'],
                user: value['user'],
                totalAmount: value['amount'],
                paymentStatus: value['paymentStatus'],
                transactionId: value['transactionId'],
                createdOn: DateTime.parse(value['createdOn']),
                menuOrders: loadedMap),
          );
        },
      );
      _userOrders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
