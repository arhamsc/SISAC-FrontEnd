import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers/http_exception.dart';

import '../../constants/request_url.dart' as req_url;

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
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  List<BooksMaterial> get booksMaterial {
    return [..._booksMaterial];
  }

  Uri booksMaterialUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('stationary/booksmaterial$end');
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
