import 'package:flutter/material.dart';
import '../general/customColor.dart';

Future<dynamic> dialog(
    {required BuildContext ctx,
    required String errorMessage,
    Function()? tryAgainFunc,
    String? title}) {
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
                    tryAgainFunc != null
                        ? tryAgainFunc
                        : Navigator.of(context).pop();
                  },
                  child: Text('Try Again',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: SecondaryPallete.primary)),
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
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: Palette.tertiaryDefault,
      );
    },
  );
}
