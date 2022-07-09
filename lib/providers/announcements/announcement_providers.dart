import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../constants/request_url.dart' as req_url;
import '../../utils/helpers/http_exception.dart';
import '../user_provider.dart' show User;

class Announcement {
  final String id;
  final User byUser;
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
  String _userId = "";

  Map<String, Announcement> _announcements = {};

  void update(token, username) {
    token != null ? _authToken = token : _authToken = "";
    username != null ? _userId = username : _userId = "";
  }

  Map<String, Announcement> get announcements {
    return {..._announcements};
  }

  Uri _announcementUrl([String? endPoint = '']) {
    return req_url.url('announcement/${endPoint ?? ""}');
  }

  Map<String, String> get _headers {
    return req_url.headers(_authToken);
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
          byUser: User(
            id: value['byUser']['_id'],
            name: value['byUser']['name'],
            username: value['byUser']['username'],
            role: value['byUser']['role'],
          ),
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
    notifyListeners();
  }

  Map<String, Announcement> announcementByLevel(String level) {
    Map<String, Announcement> _filteredAnnouncements = _announcements;
    _filteredAnnouncements.removeWhere((key, value) => value.level != level);
    return _filteredAnnouncements; //this is due to the removeWhere method performing the iteration on the Map itself and not returning a new Map.
  }

  Future<void> makeAnnouncement({
    required String title,
    required String description,
    required String level,
    String? department,
    File? poster,
  }) async {
    final url = _announcementUrl();
    try {
      if (poster == null) {
        await http.post(
          url,
          headers: _headers,
          body: jsonEncode({
            'announcement': {
              'title': title,
              'description': description,
              'level': level,
              'department': department
            },
          }),
        );
      } else {
        var req = http.MultipartRequest('POST', url);
        req.files.add(
          http.MultipartFile(
            'poster',
            poster.readAsBytes().asStream(),
            poster.lengthSync(),
            filename: poster.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );

        req.headers.addAll(_headers);

        req.fields.addAll(
          {
            'announcement[title]': title,
            'announcement[description]': title,
            'announcement[level]': level,
            'announcement[department]': department ?? ""
          },
        );

        await req.send();
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  //to check if author of the announcement

  bool isAnnouncementAuthor(String announcementId) {
    Announcement? _foundAnn = _announcements[announcementId];
    return _foundAnn?.byUser.id == _userId;
  }

  Future<void> editAnnouncement(
      {required String id,
      required String title,
      required String description,
      required String level,
      String? department,
      File? poster}) async {
    final url = _announcementUrl(id);
    try {
      if (poster == null) {
        await http.patch(
          url,
          headers: _headers,
          body: jsonEncode(
            {
              'announcement': {
                'title': title,
                'description': description,
                'level': level,
                'department': department
              },
            },
          ),
        );
      } else {
        var req = http.MultipartRequest('PATCH', url);
        req.files.add(
          http.MultipartFile(
            'poster',
            poster.readAsBytes().asStream(),
            poster.lengthSync(),
            filename: poster.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );

        req.headers.addAll(_headers);

        req.fields.addAll(
          {
            'announcement[title]': title,
            'announcement[description]': title,
            'announcement[level]': level,
            'announcement[department]': department ?? ""
          },
        );

        await req.send();
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final url = _announcementUrl(id);
    try {
      await http.delete(url, headers: _headers);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
