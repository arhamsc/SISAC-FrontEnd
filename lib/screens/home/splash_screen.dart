import 'package:flutter/material.dart';

import '../../utils/helpers/loader.dart';

/* Splash Screen to show loading state while login */
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SISACLoader(),
      ),
    );
  }
}
