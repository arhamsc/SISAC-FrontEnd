import 'package:flutter/material.dart';
import 'package:sisac/utils/general/customColor.dart';
import '../utils/general/screen_size.dart';

class BaseAppBar {
  static getAppBar(
      {required String title,
      required BuildContext context,
      String? subtitle,
      bool? available,
      String? availabilityText}) {
    return AppBar(
      toolbarHeight: ScreenSize.screenHeight(context) * 0.1,
      //automaticallyImplyLeading: false,
      leadingWidth: 25,
      title: subtitle == null
          ? Text(title)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
      actions: [
        available != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundColor: available ? Colors.green : Colors.red,
                    radius: 5,
                  ),
                  const SizedBox(width: 5),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(
                        '$availabilityText',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Palette.quinaryDefault),
                      ),
                      available
                          ? Text(
                              'Available',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Palette.quinaryDefault),
                            )
                          : Text(
                              'Unavailable',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Palette.quinaryDefault,
                                  ),
                            ),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(width: 5),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
    );
  }
}