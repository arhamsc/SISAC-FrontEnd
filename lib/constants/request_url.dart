import 'dart:convert';
import 'package:http/http.dart';

import '../utils/helpers/http_exception.dart';

Uri url(String endPoint) {
  // final url = Uri.parse('http://192.168.1.8:3000/$endPoint');
  // final url = Uri.parse('https://sisac.herokuapp.com/$endPoint');
  final url = Uri.parse('http://172.20.10.3:3000/$endPoint');
  //final url = Uri.parse('http://192.168.86.227:3000/$endPoint');
  // final url = Uri.parse('http://192.168.79.227:3000/$endPoint'); //Sagar
  return url;
}

Map<String, dynamic> checkResponseError(Response response) {
  final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
  if (decodedData['error'] != null) {
    throw HttpException(decodedData['error']['message']);
  }
  return decodedData;
}

Map<String, String> headers(String? authToken) {
  final _header = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': "Bearer $authToken",
  };

  return _header;
}
