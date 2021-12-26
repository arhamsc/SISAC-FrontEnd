import 'package:flutter/material.dart';

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
}
