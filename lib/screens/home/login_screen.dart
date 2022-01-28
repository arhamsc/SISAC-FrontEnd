import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/general/screen_size.dart' show ScreenSize;

import '../../widgets/component_widgets/login_form/bottom_container.dart';
import '../../widgets/modal_screens/login_modal_screen.dart';

import '../../providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _showLoginModal(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return LoginModalScreen();
        },
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              heightFactor: 2.0,
              child: Container(
                height: ScreenSize.screenHeight(context) * 0.3,
                width: ScreenSize.screenWidth(context) * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/SISAC.png'),
                  ),
                ),
              ),
            ),
          ),
          LoginButtonContainer(
            showModal: _showLoginModal,
          ),
        ],
      ),
    );
  }
}
