import "package:flutter/material.dart";
import "package:sizer/sizer.dart";
import 'package:provider/provider.dart';
import 'package:sisac/providers/timetable/timetable_provider.dart';
import 'package:sisac/utils/general/customColor.dart';
import 'package:sisac/widgets/ui_widgets/buttons/small_button.dart';

class TimeTableListCard extends StatelessWidget {
  const TimeTableListCard({
    Key? key,
    required this.subjectTitle,
    required this.duration,
    required this.time,
    required this.day,
    required this.subjectCode,
    required this.facultyIncharge,
    required this.viewMoreFunc,
    required this.subjectIcon,
  }) : super(key: key);

  final String subjectTitle;
  final int duration;
  final String time;
  final String day;
  final String subjectCode;
  final String facultyIncharge;
  final Function viewMoreFunc;
  final IconData subjectIcon;

  @override
  Widget build(BuildContext context) {
    final timeP = Provider.of<TimeTableProvider>(context);
    return Container(
      height: 10.7.h,
      width: 90.w,
      decoration: BoxDecoration(
        color: SecondaryPallete.primary,
        borderRadius: BorderRadius.circular(2.w),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black54,
            spreadRadius: 2,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 2.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subjectTitle,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
              ),
              Icon(
                subjectIcon,
                color: Palette.quinaryDefault,
                size: 18.sp,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
              ),
              Text(facultyIncharge)
            ],
          ),
          Text(subjectCode),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              smallEleBtn(
                context: context,
                title: "View More",
                onPressFunc: () => viewMoreFunc(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
