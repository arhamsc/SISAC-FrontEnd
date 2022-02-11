import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/general/customColor.dart';

/* Home Screen Small Row Cards */
class HomeRowCards extends StatefulWidget {
  const HomeRowCards({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  State<HomeRowCards> createState() => _HomeRowCardsState();
}

class _HomeRowCardsState extends State<HomeRowCards> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 2.3.w),
          //Workshop Card
          RowCard(
            title: "Workshops/Seminars",
            gestureFunction: () {},
          ),
          SizedBox(width: 2.3.w),
          //Announcement Card
          RowCard(
            title: "Announcement",
            gestureFunction: () => widget.pageController.animateToPage(
              1,
              duration: const Duration(microseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          SizedBox(width: 2.3.w),
          //Resources Card
          RowCard(
            title: "Resources",
            gestureFunction: () {},
          ),
          SizedBox(width: 2.3.w),
          //Stationary Card
          RowCard(
            title: "Stationary",
            gestureFunction: () => widget.pageController.animateToPage(
              3,
              duration: const Duration(microseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          SizedBox(width: 2.3.w),
        ],
      ),
    );
  }
}

/* Individual Row Card WIdget */
class RowCard extends StatefulWidget {
  const RowCard({
    Key? key,
    required this.title,
    required this.gestureFunction,
  }) : super(key: key);

  final String title;
  final Function gestureFunction;

  @override
  State<RowCard> createState() => _RowCardState();
}

class _RowCardState extends State<RowCard> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.gestureFunction(),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        width: 40.w,
        height: 15.h,
        decoration: BoxDecoration(
          color: Palette.quinaryDefault,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline5!.copyWith(
              color: SecondaryPallete.secondary,
              shadows: [
                const Shadow(
                  blurRadius: 8.0,
                  color: Colors.black54,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
