import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/helpers/error_dialog.dart';
import 'package:sisac/utils/helpers/http_exception.dart';

import '../../../providers/user_provider.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/helpers/loader.dart';

/* Scaffold - Custom AppDrawer for Student/faculty */
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Palette.senaryDefault,
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    //Name
                    child: Text(
                      authData.getUser.name,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Username
                      Text(
                        authData.getUser.username,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Palette.tertiaryDefault,
                            ),
                      ),
                      //Role
                      Text(
                        'Role: ${authData.getUser.role}',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Palette.tertiaryDefault,
                            ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Palette.primaryDefault,
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Widget Navigation List Tiles
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Time Table",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    //Individual Page controllers
                    onTap: () {
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.announcement_outlined,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Announcements",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Home",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.menu_book_outlined,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Stationary",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      pageController.animateToPage(3,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.coffee_outlined,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Cafetaria",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      pageController.animateToPage(
                        4,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const Divider(
                color: Palette.primaryDefault,
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              LogoutWidget(
                authP: authData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({
    Key? key,
    required this.authP,
  }) : super(key: key);

  final Auth authP;
  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  bool _isLoading = false;

  Future<void> _logoutHandler(Auth authP, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await authP.logout(context);
      _isLoading = false;
    } on HttpException catch (_) {
      setState(() {
        _isLoading = false;
      });
      await dialog(ctx: context, errorMessage: "Failed to Logout");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _logoutHandler(widget.authP, context),
        child: _isLoading
            ? SISACLoader(
                size: 40,
              )
            : const Text("Logout"),
      ),
    );
  }
}
