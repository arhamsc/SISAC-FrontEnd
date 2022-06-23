//This provider contains all the methods related to Orders of a Student/Faculty
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';
import './restaurant_providers.dart';

import '../../constants/request_url.dart' as req_url;

//Model to store a particular menu item for a particular order of a user. Each order can have multiple order Item a.k.a menuOrder
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

//Model for the Order
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

  late final Map<String, String> _headers = req_url.headers(_authToken);

  //Method to fetch Orders of the logged in User from the server.
  Future<void> fetchUserOrders() async {
    final url = orderUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = req_url.checkResponseError(response);
      List<Order> loadedOrders = [];
      List<ReceivedOrderItem> loadedOrderItems = [];
      OrderedItems loadedOrderedItems =
          OrderedItems(id: '', name: '', imageUrl: '', isAvailable: true);
      if (decodedData['message'] != null) {
        throw HttpException(decodedData['message']);
      }
      decodedData.forEach(
        (key, value) {
          loadedOrderItems = [];
          value['orderItems'].forEach(
            (val) {
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

  //Getter to get the total order length or number of order items in all the user orders.
  int get totalOrderLength {
    var total = 0;
    for (var element in _userOrders) {
      total += element.menuOrders.length;
    }
    return total;
  }
}
