//*package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/providers/cafetaria/cafataria_providers.dart';

//*screen imports
import './screens/login_screen.dart';
import 'screens/student_faculty_screens/tab_screen.dart';
import './screens/splash_screen.dart';
import './screens/student_faculty_screens/cafetaria_screens/cafetaria_menu.dart';
import './screens/student_faculty_screens/cafetaria_screens/place_order_screen.dart';
import './screens/student_faculty_screens/cafetaria_screens/order_screen.dart';
import './screens/student_faculty_screens/cafetaria_screens/rating_screen.dart';
import './screens/other_sceens/restaurant_home_screen.dart';
import './screens/other_sceens/received_orders_screen.dart';

//*utils imports
import './utils/general/customColor.dart';
import './utils/general/themes.dart';

//*provider imports
import './providers/user_provider.dart';
import './providers/cafetaria/cafataria_providers.dart';
import './providers/cafetaria/order_providers.dart';
import './providers/cafetaria/restaurant_providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget HomeScreen(Auth func) {
      if (func.isAuth) {
        if (func.getRole == 'Other') {
          return RestaurantHomeScreen();
        } else {
          return TabScreen();
        }
      } else {
        return FutureBuilder(
          future: func.tryAutoLogin(),
          builder: (ctx, authResultSnapShot) =>
              authResultSnapShot.connectionState == ConnectionState.waiting
                  ? const SplashScreen()
                  : const LoginScreen(),
        );
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, MenuItemProvider>(
          create: (context) => MenuItemProvider(),
          update: (ctx, authProvider, menuItemProvider) => menuItemProvider!
            ..update(
              authProvider.token,
              authProvider.getUserId,
            ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: (context) => OrderProvider(),
          update: (ctx, authProvider, orderProvider) => orderProvider!
            ..update(authProvider.token, authProvider.getUserId),
        ),
        ChangeNotifierProxyProvider2<Auth, MenuItemProvider,
            RestaurantProvider>(
          create: (context) => RestaurantProvider(),
          update: (ctx, authProvider, menuItemProvider, restaurantProvider) =>
              restaurantProvider!
                ..update(authProvider.token, authProvider.getUserId,
                    menuItemProvider),
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
          home: HomeScreen(auth),
          routes: {
            TabScreen.routeName: (ctx) => const TabScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            CafetariaMenu.routeName: (ctx) => const CafetariaMenu(),
            PlaceOrderScreen.routeName: (ctx) => const PlaceOrderScreen(),
            OrderScreen.routeName: (ctx) => const OrderScreen(),
            RatingScreen.routeName: (ctx) => const RatingScreen(),
            RestaurantHomeScreen.routeName: (ctx) =>
                const RestaurantHomeScreen(),
            ReceivedOrdersScreen.routeName: (ctx) =>
                const ReceivedOrdersScreen(),
          },
        ),
      ),
    );
  }
}
