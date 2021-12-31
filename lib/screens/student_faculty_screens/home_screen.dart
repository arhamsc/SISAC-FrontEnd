import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Column(
        children: [
          Center(
            child: Text("${authData.getRole}"),
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: () {
              authData.logout();
              if (!authData.isAuth) {
                Navigator.popUntil(context, ModalRoute.withName("/"));
              }
            },
          ),
        ],
      );
  }
}