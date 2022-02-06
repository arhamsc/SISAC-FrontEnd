import 'package:flutter/material.dart';

import '../general/customColor.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.confirmationFunction,
  }) : super(key: key);
  final String title;
  final String content;
  final Function confirmationFunction;
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
          onPressed: () {
            Navigator.of(context).pop();
            confirmationFunction();
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
