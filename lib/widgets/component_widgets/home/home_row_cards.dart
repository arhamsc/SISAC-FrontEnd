import 'package:flutter/material.dart';

import '../../../utils/general/screen_size.dart';
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
          const SizedBox(width: 10),
          //Workshop Card
          RowCard(
            title: "Workshops/Seminars",
            gestureFunction: () {},
          ),
          const SizedBox(width: 10),
          //Announcement Card
          RowCard(
            title: "Announcement",
            gestureFunction: () => widget.pageController.animateToPage(
              1,
              duration: const Duration(microseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(width: 10),
          //Resources Card
          RowCard(
            title: "Resources",
            gestureFunction: () {},
          ),
          const SizedBox(width: 10),
          //Stationary Card
          RowCard(
            title: "Stationary",
            gestureFunction: () => widget.pageController.animateToPage(
              3,
              duration: const Duration(microseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(width: 10),
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
      onPressed: () {
        widget.gestureFunction();
      },
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        width: ScreenSize.screenWidth(context) * .37,
        height: ScreenSize.screenHeight(context) * .15,
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
