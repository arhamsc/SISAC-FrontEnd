import "package:flutter/material.dart";
import 'package:sisac/providers/timetable/models/timetable_models.dart';
import 'package:sisac/widgets/ui_widgets/cards/time_table_list_card.dart';

class IndividualDayTimeTable extends StatefulWidget {
  const IndividualDayTimeTable(
      {Key? key,
      required this.day,
      required this.subjects,
      required this.dayInt})
      : super(key: key);
  final String day;
  final List<Subject> subjects;
  final int dayInt;

  @override
  State<IndividualDayTimeTable> createState() => _IndividualDayTimeTableState();
}

class _IndividualDayTimeTableState extends State<IndividualDayTimeTable> {
  List<Subject> _subjectsOnDay = [];
  List<Session> _sessionsOnDay = [];

  @override
  Widget build(BuildContext context) {
    widget.subjects.forEach((sub) {
      sub.sessions.forEach((session) {
        if (session.dateAndTime.weekday == widget.dayInt) {
          _subjectsOnDay.add(sub);
          _sessionsOnDay.add(session);
        }
      });
    });

    return ListView.builder(
      itemBuilder: (ctx, index) => TimeTableListCard(
        subjectTitle: "Data Communication ${widget.day}",
        subjectCode: "18CS43",
        facultyIncharge: "Dr. Arun Kumar",
        duration: 1,
        day: widget.day,
        subjectIcon: Icons.rss_feed,
        viewMoreFunc: () => print(_sessionsOnDay),
        time: "8:30 to 9:30 PM",
      ),
      itemCount: 2,
    );
  }
}
