//This contains all the methods related to the User authentication
import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/helpers/http_exception.dart';

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
  String? _refreshToken;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  String? _role;
  String? _name;
  String? _username;
  String? _fcmToken;

  User? _user;

  User get getUser {
    return _user!;
  }

  String get fcmToken {
    return _fcmToken ?? '';
  }

  //Getter to get user role
  String? get getRole {
    return _role;
  }

  //Getter to get UserId
  String? get getUserId {
    return _userId;
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

  Future<void> produceFCMToken() async {
    final fcm = FirebaseMessaging.instance;
    final pushToken = await fcm.getToken();
    //For IOS
    fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _fcmToken = pushToken;
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
          'fcmToken':
              _fcmToken!, //sending the Cloud Messaging Token to store in database
        },
      ).timeout(const Duration(seconds: 20));

      //below the data is being decoded from the response
      final decodedData = req_url.checkResponseError(response);
      //creating a new user to store it locally in the list to access the role and token
      final newUser = User(
        id: decodedData['id'],
        username: decodedData['username'],
        role: decodedData['role'],
        name: decodedData['name'],
      );
      _user = newUser;
      _token = decodedData['token'];
      _refreshToken = decodedData['refreshToken'];
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
      autoLogout(context);

      //Using Shared preferences package to store the required info for authentication in local memory.
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'refreshToken': _refreshToken,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        'role': _role,
        'name': _name,
        'username': _username
      });
      await prefs.setString('userData', userData);
      notifyListeners();
    } on SocketException catch (_) {
      throw HttpException("Server Down");
    } on TimeoutException catch (_) {
      throw HttpException("Failed to get response from the server");
    } catch (error) {
      rethrow;
    }
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
    _refreshToken = extractedData['refreshToken'] as String;
    _role = extractedData['role'] as String;
    _name = extractedData['name'] as String;
    _username = extractedData['username'] as String;
    _expiryDate = expiryDate;
    final newUser = User(
      id: _userId!,
      name: _name!,
      role: _role!,
      username: _username!,
    );
    _user = newUser;
    notifyListeners();

    //Calling auto logout cuz this is also kind of a login itself.
    autoLogout(context);
    return true;
  }

  //Method for logging out the user on the User's request
  Future<void> logout(BuildContext context) async {
    final url = req_url.url('logout');
    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'secret_token': _token ?? '',
      });
      final res = req_url.checkResponseError(response);

      print(res);

      //After logout the app screen is navigated to the Login screen.
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
      //Setting all the authentication variables to null to logout.
      _token = null;
      _refreshToken = null;
      _userId = null;
      _expiryDate = null;
      _role = null;
      _username = null;
      _fcmToken = null; //need not save in shared preferences

      await FirebaseMessaging.instance.deleteToken();

      if (_authTimer != null) {
        _authTimer!.cancel();
        _authTimer = null;
      }

      produceFCMToken();
      notifyListeners();

      //deleting the user instance stored in the memory.
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  //Method to trigger autoLogout, which will start a timer from when it is called and the duration of the timer is the expiry time of the token received from the server. After the timer is up it will call the logout method.
  void autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpire as int),
      () => {refreshTokenLogin(context)},
    );
  }

  Future<void> refreshTokenLogin(BuildContext context) async {
    final url = req_url.url('refreshToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'refreshToken': _refreshToken,
          },
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final decodedData = req_url.checkResponseError(response);
      //creating a new user to store it locally in the list to access the role and token
      final newUser = User(
        id: decodedData['id'],
        username: decodedData['username'],
        role: decodedData['role'],
        name: decodedData['name'],
      );
      _user = newUser;
      _token = decodedData['token'];
      _refreshToken = decodedData['refreshToken'];
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
      autoLogout(context);

      //Using Shared preferences package to store the required info for authentication in local memory.
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'refreshToken': _refreshToken,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        'role': _role,
        'name': _name,
        'username': _username
      });
      await prefs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      logout(context);
      throw HttpException(error.toString());
    }
  }
}
