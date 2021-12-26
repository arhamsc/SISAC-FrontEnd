import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text("${authData.getRole}"),
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: authData.logout,
          ),
        ],
      ),
    );
  }
}
