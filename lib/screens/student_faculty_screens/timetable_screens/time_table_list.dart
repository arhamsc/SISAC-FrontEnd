import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:sisac/providers/announcements/announcement_providers.dart';
import 'package:sisac/providers/timetable/timetable_provider.dart';
import 'package:sisac/screens/student_faculty_screens/timetable_screens/individual_day_time_table.dart';
import 'package:sisac/utils/general/customColor.dart';
import 'package:sisac/utils/helpers/loader.dart';
import 'package:sisac/widgets/ui_widgets/cards/time_table_list_card.dart';
import "package:sizer/sizer.dart";
import 'package:sisac/widgets/component_widgets/scaffold/app_bar.dart';
import 'package:sisac/widgets/component_widgets/scaffold/bottom_nav.dart';

class TimeTableListScreen extends StatefulWidget {
  const TimeTableListScreen({Key? key}) : super(key: key);
  static const routeName = "/timetable";

  @override
  State<TimeTableListScreen> createState() => _TimeTableListScreenState();
}

class _TimeTableListScreenState extends State<TimeTableListScreen> {
  final List<String> _daysOfWeek = ["Mon", "Tue", "Wed", "Thurs", "Fri", "Sat"];

  final CarouselController _carouselController = CarouselController();
  int _pageIndexCount = 0;

  void setPageIndex(int index) => setState(
        () {
          _pageIndexCount = index;
          _carouselController.animateToPage(index);
        },
      );
  Future<void> _refreshItems(TimeTableProvider aP) async {
    setState(
      () {
        aP.fetchAllSubjects();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
    final _tTP = Provider.of<TimeTableProvider>(context, listen: false);
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
          title: "TimeTable",
          context: context,
          subtitle: _daysOfWeek[_pageIndexCount]),
      body: FutureBuilder(
        future: _tTP.fetchAllSubjects(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: SISACLoader());
          } else if (snapShot.error != null) {
            return RefreshIndicator(
              onRefresh: () => _refreshItems(_tTP),
              child: const Center(
                child: Text("Error, Pull to Refresh."),
              ),
            );
          } else {
            return Consumer<TimeTableProvider>(
              builder: (ctx, timeTableData, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ...Iterable<int>.generate(_daysOfWeek.length).map(
                          (int dayIndex) => InkWell(
                            onTap: () => setPageIndex(dayIndex),
                            child: Container(
                              alignment: Alignment.center,
                              height: 5.h,
                              width: 15.w,
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
                              child: Text(
                                _daysOfWeek[dayIndex].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    RefreshIndicator(
                      child: timeTableData.subjects.isNotEmpty
                          ? SingleChildScrollView(
                              child: CarouselSlider(
                                items: _daysOfWeek
                                    .map(
                                      (e) => IndividualDayTimeTable(
                                        day: e,
                                        dayInt: _pageIndexCount + 1,
                                        subjects: timeTableData.subjects.values
                                            .toList(),
                                      ),
                                    )
                                    .toList(),
                                options: CarouselOptions(
                                  enlargeCenterPage: false,
                                ),
                                carouselController: _carouselController,
                              ),
                            )
                          : const Center(child: Text("No Classes")),
                      onRefresh: () => _refreshItems(timeTableData),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        pageController: _pageController,
        isSelected: "TimeTable",
      ),
    );
  }
}
