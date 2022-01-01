import 'package:flutter/material.dart';

import '../../utils/general/screen_size.dart';
import '../../utils/general/customColor.dart';

class HomeRowCards extends StatelessWidget {
  const HomeRowCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            RowCard(
              title: "Workshops/Seminars",
              gestureFunction: () {},
            ),
            const SizedBox(width: 10),
            RowCard(
              title: "Announcement",
              gestureFunction: () {},
            ),
            const SizedBox(width: 10),
            RowCard(
              title: "Resources",
              gestureFunction: () {},
            ),
            const SizedBox(width: 10),
            RowCard(
              title: "Stationary",
              gestureFunction: () {},
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class RowCard extends StatelessWidget {
  const RowCard({
    Key? key,
    required this.title,
    required this.gestureFunction,
  }) : super(key: key);

  final String title;
  final Function gestureFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => gestureFunction,
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
            title,
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
