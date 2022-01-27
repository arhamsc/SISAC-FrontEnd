import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/themes.dart';
import '../../../utils/general/screen_size.dart';

class FormImageInput extends StatefulWidget {
  const FormImageInput(
      {Key? key,
      required this.displayImage,
      required this.pickImageFunc,
      this.initialImage})
      : super(key: key);
  final File? displayImage;
  final String? initialImage;
  final Function pickImageFunc;
  @override
  _FormImageInputState createState() => _FormImageInputState();
}

class _FormImageInputState extends State<FormImageInput> {
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
          child: Text(
            "Image",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: ScreenSize.screenHeight(context) * .2,
              width: ScreenSize.screenWidth(context) * .4,
              decoration: BoxDecoration(
                color: SecondaryPallete.tertiary,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  widget.initialImage != null && widget.initialImage!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.initialImage!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : widget.displayImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                widget.displayImage!,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const FittedBox(
                              child: Text("Pick an Image"),
                              fit: BoxFit.contain,
                            ),
            ),
            SizedBox(
              height: ScreenSize.screenHeight(context) * .2,
              width: ScreenSize.screenWidth(context) * .3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: ScreenSize.screenHeight(context) * .06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonThemes.elevatedButtonInput,
                      onPressed: () {
                        widget.pickImageFunc();
                      },
                      child: const Text(
                        "Camera",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.screenHeight(context) * .06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonThemes.elevatedButtonInput,
                      onPressed: () {
                        widget.pickImageFunc(camera: false);
                      },
                      child: const Text(
                        "Gallery",
                        softWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
