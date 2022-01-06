import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';
import '../user_provider.dart';
import './cafataria_providers.dart';

class ReceivedOrderItem {
  final int quantity;
  final int itemPrice;
  final String itemId;
  ReceivedOrderItem({
    required this.itemId,
    required this.quantity,
    required this.itemPrice,
  });
}

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
    return Uri.parse('http://192.168.1.25:3000/cafetaria/orders/restaurant$end');
    //return Uri.parse('http://172.20.10.3:3000/cafetaria/orders/restaurant$end');
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

  Future<void> getReceivedOrders() async {
    final url = restaurantUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body);
      if (decodedData['error'] != null)
        throw HttpException(decodedData['error']['message']);
      List<ReceivedOrder> loadedOrders = [];
      List<ReceivedOrderItem> loadedOrderItems = [];
      User loadedUser = User(id: '', name: '', role: '', username: '');
      decodedData.forEach(
        (key, value) {
          value['orderItems'].forEach(
            (val) {
              loadedOrderItems.add(
                ReceivedOrderItem(
                  itemId: val['_id'],
                  itemPrice: val['price'],
                  quantity: val['quantity'],
                ),
              );
              return loadedOrderItems;
            },
          );
          //print(loadedOrderItems);
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

          //print(getLoadedUser());
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
          //print(loadedOrders);
        },
      );
      _receivedOrderItem = loadedOrderItems;
      _receivedOrders = loadedOrders;
      // print(decodedData);
      // _receivedOrders.forEach((element) {
      //   print(element.user.name);
      // });
      // _receivedOrders.forEach((element) {
      //   print(element.paymentStatus);
      // });
      notifyListeners();
      //print(decodedData);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> deleteOrder(String id) async {
    final url = restaurantUrl('$id');
    try {
      final response = await http.delete(url, headers: _headers);
      final decodedData = jsonDecode(response.body);
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      if (decodedData['message'] != null) {
        throw HttpException(decodedData['message']);
      }

      print(decodedData);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
