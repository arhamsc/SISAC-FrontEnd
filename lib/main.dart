//*package imports
import 'package:flutter/material.dart';

//*screen imports
import './screens/login_screen.dart';

//*utils imports
import './utils/general/customColor.dart';
import './utils/general/text_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Palette.senaryDefault),
        scaffoldBackgroundColor: Palette.primaryDefault,
        textTheme: TextThemes.customText,
      ),
      home: LoginScreen(),
    );
  }
}
