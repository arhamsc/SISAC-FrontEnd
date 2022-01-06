import "package:flutter/material.dart";

class TimeTableScreen extends StatefulWidget {
  TimeTableScreen({Key? key, required this.pageController}) : super(key: key);
    PageController? pageController;

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Time Table"),)
    );
  }
}