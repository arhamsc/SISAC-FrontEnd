//This provider is for all the functions related to the Menu or Cafetaria cart.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';
import './order_providers.dart';

import '../../constants/request_url.dart' as req_url;

class CartProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  Map<String, MenuOrder> _cartItems = {};

  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
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

  //we are the cart items as a map with its ID as a key.
  Map<String, MenuOrder> get cartItems {
    return {..._cartItems};
  }

  //method to add a cart item.
  void addCartItem(String id, int price, int quantity) {
    if (_cartItems.containsKey(id)) {
      _cartItems.update(
        id,
        (existingItem) => MenuOrder(
          itemId: existingItem.itemId,
          quantity: existingItem.quantity + 1,
          itemPrice: existingItem.itemPrice + (price),
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        id,
        () => MenuOrder(
          itemId: id,
          quantity: quantity,
          itemPrice: price,
        ),
      );
    }
    notifyListeners();
  }

  //Method to change the quantity of a particular cart item.
  void updateQuantity(String id, int price, int quantity) {
    _cartItems.update(
      id,
      (existingItem) => MenuOrder(
        itemId: existingItem.itemId,
        quantity: quantity,
        itemPrice: price * quantity,
      ),
    );
    notifyListeners();
  }

  //method to delete a cart item.
  void deleteCartItem(String id, int price, {bool deleteWhole = false}) {
    int findQty(String key) {
      int qty = 0;
      for (var keys in _cartItems.keys) {
        qty = _cartItems[key]!.quantity;
      }
      return qty;
    }

    !deleteWhole
        ? {
            if (_cartItems.containsKey(id))
              {
                findQty(id) > 1
                    ? _cartItems.update(
                        id,
                        (existingItem) => MenuOrder(
                          itemId: existingItem.itemId,
                          quantity: existingItem.quantity - 1,
                          itemPrice: existingItem.itemPrice - price,
                        ),
                      )
                    : _cartItems.remove(id)
              }
            else
              {_cartItems.remove(id)}
          }
        : _cartItems.remove(id);
    notifyListeners();
  }

  //Getter to get the the total items in the cart
  int get totalItems {
    var total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  //Getter to get the total amount of the cart items
  int get totalAmount {
    var amt = 0;
    _cartItems.forEach((key, value) {
      amt += value.quantity * value.itemPrice;
    });
    return amt;
  }

  //Method to return the item price of a cart item.
  num getItemPrice(num price, int quantity) {
    return price * quantity;
  }

  //Method to make a order a.k.a make a POST request to the server to add in the received orders database
  Future<void> makeOrder(
    List<MenuOrder> items,
    int amount,
    String pmtStatus,
    String txnId,
    String timeStamp,
  ) async {
    final url = orderUrl();
    try {
      if (items.isEmpty) throw HttpException("Empty Cart");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(
          {
            'orderItem': //*use .map method on the list when creating a cart to send data.
                items
                    .map((ele) => {
                          'orderedItem': ele.itemId,
                          'quantity': ele.quantity,
                          'price': ele.itemPrice
                        })
                    .toList(),
            'order': {
              'amount': amount,
              'paymentStatus': pmtStatus,
              'transactionId': txnId,
              'createdOn': timeStamp,
            }
          },
        ),
      );
      var decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] != null) {
        //print(decodedData['error']['message']);
        throw HttpException(decodedData['error']['message']);
      }
      _cartItems = {};
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
