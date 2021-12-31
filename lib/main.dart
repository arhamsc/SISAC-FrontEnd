//*package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//*screen imports
import './screens/login_screen.dart';
import 'screens/student_faculty_screens/tab_screen.dart';
import './screens/splash_screen.dart';

//*utils imports
import './utils/general/customColor.dart';
import './utils/general/themes.dart';

//*provider imports
import './providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'SISAC',
          theme: ThemeData(
              appBarTheme: AppBarThemes.appBarTheme(),
              scaffoldBackgroundColor: Palette.primaryDefault,
              textTheme: TextThemes.customText,
              elevatedButtonTheme: ButtonThemes.elevatedButton,
              bottomAppBarTheme: AppBarThemes.bottomNav()),
          home: auth.isAuth
              ? TabScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            TabScreen.routeName: (ctx) => TabScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
