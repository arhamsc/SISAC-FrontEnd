//This contains all the methods related to the books material part of the stationary.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../utils/helpers/http_exception.dart';

import '../../constants/request_url.dart' as req_url;

//Model for the books which will be fetched from the server.
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

  BooksMaterial findBookById(String id) {
    return _booksMaterial.firstWhere((element) => element.id == id);
  }

  //Method to fetch all the books from the database.
  Future<void> fetchAllBooks() async {
    final url = booksMaterialUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = req_url.checkResponseError(response);
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

  Future<void> newBook(
    String name,
    String price,
    String author,
    String edition,
    File image,
  ) async {
    final url = booksMaterialUrl();
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
        'book[name]': name,
        'book[price]': price,
        'book[edition]': edition,
        'book[author]': author,
      });

      await req.send();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> patchBook(
    String id,
    String name,
    String price,
    String author,
    String edition, {
    required bool imageChanged,
    File? image,
  }) async {
    final url = booksMaterialUrl(id);
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
          'book[name]': name,
          'book[price]': price,
          'book[edition]': edition,
          'book[author]': author,
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
              'book': {
                'name': name,
                'price': price,
                'edition': edition,
                'author': author,
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

  Future<void> deleteBook(String id) async {
    final url = booksMaterialUrl(id);
    try {
      final response = await http.delete(url, headers: _headers);
      req_url.checkResponseError(response);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
