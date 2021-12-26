import 'package:flutter/material.dart';

import './customColor.dart';
import './screen_size.dart' show ScreenSize;

class TextThemes {
  static const TextTheme customText = TextTheme(
    headline6: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Palette.quinaryDefault,
    ),
    headline5: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Palette.quinaryDefault,
    ),
    bodyText1: TextStyle(
      fontFamily: "Karla",
      fontSize: 20,
      color: Palette.tertiaryDefault,
    ),
    bodyText2: TextStyle(
      fontFamily: "Karla",
      fontSize: 14,
      color: Palette.tertiaryDefault,
    ),
  );
}

class ButtonThemes {
  static ElevatedButtonThemeData elevatedButton = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Palette.secondaryDefault),
      foregroundColor: MaterialStateProperty.all(Palette.tertiaryDefault),
      textStyle: MaterialStateProperty.all(
        TextThemes.customText.bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 100,
        ),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
