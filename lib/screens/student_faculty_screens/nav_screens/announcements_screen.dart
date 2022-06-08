import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../student_faculty_screens/announcement_screens/all_announcements_screen.dart';
import "package:sizer/sizer.dart";

import '../../../providers/user_provider.dart';

import '../../../utils/general/themes.dart';
import '../../../widgets/component_widgets/announcements/level_card.dart';

/* Announcements - Navigation Screen */
class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController? pageController;
  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  //TODO: IF faculty or staff then instead of class display their announcement
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> levels = [
      {
        'title': 'All Announcements',
        'function': () {
          Navigator.pushNamed(
            context,
            AllAnnouncementScreen.routeName,
            arguments: {'controller': widget.pageController, 'level': 'All'},
          );
        },
      },
      {
        'title': 'College',
        'function': () {
          Navigator.pushNamed(
            context,
            AllAnnouncementScreen.routeName,
            arguments: {
              'controller': widget.pageController,
              'level': 'College'
            },
          );
        },
      },
      {
        'title': 'Department',
        'function': () {
          Navigator.pushNamed(
            context,
            AllAnnouncementScreen.routeName,
            arguments: {
              'controller': widget.pageController,
              'level': 'Department'
            },
          );
        },
      },
      {
        'title': 'Class',
        'function': () {
          Navigator.pushNamed(
            context,
            AllAnnouncementScreen.routeName,
            arguments: {'controller': widget.pageController, 'level': 'Class'},
          );
        },
      },
      {
        'title': 'Placements',
        'function': () {
          Navigator.pushNamed(
            context,
            AllAnnouncementScreen.routeName,
            arguments: {
              'controller': widget.pageController,
              'level': 'Placements'
            },
          );
        },
      },
    ];
    final authP = Provider.of<Auth>(context, listen: false);
    final role = authP.getRole;
    return Center(
      child: Column(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: SizedBox(
                width: 80.w,
                child: ListView.builder(
                  itemBuilder: (ctx, i) => LevelCard(
                    title: levels[i]['title'],
                    onCardTap: levels[i]['function'],
                  ),
                  itemCount: levels.length,
                ),
              ),
            ),
          ),
          role != "Student"
              ? Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Make Announcement",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    style: ButtonThemes.elevatedButtonInput.copyWith(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 10.sp,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
