import 'dart:ffi';

import 'package:flutter/material.dart';
import '../utils/general/customColor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    final screenHeight = mediaQ.size.height;
    final screenWidth = mediaQ.size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          Center(
            heightFactor: 2.0,
            child: Container(
              height: screenHeight * 0.2,
              width: screenWidth * 0.45,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            color: Palette.senaryDefault,
            width: double.infinity,
            height: screenHeight * 0.1,
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                        vertical: screenHeight * 0.009,
                        horizontal: screenWidth * 0.25),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(SecondaryPallete.tertiary),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                ),
                child:
                    Text("Login", style: Theme.of(context).textTheme.headline6),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
