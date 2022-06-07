import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/request_url.dart' as req_url;
import '../../utils/helpers/http_exception.dart';

class Announcement {
  final String id;
  final String byUser;
  final String title;
  final String description;
  final String? posterUrl;
  final String? posterFileName;
  final DateTime createdOn;
  final bool edited;
  final DateTime? modifiedOn;
  final List<String>? links;
  final String level;
  final String? department;
  Announcement({
    required this.id,
    required this.byUser,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.posterFileName,
    required this.createdOn,
    required this.edited,
    required this.modifiedOn,
    required this.links,
    required this.level,
    required this.department,
  });
}

class AnnouncementProvider with ChangeNotifier {
  String _authToken = "";

  Map<String, Announcement> _announcements = {};

  void update(token) {
    token != "" ? _authToken = token : _authToken = "";
  }

  Map<String, Announcement> get announcements {
    return {..._announcements};
  }

  Uri _announcementUrl([String? endPoint = '']) {
    return req_url.url('announcement/${endPoint ?? ""}');
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'secret_token': _authToken,
    };
  }

  Future<void> fetchAllAnnouncements() async {
    final url = _announcementUrl();
    try {
      final response = await http.get(url, headers: _headers);
      var decodedData = req_url.checkResponseError(response);
      Map<String, Announcement> receivedAnnouncements = {};

      decodedData.forEach(
        (key, value) => receivedAnnouncements[key] = Announcement(
          id: value['_id'],
          byUser: value['byUser'],
          title: value['title'],
          description: value['description'],
          posterUrl: value['posterUrl'],
          posterFileName: value['posterFileName'],
          createdOn: DateTime.parse(value['createdOn']),
          edited: value['edited'],
          modifiedOn: value['modifiedOn'] != null
              ? DateTime.parse(value['modifiedOn'])
              : null,
          links: value['links'].length != 0 ? List.from(value['links']) : null,
          level: value['level'],
          department: value['department'],
        ),
      );
      _announcements = receivedAnnouncements;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
