//THIS IS THE MAIN FILE OF THE PROJECT.

/* Package imports */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/providers/cafetaria/cafetaria_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
import './screens/other_screens/stationary_screens/parent_screens/books_material_screen.dart';
import 'screens/other_screens/stationary_screens/updation_screens/add_edit_book_screen.dart';
import './screens/other_screens/stationary_screens/parent_screens/material_available_screen.dart';
import './screens/other_screens/stationary_screens/updation_screens/add_edit_material_available_screen.dart';

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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

/* Root Widget */
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /* Multiple Providers registered to handle state */
    return MultiProvider(
      providers: [
        /* Base Auth Provider to supply token to other Providers */
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
        /* Other Providers but dependent on Auth Provider for Token */
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
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SISAC',
          /* App Theme Data - Individual Config in theme.dart and customColor.dart */
          theme: ThemeData(
            appBarTheme: AppBarThemes.appBarTheme(),
            scaffoldBackgroundColor: Palette.primaryDefault,
            textTheme: TextThemes.customText,
            elevatedButtonTheme: ButtonThemes.elevatedButton,
            bottomAppBarTheme: AppBarThemes.bottomNav(),
          ),
          /* Home Page Widget */
          home: HomePage(auth: auth),
          /* Named Routes Registering */
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
            VendorBooksMaterialScreen.routeName: (ctx) =>
                const VendorBooksMaterialScreen(),
            AddEditStationaryItemScreen.routeName: (ctx) =>
                const AddEditStationaryItemScreen(),
            VendorMaterialAvailableScreen.routeName: (ctx) =>
                const VendorMaterialAvailableScreen(),
            AddEditMaterialAvailableScreen.routeName: (ctx) =>
                const AddEditMaterialAvailableScreen(),
          },
        ),
      ),
    );
  }
}

/* Firebase Cloud Messaging Push Notification Setup for Android */
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> setLocalNotification() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "@mipmap/ic_launcher",
            ),
          ),
        );
      }
    },
  );
}

/* Home Screen Widget - Different Entry points based on role */
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final Auth auth;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () => Provider.of<Auth>(context, listen: false).produceFCMToken(),
    );
    setLocalNotification();
    super.initState();
  }

  Widget screenByRole(String role) {
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
        ? screenByRole(widget.auth.getRole ?? "Student")
        : FutureBuilder(
            future: widget.auth.tryAutoLogin(context),
            builder: (ctx, authResultSnapShot) =>
                authResultSnapShot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const LoginScreen(),
          );
  }
}
