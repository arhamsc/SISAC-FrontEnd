import "package:flutter/material.dart";

/* Time Table - Navigation Screen */
class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController? pageController;

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Time Table"),
    );
  }
}
