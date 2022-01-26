//This contains all the methods related to the User authentication
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/helpers/http_exception.dart';

import '../screens/home/login_screen.dart';

import '../constants/request_url.dart' as req_url;

//Model for the User info which will be received from the server
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

//Model for Authentication info which will be stored of a user
class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  String? _role;
  String? _name;
  String? _username;

  User? _user;

  User get getUser {
    return _user!;
  }

//Method to Login the user after authentication from the server.
  Future<void> login(
      String? username, String? password, BuildContext context) async {
    final url = req_url.url('login');

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
      _name = decodedData['name'];
      _expiryDate = DateTime.now().add(
        Duration(
          milliseconds: decodedData['expiresIn'],
        ),
      );
      //Calling auto logout to start the timer for to automatically logout.
      _autoLogout(context);

      //Using Shared preferences package to store the required info for authentication in local memory.
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        'role': _role,
        'name': _name,
        'username': _username
      });
      await prefs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //Getter to get if token is present or not with some local validation.
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //Getter to authenticate if the token is present in the local memory.
  bool get isAuth {
    return _token != null;
  }

  //Method to auto login the User by checking the user info stored in the local memory.
  Future<bool> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    //Extracting the user instance from local memory and storing them in appropriate variables
    final extractedData = await json
        .decode(prefs.getString('userData') as String) as Map<String, dynamic>;
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
    final newUser =
        User(id: _userId!, name: _name!, role: _role!, username: _username!);
    _user = newUser;
    notifyListeners();

    //Calling auto logout cuz this is also kind of a login itself.
    _autoLogout(context);
    return true;
  }

  //Method for logging out the user on the User's request
  Future<void> logout(BuildContext context) async {
    //Setting all the authentication variables to null to logout.
    _token = null;
    _userId = null;
    _expiryDate = null;
    _role = null;
    _username = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    //After logout the app screen is navigated to the Login screen.
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    notifyListeners();

    //deleting the user instance stored in the memory.
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //Method to trigger autoLogout, which will start a timer from when it is called and the duration of the timer is the expiry time of the token received from the server. After the timer is up it will call the logout method.
  void _autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpire = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpire as int),
      () => logout(context),
    );
  }

  //Getter to get user role
  String? get getRole {
    // print(_role);
    return _role;
  }

  //Getter to get UserId
  String? get getUserId {
    return _userId;
  }
}
