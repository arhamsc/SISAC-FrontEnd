import 'package:flutter/material.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

/* Home Screen Main/Big Cards Widget */
class HomeMainCard extends StatelessWidget {
  const HomeMainCard({
    Key? key,
    required this.mainTitle,
    required this.buttonTitle,
    required this.buttonFunction,
    this.bgColor = Palette.secondaryDefault,
  }) : super(key: key);

  final String mainTitle;
  final String buttonTitle;
  final Function() buttonFunction;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.screenWidth(context) * 0.76,
      height: ScreenSize.screenHeight(context) * 0.2,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[700]!.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
          color: bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            Text(
              mainTitle,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Palette.tertiaryDefault,
                shadows: [
                  const Shadow(
                    blurRadius: 8.0,
                    color: Colors.black54,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: buttonFunction,
                    child: Text(
                      buttonTitle,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const Icon(
                    Icons.navigate_next,
                    size: 24,
                    color: Palette.tertiaryDefault,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
