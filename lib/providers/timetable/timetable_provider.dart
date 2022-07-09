import 'package:sisac/constants/request_url.dart';
import "package:http/http.dart" as http;
import 'package:sisac/providers/user_provider.dart' show User;
import 'package:sisac/utils/helpers/http_exception.dart';

import "./models/faculties_models.dart";
import "./models/timetable_models.dart";

import "package:flutter/material.dart";

class TimeTableProvider with ChangeNotifier {
  Map<String, Subject> _subjects = {};
  List<Session> _sessions = [];
  List<Faculty> _facultiesIncharge = [];

  String _authToken = "";

  void update(token) {
    token != null ? _authToken = token : _authToken = "";
  }

  Uri _timeTableUrl([String? endPoint = '']) {
    return url("timetable/${endPoint ?? ""}");
  }

  Map<String, String> get _headers {
    return headers(_authToken);
  }

  Map<String, Subject> get subjects {
    return {..._subjects};
  }

  Future<void> fetchAllSubjects() async {
    final url = _timeTableUrl();
    try {
      final response = await http.get(url, headers: _headers);
      var decodedData = checkResponseError(response);
      Map<String, Subject> _loadedSubjects = {};
      List<Session> _loadedSessions = [];
      List<Faculty> _loadedFacultiesIncharge = [];
      decodedData.forEach(
        (key, value) {
          // ignore: avoid_function_literals_in_foreach_calls
          (value["sessions"] as List<dynamic>).forEach(
            (element) {
              _loadedSessions.add(
                Session(
                  id: element["_id"],
                  subject: element["subject"],
                  dateAndTime: DateTime.parse(element["dateAndTime"]),
                  duration: element["duration"],
                  semester: element["semester"],
                  section: element["section"],
                  createdOn: DateTime.parse(element["createdOn"]),
                  editedOn: element["editedOn"] != null
                      ? DateTime.parse(element["editedOn"])
                      : null,
                ),
              );
            },
          );

          value["facultiesIncharge"].forEach(
            (element) {
              _loadedFacultiesIncharge.add(
                Faculty(
                  user: User(
                    id: element["user"]["_id"],
                    username: element["user"]["username"],
                    role: element["user"]["role"],
                    name: element["user"]["name"],
                  ),
                  department: element["department"],
                  facultyAssignments:
                      List<String>.from(element["facultyAssignments"]),
                  createdOn: DateTime.parse(element["createdOn"]),
                  editedOn: element["editedOn"] != null
                      ? DateTime.parse(element["editedOn"])
                      : null,
                ),
              );
            },
          );

          _loadedSubjects[key] = Subject(
            id: value["_id"],
            code: value["code"],
            name: value["name"],
            type: value["type"],
            acronym: value["acronym"],
            branch: value["branch"],
            syllabusDocUrl: value["syllabusDocUrl"],
            syllabusDocFileName: value["syllabusDocFileName"],
            syllabusDocOriginalName: value["syllabusDocOriginalName"],
            sessions: _loadedSessions,
            facultiesIncharge: _loadedFacultiesIncharge,
            createdOn: DateTime.parse(value["createdOn"]),
            editedOn: value["editedOn"] != null
                ? DateTime.parse(value["editedOn"])
                : null,
          );
        },
      );
      _subjects = _loadedSubjects;
      _sessions = _loadedSessions;
      _facultiesIncharge = _loadedFacultiesIncharge;
    } catch (error) {
      throw HttpException(error.toString());
    }
    notifyListeners();
  }
}
