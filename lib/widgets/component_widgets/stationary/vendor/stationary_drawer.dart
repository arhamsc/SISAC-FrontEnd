import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/screens/other_screens/stationary_screens/parent_screens/books_material_screen.dart';

import '../../../../providers/user_provider.dart';

import '../../../../screens/other_screens/stationary_screens/parent_screens/material_available_screen.dart';
import '../../../../screens/other_screens/stationary_screens/parent_screens/update_availability_screen.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/http_exception.dart';
import '../../../../utils/helpers/loader.dart';

/* Stationary - Vendor - App Drawer */
class StationaryDrawer extends StatelessWidget {
  const StationaryDrawer({
    Key? key,
  }) : super(key: key);

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
                      Text(
                        //Username
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
                  //Navigation List Tiles
                  ListTile(
                    leading: const Icon(
                      Icons.receipt_long_outlined,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Update Availability",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        UpdateAvailabilityScreen.routeName,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.menu_book,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Books",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        VendorBooksMaterialScreen.routeName,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.receipt_long_outlined,
                      color: Palette.tertiaryDefault,
                    ),
                    title: const Text(
                      "Materials",
                      softWrap: false,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                      color: Palette.tertiaryDefault,
                      size: 32,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        VendorMaterialAvailableScreen.routeName,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
              //Logout Button
              LogoutButton(
                authData: authData,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatefulWidget {
  const LogoutButton({
    Key? key,
    required this.authData,
  }) : super(key: key);

  final Auth authData;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _isLoading = false;

  Future<void> _logoutHandler() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.authData.logout(context);
      _isLoading = false;
    } on HttpException {
      setState(() {
        _isLoading = false;
      });
      await dialog(ctx: context, errorMessage: "Failed to logout");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _logoutHandler,
        child: _isLoading
            ? SISACLoader(
                size: 40,
              )
            : const Text("Logout"),
      ),
    );
  }
}
