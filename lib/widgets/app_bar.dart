import 'package:flutter/material.dart';
import '../utils/general/screen_size.dart';

class BaseAppBar {
  static getAppBar(String title, BuildContext context) {
    return AppBar(
      toolbarHeight: ScreenSize.screenHeight(context) * 0.1,
      leadingWidth: 25,
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
    );
  }
}
