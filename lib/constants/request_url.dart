import 'dart:convert';
import 'package:http/http.dart';

import '../utils/helpers/http_exception.dart';

Uri url(String endPoint) {
<<<<<<< HEAD
  final url = Uri.parse('http://192.168.1.10:3000/$endPoint');
  // final url = Uri.parse('https://sisac.herokuapp.com/$endPoint');
  // final url = Uri.parse('http://172.20.10.3:3000/$endPoint');
  //final url = Uri.parse('http://192.168.86.227:3000/$endPoint');
=======
  // final url = Uri.parse('http://192.168.1.4:3000/$endPoint');
  final url = Uri.parse('https://sisac.herokuapp.com/$endPoint');
  //final url = Uri.parse('http://172.20.10.3:3000/$endPoint');
>>>>>>> dev
  return url;
}

Map<String, dynamic> checkResponseError(Response response) {
  final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
  if (decodedData['error'] != null) {
    throw HttpException(decodedData['error']['message']);
  }
  return decodedData;
}
//bbbbb
