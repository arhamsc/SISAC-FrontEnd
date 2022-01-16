import 'package:flutter/material.dart';
import '../general/customColor.dart';

void customSnackBar({
  required BuildContext ctx,
  required String title,
  required Function undoFunc,
}) {
  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => undoFunc(),
        textColor: Palette.quinaryDefault,
      ),
    ),
  );

  // return SnackBar(
  //   content: Text(
  //     title,
  //     textAlign: TextAlign.center,
  //   ),
  //   duration: const Duration(seconds: 2),
  //   action: SnackBarAction(
  //     label: 'Undo',
  //     onPressed: () => undoFunc(),
  //     textColor: Palette.quinaryDefault,
  //   ),
  // );
}
