import 'package:flutter/material.dart';

import './customColor.dart';

/* Custom Theme setting for Typography and Buttons */
//Typography Themes
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
    headline4: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 30,
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

//Button Themes
class ButtonThemes {
  //Normal Elevated Button Style
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
  
  //Small Elevated Button Style
  static ButtonStyle elevatedButtonSmall = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Palette.secondaryDefault),
    foregroundColor: MaterialStateProperty.all(Palette.tertiaryDefault),
    textStyle: MaterialStateProperty.all(
      TextThemes.customText.bodyText2!.copyWith(fontSize: 11),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 15,
      ),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  //Input Elevated Button Style
  static ButtonStyle elevatedButtonInput = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Palette.quaternaryDefault),
    foregroundColor: MaterialStateProperty.all(Palette.quinaryDefault),
    textStyle: MaterialStateProperty.all(
      TextThemes.customText.bodyText2!.copyWith(fontSize: 15),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 20,
      ),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  //Confirmation Elevated Button Style
  static ButtonStyle elevatedButtonConfirmation = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Palette.quaternaryDefault),
    foregroundColor: MaterialStateProperty.all(Palette.quinaryDefault),
    textStyle: MaterialStateProperty.all(
      TextThemes.customText.bodyText1?.copyWith(fontWeight: FontWeight.bold),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

//AppBar Theme
class AppBarThemes {
  static AppBarTheme appBarTheme() {
    return AppBarTheme(
      iconTheme: const IconThemeData(color: Palette.quinaryDefault, size: 24),
      titleTextStyle: TextThemes.customText.headline4,
      backgroundColor: Palette.senaryDefault,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      centerTitle: false,
    );
  }

  static BottomAppBarTheme bottomNav() {
    return const BottomAppBarTheme(
      color: Palette.senaryDefault,
    );
  }
}
