import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/student_faculty_screens/nav_screens/tab_screen.dart';
import '../../screens/other_screens/restaurant_screens/parent_screens/restaurant_home_screen.dart';
import '../../screens/other_screens/stationary_screens/parent_screens/stationary_home_screen.dart';

import '../../utils/helpers/error_dialog.dart';

import '../../providers/user_provider.dart';

import '../../utils/general/customColor.dart';
import '../../utils/general/screen_size.dart' show ScreenSize;
import '../../utils/helpers/http_exception.dart';

/* Login Modal screen to collect credentials and send the authentication request */
class LoginModalScreen extends StatelessWidget {
  const LoginModalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        color: Palette.primaryDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            RoleRow(),
            InputColumn(),
          ],
        ),
      ),
    );
  }
}

class InputColumn extends StatefulWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey();

  const InputColumn({Key? key}) : super(key: key);
  @override
  State<InputColumn> createState() => _InputColumnState();
}

/* Credential Input Fields */
class _InputColumnState extends State<InputColumn> {
  String? _username;
  String? _password;

  bool _isLoading = false;
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  //Getter to get the appropriate screen
  String screenByRole(String role) {
    switch (role) {
      case "Other":
        return RestaurantHomeScreen.routeName;
      case "Stationary":
        return StationaryHomeScreen.routeName;
      default:
        return TabScreen.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    /* Login Function to authenticate the user */
    Future<void> submitCred() async {
      try {
        setState(() {
          _isLoading = true;
        });
        InputColumn._formKey.currentState?.save();
        await authProvider.login(_username, _password, context);
        setState(
          () {
            _isLoading = false;
            Navigator.of(context).pushReplacementNamed(
              screenByRole(authProvider.getRole!),
            );
          },
        );
      } on HttpException catch (error) {
        var errorMessage = error.toString();
        await dialog(ctx: context, errorMessage: errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: ScreenSize.screenHeight(context) * 0.05),
        Form(
          key: InputColumn._formKey,
          child: Column(
            children: [
              SizedBox(
                width: ScreenSize.screenWidth(context) * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    //Username input
                    const Text(
                      "Username",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Palette.tertiaryDefault,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "USN/ID",
                        filled: true,
                        fillColor: Palette.tertiaryDefault,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: SecondaryPallete.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          top: 20,
                          bottom: 20,
                        ),
                      ),
                      cursorColor: Palette.senaryDefault,
                      onSaved: (value) {
                        _username = value;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: ScreenSize.screenWidth(context) * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    //Password Input
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Palette.tertiaryDefault,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Palette.tertiaryDefault,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: SecondaryPallete.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          top: 20,
                          bottom: 20,
                        ),
                      ),
                      obscureText: true,
                      cursorColor: Palette.senaryDefault,
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        //Login Button
        ElevatedButton(
          onPressed: submitCred,
          child: _isLoading
              ? const CircularProgressIndicator(color: SecondaryPallete.primary)
              : const Text("Sign In"),
        ),
        const SizedBox(height: 5),
        const Text("Forgot Password?"),
      ],
    );
  }
}

/* Displaying the role selectors */
class RoleRow extends StatefulWidget {
  const RoleRow({
    Key? key,
  }) : super(key: key);

  @override
  State<RoleRow> createState() => _RoleRowState();
}

class _RoleRowState extends State<RoleRow> {
  final List<bool> _toggleSelections = List.generate(3, (_) => false);
  final List<String> _roleList = List.generate(
      Roles.values.length, (index) => Roles.values[index].enumToString());
  Roles _selectedRole = Roles.Student;

  @override
  void initState() {
    _toggleSelections[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SecondaryPallete.primary,
      child: ToggleButtons(
        children: _roleList
            .map<Widget>(
              (role) => Container(
                child: Text(
                  role,
                  style: Theme.of(context).textTheme.headline5,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.screenWidth(context) / 12,
                ),
              ),
            )
            .toList(),
        isSelected: _toggleSelections,
        borderWidth: 0,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _toggleSelections.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _toggleSelections[buttonIndex] = true;
              } else {
                _toggleSelections[buttonIndex] = false;
              }
            }
          });
          _selectedRole = Roles.values[index];
        },
        fillColor: SecondaryPallete.tertiary,
      ),
    );
  }
}

enum Roles { Student, Faculty, Other }

extension ParseToString on Roles {
  String enumToString() {
    return toString().split('.').last;
  }
}
