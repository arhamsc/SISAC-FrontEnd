import 'package:flutter/material.dart';
import '../general/customColor.dart';

/* Dialog Helper Widget to show a Success or Error Dialog */
Future<dynamic> dialog({
  required BuildContext ctx,
  required String errorMessage,
  Function()? tryAgainFunc,
  String? title,
  bool? pop2Pages,
}) {
  return showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: Text(title ?? "Error Occurred",
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: SecondaryPallete.primary,
                )),
        content: Text(errorMessage),
        actions: [
          tryAgainFunc != null
              ? TextButton(
                  onPressed: () {
                    tryAgainFunc();
                  },
                  child: Text(
                    'Try Again',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: SecondaryPallete.primary,
                        ),
                  ),
                )
              : const SizedBox(),
          TextButton(
            child: Text(
              'OK',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: SecondaryPallete.primary),
            ),
            onPressed: () {
              if (pop2Pages != null && pop2Pages) {
                var popping = Navigator.of(context);
                popping.pop();
                popping.pop();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        backgroundColor: Palette.tertiaryDefault,
      );
    },
  );
}
