import 'package:flutter/material.dart';

import '../../../utils/general/themes.dart';
import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart';

/* Small Elevated Button */
Widget smallEleBtn({
  required BuildContext context,
  required String title,
  required Function onPressFunc,
  bool? showSecondaryColor,
}) {
  return SizedBox(
    height: ScreenSize.screenHeight(context) * .02,
    width: ScreenSize.screenWidth(context) * .177,
    child: ElevatedButton(
      onPressed: () {
        onPressFunc();
      },
      child: Text(
        title,
        softWrap: false,
      ),
      style: ButtonThemes.elevatedButtonSmall.copyWith(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 5,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          showSecondaryColor != null
              ? showSecondaryColor
                  ? Palette.quaternaryDefault
                  : SecondaryPallete.quaternary
              : Palette.quaternaryDefault,
        ),
      ),
    ),
  );
}
