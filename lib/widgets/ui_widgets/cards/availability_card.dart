import 'package:flutter/material.dart';

import '../buttons/small_button.dart';
import '../buttons/small_delete_button.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';
import '../../../utils/helpers/snack_bar.dart';

/* Custom universal availability card with switch */
class AvailabilityCard extends StatelessWidget {
  const AvailabilityCard({
    Key? key,
    this.imageUrl,
    required this.itemName,
    required this.isAvailable,
    required this.switchFunc,
    this.editButtonFunction,
    required this.editButtonRequired,
    required this.deleteButtonRequired,
    this.deleteButtonFunc,
  }) : super(key: key);

  final String? imageUrl;
  final String itemName;
  final bool isAvailable;
  final Function switchFunc;
  final bool editButtonRequired;
  final Function? editButtonFunction;
  final bool deleteButtonRequired;
  final Function? deleteButtonFunc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.screenHeight(context) * .12,
      width: ScreenSize.screenWidth(context) * .85,
      decoration: BoxDecoration(
        color: SecondaryPallete.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black54,
            spreadRadius: 2,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          imageUrl != null
          //Display Image if required
              ? Container(
                  width: ScreenSize.screenWidth(context) * .25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                //Item Name
                Text(
                  itemName,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                //If available or not
                Text(
                  isAvailable ? 'Available' : 'Not Available',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Palette.tertiaryDefault,
                      ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SizedBox(
                height: ScreenSize.screenHeight(context) * 0.04,
                width: ScreenSize.screenWidth(context) * .08,
                child: Center(
                  //Switch Widget to Switch the availability
                  child: Switch(
                    value: isAvailable,
                    onChanged: (_) => switchFunc(),
                    activeTrackColor: Palette.quaternaryDefault,
                    inactiveTrackColor: SecondaryPallete.quaternary,
                    inactiveThumbColor: Palette.tertiaryDefault,
                    activeColor: Palette.quinaryDefault,
                  ),
                ),
              ),
              //If editing button is required
              editButtonRequired
              //Custom Small Elevated button
                  ? smallEleBtn(
                      context: context,
                      title: "Edit",
                      onPressFunc: editButtonFunction != null
                          ? editButtonFunction!
                          : () {},
                    )
                  : const SizedBox(),
                  //If delete button required
              deleteButtonRequired
              //Custom Small delete button
                  ? smallDeleteEleBtn(
                      context: context,
                      title: "Delete",
                      onPressFunc: () {
                        deleteButtonFunc != null
                            ? deleteButtonFunc!()
                            : customSnackBar(
                                ctx: context,
                                title: "No Function Provided",
                                undoFunc: () {},
                                error: true,
                              );
                      },
                    )
                  : const SizedBox(),
              deleteButtonRequired
                  ? SizedBox(
                      height: ScreenSize.screenHeight(context) * .01,
                    )
                  : const SizedBox()
            ],
          ),
          SizedBox(
            width: ScreenSize.screenWidth(context) * .05,
          )
        ],
      ),
    );
  }
}
