import 'package:flutter/material.dart';
import '../general/customColor.dart';

Future<dynamic> dialog(BuildContext ctx, String errorMessage) {
  return showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: Text("Error Occurred",
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: SecondaryPallete.primary,
                )),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Try Again',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: SecondaryPallete.primary)),
          ),
        ],
        backgroundColor: Palette.tertiaryDefault,
      );
    },
  );
}
