import 'package:flutter/material.dart';
import 'package:sisac/utils/helpers/http_exception.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/cafataria_providers.dart';

import '../../../../screens/other_sceens/restaurant_screens/updation_screens/add_edit_menuItem_screen.dart';

import '../../../ui_widgets/small_button.dart';

import '../../../../utils/general/screen_size.dart';
import '../../../../utils/general/customColor.dart';

import '../../../../utils/helpers/error_dialog.dart';

class IsAvailableCard extends StatefulWidget {
  const IsAvailableCard({Key? key, required this.menu, required this.setFunc})
      : super(key: key);

  final MenuItem menu;
  final Function setFunc;

  @override
  _IsAvailableCardState createState() => _IsAvailableCardState();
}

class _IsAvailableCardState extends State<IsAvailableCard> {
  bool _isLoading = false;

  bool get presentIsAvailable {
    return widget.menu.isAvailable;
  }

  Future<void> updateMenu(MenuItemProvider menuItemP, String id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var res = await menuItemP.updateIsAvailable(id, widget.menu.isAvailable);
      await dialog(
          ctx: context, errorMessage: "Menu Updated", title: "Success");

      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      await dialog(ctx: context, errorMessage: error.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuP = Provider.of<MenuItemProvider>(context);
    return Column(
      key: widget.key,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
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
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: ScreenSize.screenWidth(context) * .25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.menu.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
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
                      Text(
                        widget.menu.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.menu.isAvailable ? 'Available' : 'Not Available',
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
                        child: Switch(
                          value: widget.menu.isAvailable,
                          onChanged: (_) async {
                            await updateMenu(
                              menuP,
                              widget.menu.id,
                            );

                            widget.setFunc();
                          },
                          activeTrackColor: Palette.quaternaryDefault,
                          inactiveTrackColor: SecondaryPallete.quaternary,
                          inactiveThumbColor: Palette.tertiaryDefault,
                          activeColor: Palette.quinaryDefault,
                        ),
                      ),
                    ),
                    smallEleBtn(
                      context: context,
                      title: "Edit",
                      onPressFunc: () {
                        Navigator.of(context).pushNamed(
                          AddEditMenuItemScreen.routeName,
                          arguments: widget.menu.id,
                        );
                      },
                    ),
                    const SizedBox(),
                  ],
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
