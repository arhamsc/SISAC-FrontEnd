import 'package:sisac/providers/user_provider.dart';

class Faculty {
  final User user;
  final String department;
  final List<String> facultyAssignments;
  final DateTime createdOn;
  final DateTime? editedOn;
  Faculty({
    required this.user,
    required this.department,
    required this.facultyAssignments,
    required this.createdOn,
    this.editedOn,
  });
}

class FacultyAssignment {
  final Faculty faculty;
  final int assignedSemester;
  final String assignedDepartment;
  final String assignedSection;
  final String assignmentType;
  final DateTime createdOn;
  final DateTime? editedOn;
  FacultyAssignment({
    required this.faculty,
    required this.assignedSemester,
    required this.assignedDepartment,
    required this.assignedSection,
    required this.assignmentType,
    required this.createdOn,
    this.editedOn,
  });
}
