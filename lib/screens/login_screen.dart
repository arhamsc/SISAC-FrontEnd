import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/general/screen_size.dart' show ScreenSize;

import '../widgets/login_widgets/bottom_container.dart';
import '../widgets/modal_screens/login_modal_screen.dart';

import '../providers/user_provider.dart';

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
      body: Consumer<Auth>(
        builder: (ctx, authData, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Center(
              heightFactor: 2.0,
              child: Container(
                height: ScreenSize.screenHeight(context) * 0.2,
                width: ScreenSize.screenWidth(context) * 0.45,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            LoginButtonContainer(
              showModal: _showLoginModal,
            ),
          ],
        ),
      ),
    );
  }
}
