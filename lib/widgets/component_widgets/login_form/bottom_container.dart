import 'package:flutter/material.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart' show ScreenSize;

/* Login Screen - Login Button Container at the Bottom */
class LoginButtonContainer extends StatefulWidget {
  const LoginButtonContainer({
    Key? key,
    required this.showModal,
  }) : super(key: key);

  final Function showModal;
  @override
  _LoginButtonContainerState createState() => _LoginButtonContainerState();
}

class _LoginButtonContainerState extends State<LoginButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.senaryDefault,
      width: double.infinity,
      height: ScreenSize.screenHeight(context) * 0.1,
      child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                vertical: ScreenSize.screenHeight(context) * 0.009,
                horizontal: ScreenSize.screenWidth(context) * 0.25,
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              SecondaryPallete.tertiary,
            ),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          //Login Button to show login modal screen
          child: Text(
            "Login",
            style: Theme.of(context).textTheme.headline6,
          ),
          onPressed: () => widget.showModal(context),
        ),
      ),
    );
  }
}
