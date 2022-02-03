import 'package:flutter/material.dart';
import '../general/customColor.dart';

/* Helper Snack Bar widget */

void customSnackBar({
  required BuildContext ctx,
  required String title,
  required Function undoFunc,
  bool error = false,
}) {
  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: !error ? Palette.tertiaryDefault : Colors.red,
        ),
      ),
      duration: const Duration(seconds: 2),
      action: !error
          ? SnackBarAction(
              label: 'Undo',
              onPressed: () => undoFunc(),
              textColor: Palette.quinaryDefault,
            )
          : null,
    ),
  );
}
