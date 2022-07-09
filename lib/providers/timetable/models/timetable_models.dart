import "./faculties_models.dart" show Faculty;

class Session {
  final String id;
  final String subject;
  final DateTime dateAndTime;
  final int duration;
  final int semester;
  final String section;
  final DateTime createdOn;
  final DateTime? editedOn;
  Session({
    required this.id,
    required this.subject,
    required this.dateAndTime,
    required this.duration,
    required this.semester,
    required this.section,
    required this.createdOn,
    this.editedOn,
  });
}

class Subject {
  final String id;
  final String code;
  final String name;
  final String type;
  final String acronym;
  final String branch;
  final String syllabusDocUrl;
  final String syllabusDocFileName;
  final String syllabusDocOriginalName;
  final List<Session> sessions;
  final List<Faculty> facultiesIncharge;
  final DateTime createdOn;
  final DateTime? editedOn;
  Subject({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.acronym,
    required this.branch,
    required this.syllabusDocUrl,
    required this.syllabusDocFileName,
    required this.syllabusDocOriginalName,
    required this.sessions,
    required this.facultiesIncharge,
    required this.createdOn,
    this.editedOn,
  });
}
