//THIS IS THE MAIN FILE OF THE PROJECT.

/* Package imports */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/providers/cafetaria/cafetaria_providers.dart';

/* Screen imports */
//Home Screens
import 'screens/home/login_screen.dart';
import 'screens/student_faculty_screens/nav_screens/tab_screen.dart';
import 'screens/home/splash_screen.dart';
//Cafetaria Screens - Consumer
import 'screens/student_faculty_screens/cafetaria_screens/parent_screens/cafetaria_menu.dart';
import 'screens/student_faculty_screens/cafetaria_screens/functional_screens/place_order_screen.dart';
import 'screens/student_faculty_screens/cafetaria_screens/parent_screens/order_screen.dart';
import 'screens/student_faculty_screens/cafetaria_screens/parent_screens/rating_screen.dart';
import 'screens/student_faculty_screens/cafetaria_screens/functional_screens/cart_screen.dart';
//Cafetaria Screens - Restaurant
import 'screens/other_screens/restaurant_screens/parent_screens/restaurant_home_screen.dart';
import 'screens/other_screens/restaurant_screens/parent_screens/received_orders_screen.dart';
import 'screens/other_screens/restaurant_screens/parent_screens/isAvailable_screen.dart';
import 'screens/other_screens/restaurant_screens/updation_screens/add_edit_menuItem_screen.dart';
//Stationary Screens - Consumer
import './screens/student_faculty_screens/stationary/availability_screen.dart';
import './screens/student_faculty_screens/stationary/books_material_screen.dart';
import './screens/student_faculty_screens/stationary/material_available_screen.dart';
//Stationary Screens - Vendor
import './screens/other_screens/stationary_screens/parent_screens/stationary_home_screen.dart';
import './screens/other_screens/stationary_screens/parent_screens/update_availability_screen.dart';

/* Utility imports */
import './utils/general/customColor.dart';
import './utils/general/themes.dart';

/* Provider imports */
import './providers/user_provider.dart';
import 'providers/cafetaria/cafetaria_providers.dart';
import './providers/cafetaria/order_providers.dart';
import './providers/cafetaria/restaurant_providers.dart';
import './providers/stationary/availability_providers.dart';
import './providers/stationary/books_material_providers.dart';
import './providers/stationary/material_available_providers.dart';
import './providers/cafetaria/cart_provider.dart';

//Main function of the app, dart syntax. It is where the execution begins, similar to C.
void main() {
  runApp(const MyApp());
}

//this is the ROOT widget which contains all our themes, routes, provider declarations and home screen.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Below the multiple providers used in this project
    return MultiProvider(
      providers: [
        //Auth provider, it is also the base of all other providers as we pass the login token to other providers also
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
        //these providers depend on Auth provider
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
                ..update(
                  authProvider.token,
                  authProvider.getUserId,
                ),
        ),
        ChangeNotifierProxyProvider<Auth, AvailabilityProvider>(
          create: (ctx) => AvailabilityProvider(),
          update: (ctx, authData, availabilityData) => availabilityData!
            ..update(
              authData.token,
              authData.getUserId,
            ),
        ),
        ChangeNotifierProxyProvider<Auth, BooksMaterialProvider>(
          create: (ctx) => BooksMaterialProvider(),
          update: (ctx, authData, booksMaterialData) => booksMaterialData!
            ..update(
              authData.token,
              authData.getUserId,
            ),
        ),
        ChangeNotifierProxyProvider<Auth, MaterialAvailableProvider>(
          create: (ctx) => MaterialAvailableProvider(),
          update: (ctx, authData, materialAvailableData) =>
              materialAvailableData!
                ..update(
                  authData.token,
                  authData.getUserId,
                ),
        ),
        ChangeNotifierProxyProvider<Auth, CartProvider>(
          create: (ctx) => CartProvider(),
          update: (ctx, authData, cartData) => cartData!
            ..update(
              authData.token,
              authData.getUserId,
            ),
        )
      ],
      //Consumer auth is from Provider package
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'SISAC',
          //below is the Theme data for the app, the actual specification in defined in Utility -> General folder.
          theme: ThemeData(
            appBarTheme: AppBarThemes.appBarTheme(),
            scaffoldBackgroundColor: Palette.primaryDefault,
            textTheme: TextThemes.customText,
            elevatedButtonTheme: ButtonThemes.elevatedButton,
            bottomAppBarTheme: AppBarThemes.bottomNav(),
          ),
          //below is the home route or the home page
          home: HomePage(auth: auth),
          //All the named routes are declared here.
          routes: {
            //Home Screen Routes
            TabScreen.routeName: (ctx) => const TabScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            RestaurantHomeScreen.routeName: (ctx) =>
                const RestaurantHomeScreen(),
            StationaryHomeScreen.routeName: (ctx) =>
                const StationaryHomeScreen(),
            //Cafetaria Screens - Consumer Routes
            CafetariaMenu.routeName: (ctx) => const CafetariaMenu(),
            PlaceOrderScreen.routeName: (ctx) => const PlaceOrderScreen(),
            OrderScreen.routeName: (ctx) => const OrderScreen(),
            RatingScreen.routeName: (ctx) => const RatingScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            //Cafetaria Screens - Vendor Routes
            ReceivedOrdersScreen.routeName: (ctx) =>
                const ReceivedOrdersScreen(),
            IsAvailableScreen.routeName: (ctx) => const IsAvailableScreen(),
            AddEditMenuItemScreen.routeName: (ctx) =>
                const AddEditMenuItemScreen(),
            //Stationary Screens - Consumer Routes
            AvailabilityScreen.routeName: (ctx) => const AvailabilityScreen(),
            BooksMaterialScreen.routeName: (ctx) => const BooksMaterialScreen(),
            MaterialAvailableScreen.routeName: (ctx) =>
                const MaterialAvailableScreen(),
            //Stationary Screens - Vendor Routes
            UpdateAvailabilityScreen.routeName: (ctx) =>
                const UpdateAvailabilityScreen(),
          },
        ),
      ),
    );
  }
}

//This is the Sub Root widget which will render the required screen according to the conditions
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final Auth auth;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget ScreenByRole(String role) {
    switch (role) {
      case "Other":
        return const RestaurantHomeScreen();
      case "Stationary":
        return const StationaryHomeScreen();
      default:
        return const TabScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.auth.isAuth
        ? ScreenByRole(widget.auth.getRole ?? "Student")
        : FutureBuilder(
            future: widget.auth.tryAutoLogin(context),
            builder: (ctx, authResultSnapShot) =>
                authResultSnapShot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const LoginScreen(),
          );
  }
}
