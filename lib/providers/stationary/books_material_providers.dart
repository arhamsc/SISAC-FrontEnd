import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';

class BooksMaterial {
  final String id;
  final String name;
  final String author;
  final int edition;
  final num price;
  final String imageUrl;
  final String imageFileName;
  BooksMaterial({
    required this.id,
    required this.name,
    required this.author,
    required this.edition,
    required this.price,
    required this.imageUrl,
    required this.imageFileName,
  });
}

class BooksMaterialProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<BooksMaterial> _booksMaterial = [];

  void update(token, userId) {
    _authToken = token;
    _userId = userId;
    notifyListeners();
  }

  List<BooksMaterial> get booksMaterial {
    return [..._booksMaterial];
  }

  Uri booksMaterialUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return Uri.parse('http://192.168.1.25:3000/stationary/booksmaterial$end');
    //return Uri.parse('http://172.20.10.3:3000/cafetaria/orders$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> fetchAllBooks() async {
    final url = booksMaterialUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body);
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      List<BooksMaterial> loadedBooks = [];
      decodedData.forEach((key, value) {
        loadedBooks.add(
          BooksMaterial(
              id: value['_id'],
              name: value['name'],
              author: value['author'],
              edition: value['edition'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              imageFileName: value['imageFileName']),
        );
      });
      _booksMaterial = loadedBooks;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}