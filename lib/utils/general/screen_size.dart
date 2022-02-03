import 'package:flutter/material.dart';

/* Helper Class to get the Screen Size */
class ScreenSize {
  static mediaQ(BuildContext ctx) {
    return MediaQuery.of(ctx);
  }

  static screenHeight(BuildContext ctx) {
    final mediaQ = ScreenSize.mediaQ(ctx);
    return mediaQ.size.height;
  }

  static screenWidth(BuildContext ctx) {
    final mediaQ = ScreenSize.mediaQ(ctx);
    return mediaQ.size.width;
  }

  //To get the screen size minus the app bar and bottom bar height
  static usableHeight(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;
    final bottomHeight = ScreenSize.screenHeight(context) * 0.17;
    final screenHeight =
        MediaQuery.of(context).size.height - appBarHeight - bottomHeight;
    return screenHeight;
  }
}
