import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';
import './restaurant_providers.dart';

import '../../constants/request_url.dart' as req_url;
class MenuOrder {
  final int quantity;
  final int itemPrice;
  final String itemId;

  MenuOrder({
    required this.itemId,
    required this.quantity,
    required this.itemPrice,
  });
}

class Order {
  final String id;
  final String user;
  final List<ReceivedOrderItem> menuOrders;
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
  OrderedItems _orderedItem =
      OrderedItems(id: '', name: '', imageUrl: '', isAvailable: true);
  List<ReceivedOrderItem> _orderItems = [];
  late String _authToken;
  late String _userId;

  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  List<Order> get userOrders {
    return [..._userOrders];
  }

  OrderedItems get orderedItem {
    return _orderedItem;
  }

  List<ReceivedOrderItem> get orderItems {
    return [..._orderItems];
  }

  Uri orderUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('cafetaria/orders$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> fetchUserOrders() async {
    final url = orderUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      //print(decodedData);
      List<Order> loadedOrders = [];
      List<ReceivedOrderItem> loadedOrderItems = [];
      OrderedItems loadedOrderedItems =
          OrderedItems(id: '', name: '', imageUrl: '', isAvailable: true);
      decodedData.forEach(
        (key, value) {
          value['orderItems'].forEach(
            (val) {
              //print("Ordered Item: ${val['orderedItem']}");
              getLoadedOrderedItem() {
                for (var key in val['orderedItem'].values) {
                  loadedOrderedItems = OrderedItems(
                    id: val['orderedItem']['_id'],
                    name: val['orderedItem']['name'],
                    imageUrl: val['orderedItem']['imageUrl'],
                    isAvailable: val['orderedItem']['isAvailable'],
                  );
                  return loadedOrderedItems;
                }
              }

              //print("Function: ${}");
              //print(loadedOrderedItems);
              loadedOrderItems.add(
                ReceivedOrderItem(
                  id: val['_id'],
                  items: getLoadedOrderedItem()!,
                  itemPrice: val['price'],
                  quantity: val['quantity'],
                ),
              );
              //print(loadedOrderItems);
              //print("End of First");
              return loadedOrderItems;
            },
          );
          //print("End of full orderItem");
          //print(loadedOrderItems);

          //print(getLoadedUser());
          loadedOrders.add(
            Order(
              id: value['_id'],
              user: value['user'],
              menuOrders: loadedOrderItems,
              totalAmount: value['amount'],
              paymentStatus: value['paymentStatus'],
              transactionId: value['transactionId'],
              createdOn: DateTime.parse(
                value['createdOn'],
              ),
            ),
          );

          //print("End of Full ORDERS");
          //print(loadedOrders);
        },
      );
      _orderItems = loadedOrderItems;
      _orderedItem = loadedOrderedItems;
      _userOrders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  int get totalOrderLength {
    var total = 0;
    _userOrders.forEach((element) {
      total += element.menuOrders.length;
    });
    return total;
  }
}
