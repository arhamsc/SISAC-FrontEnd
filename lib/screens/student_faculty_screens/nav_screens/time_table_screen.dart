import "package:flutter/material.dart";
import 'package:sisac/screens/student_faculty_screens/timetable_screens/time_table_list.dart';
import 'package:sisac/utils/general/customColor.dart';

import 'package:sisac/widgets/component_widgets/home/home_main_card.dart';

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeMainCard(
            mainTitle: "View TimeTable",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                TimeTableListScreen.routeName,
                arguments: widget.pageController,
              );
            },
            bgColor: SecondaryPallete.primary,
          ),
          HomeMainCard(
            mainTitle: "Extra Classes",
            buttonTitle: "Click to visit",
            buttonFunction: () {},
            bgColor: SecondaryPallete.primary,
          ),
          HomeMainCard(
            mainTitle: "Lab Timetable",
            buttonTitle: "Click to visit",
            buttonFunction: () {},
            bgColor: SecondaryPallete.primary,
          ),
        ],
      ),
    );
  }
}
