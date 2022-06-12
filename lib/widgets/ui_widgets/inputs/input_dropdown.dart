import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart';

/* Custom Form Drop Down Widget */
class DropDownInputForm extends StatefulWidget {
  const DropDownInputForm({
    Key? key,
    required this.title,
    required this.dropDownMenuItems,
    required this.value,
    required this.setter,
  }) : super(key: key);

  final String title;
  final List<DropdownMenuItem<String>> dropDownMenuItems;
  final String value;
  final Function setter;
  @override
  State<DropDownInputForm> createState() => _DropDownInputFormState();
}

class _DropDownInputFormState extends State<DropDownInputForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 2.w,
          ),
          //Title
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: SecondaryPallete.tertiary,
          ),
          //Dropdown
          child: DropdownButtonFormField(
            alignment: Alignment.centerLeft,
            dropdownColor: SecondaryPallete.tertiary,
            //Items got from the parameters
            items: widget.dropDownMenuItems,
            onChanged: (val) {
              setState(() => widget.setter(val.toString(), widget.title));
            },
            //current value
            value: widget.value,
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
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),
            iconEnabledColor: Palette.quinaryDefault,
          ),
        ),
      ],
    );
  }
}
