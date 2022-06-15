import 'package:flutter/material.dart';

import '../general/customColor.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.confirmationFunction,
      this.pop2Pages})
      : super(key: key);
  final String title;
  final String content;
  final Function confirmationFunction;
  final bool? pop2Pages;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: SecondaryPallete.primary,
            ),
      ),
      content: Text(
        content,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: SecondaryPallete.primary),
          ),
        ),
        TextButton(
          onPressed: pop2Pages != null && pop2Pages!
              ? () {
                  confirmationFunction();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              : () {
                  confirmationFunction();
                  Navigator.of(context).pop();
                },
          child: Text(
            "Confirm",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: SecondaryPallete.primary),
          ),
        ),
      ],
      backgroundColor: Palette.tertiaryDefault,
    );
  }
}
