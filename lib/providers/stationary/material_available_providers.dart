//This contains all the methods dealing with the materials that are available in the stationary.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../utils/helpers/http_exception.dart';

import '../../constants/request_url.dart' as req_url;

//Model for the available material
class MaterialAvailable {
  final String id;
  final String materialType;
  final String name;
  final num price;
  final String imageUrl;
  final String imageFileName;
  MaterialAvailable({
    required this.id,
    required this.materialType,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.imageFileName,
  });
}

class MaterialAvailableProvider with ChangeNotifier {
  late String _authToken;
  late String _userId;
  List<MaterialAvailable> _materialAvailable = [];

  void update(token, userId) {
    token != null ? _authToken = token : _authToken = '';
    userId != null ? _userId = userId : _userId = '';
    notifyListeners();
  }

  List<MaterialAvailable> get materialsAvailable {
    return [..._materialAvailable];
  }

  Uri materialAvailableUrl([String endPoint = '']) {
    final end = endPoint.isEmpty ? '' : '/$endPoint';
    return req_url.url('stationary/availablematerial$end');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  MaterialAvailable findMaterialById(String id) {
    return _materialAvailable.firstWhere((element) => element.id == id);
  }

  //Method to fetch all the materials from the database.
  Future<void> fetchAllMaterials() async {
    final url = materialAvailableUrl();
    try {
      final response = await http.get(url, headers: _headers);
      final decodedData = jsonDecode(response.body);
      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      List<MaterialAvailable> loadedMaterials = [];
      decodedData.forEach((key, value) {
        loadedMaterials.add(
          MaterialAvailable(
            id: value['_id'],
            materialType: value['materialType'],
            name: value['name'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            imageFileName: value['imageFileName'],
          ),
        );
      });
      _materialAvailable = loadedMaterials;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> newMaterial(
    String name,
    String price,
    String materialType,
    File image,
  ) async {
    final url = materialAvailableUrl();
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
        'material[name]': name,
        'material[price]': price,
        'material[materialType]': materialType,
      });
      await req.send();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> patchMaterial(
    String id,
    String name,
    String price,
    String materialType,
{
    required bool imageChanged,
    File? image,
  }) async {
    final url = materialAvailableUrl(id);
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
          'material[name]': name,
          'material[price]': price,
          'material[materialType]': materialType,
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
              'material': {
                'name': name,
                'price': price,
                'materialType': materialType,
              }
            },
          ),
        );
        final decodedData = jsonDecode(response.body);
        if (decodedData['error'] != null) {
          throw HttpException(decodedData['error']['message']);
        }
      } catch (error) {
        throw HttpException(error.toString());
      }
    }
  }
}
