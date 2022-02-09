import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart';

/* Custom TextForm Widget for form inputs */
class FormInputTextField extends StatelessWidget {
  const FormInputTextField({
    Key? key,
    required this.title,
    this.description,
    this.maxLines,
    this.numberKeyboard,
    this.initialValue,
    this.controller,
    this.setter,
  }) : super(key: key);
  final String title;
  final String? initialValue;
  final bool? description;
  final int? maxLines;
  final bool? numberKeyboard;
  final Function? setter;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: ScreenSize.screenHeight(context) * .005,
            horizontal: ScreenSize.screenWidth(context) * .02,
          ),
          //Title
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        //TextForm
        SizedBox(
          height: description != null && maxLines != null && description!
              ? null
              : ScreenSize.screenHeight(context) * .05,
          child: TextFormField(
            initialValue: initialValue,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(color: Palette.quinaryDefault),
            //For description
            maxLines: description != null && maxLines != null && description!
                ? maxLines
                : 1,
            textInputAction: TextInputAction.next,
            cursorColor: Palette.quinaryDefault,
            decoration: InputDecoration(
              fillColor: SecondaryPallete.tertiary,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Palette.quinaryDefault,
                ),
              ),
            ),
            validator: (value) {
              if (value != null) {
                if (value.trim().isEmpty) {
                  return 'Please provide a value';
                }
              } else if (numberKeyboard != null && numberKeyboard!) {
                int.parse(value!) <= 10
                    ? 'Please Enter value greater then 10'
                    : null;
              } else {
                return 'Please provide a value';
              }
            },
            controller: controller,
            onSaved: (val) {
              controller != null ? controller!.text = val! : null;
            },
            onChanged: (val) {
              setter != null ? setter!(val, title) : null;
            },
            keyboardType: numberKeyboard != null && numberKeyboard!
                ? TextInputType.number
                : TextInputType.text,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
