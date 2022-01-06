import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/helpers/http_exception.dart';

import '../screens/login_screen.dart';

//below is the student model
class User {
  final String id;
  final String username;
  final String role;
  final String name;
  User({
    required this.id,
    required this.username,
    required this.role,
    required this.name,
  });
  @override
  String toString() {
    return '[id: $id, name: $name, role: $role, username: $username]';
  }
}

//below is the auth class to authenticate the user
class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  String? _role;
  String? _name;
  String? _username;

  late User _user;

  User get getUser {
    return _user;
  }

  Uri url(String endPoint) {
    final url = Uri.parse('http://192.168.1.25:3000/$endPoint');
    //final url = Uri.parse('http://172.20.10.3:3000/$endPoint');
    return url;
  }

//below is the method for logging in the user from our API
  Future<void> login(
      String? username, String? password, BuildContext context) async {
    final url = this.url('login');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'username': username,
            'password': password,
          },
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      //below the data is being decoded from the response
      final decodedData = json.decode(response.body);
      //print(decodedData);
      if (decodedData['error'] != null) {
        // print(decodedData['error']['message']);
        throw HttpException(decodedData['error']['message']);
      }
      //creating a new user to store it locally in the list to access the role and token
      final newUser = User(
        id: decodedData['id'],
        username: decodedData['username'],
        role: decodedData['role'],
        name: decodedData['name'],
      );
      _user = newUser;
      //if there is an error then it is thrown here
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }
      _token = decodedData['token'];
      _userId = decodedData['id'];
      _role = decodedData['role'];
      _username = decodedData['username'];
      _expiryDate = DateTime.now().add(
        Duration(
          milliseconds: decodedData['expiresIn'],
        ),
      );
      _autoLogout(context);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        'role': _role,
        'name': _name,
        'username': _username
      });
      //print(userData);
      await prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  //local validation if token exists or not
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //if the token exists then the user is authenticated
  bool get isAuth {
    return _token != null;
  }

  //to try autologging in if the token is stored in the memory
  Future<bool> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);

    if (expiryDate.isBefore((DateTime.now()))) {
      return false;
    }

    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _role = extractedData['role'] as String;
    _name = extractedData['name'] as String;
    _username = extractedData['username'] as String;
    _expiryDate = expiryDate;
    _user =
        User(id: _userId!, name: _name!, role: _role!, username: _username!);
    notifyListeners();
    //print("$_token $_userId $_role");
    _autoLogout(context);
    return true;
  }

  //logout method
  Future<void> logout(BuildContext context) async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _role = null;
    _username = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName, (Route<dynamic> route) => false);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //to start the timer for the expiry date to auto logout after the timer ends
  void _autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpire = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer =
        Timer(Duration(seconds: timeToExpire as int), () => logout(context));
  }

  String? get getRole {
    // print(_role);
    return _role;
  }

  String? get getUserId {
    return _userId;
  }
}
