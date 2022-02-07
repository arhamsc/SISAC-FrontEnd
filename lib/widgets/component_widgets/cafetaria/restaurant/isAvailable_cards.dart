import 'package:flutter/material.dart';
import 'package:sisac/utils/helpers/http_exception.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';

import '../../../../screens/other_screens/restaurant_screens/updation_screens/add_edit_menuItem_screen.dart';

import '../../../ui_widgets/cards/availability_card.dart';

import '../../../../utils/helpers/error_dialog.dart';


/* Restaurant - IsAvailable Card - To update availability and edit the menu Item */
class IsAvailableCard extends StatefulWidget {
  const IsAvailableCard({
    Key? key,
    required this.menu,
    required this.setFunc,
    required this.deleteFunc,
  }) : super(key: key);

  final MenuItem menu;
  final Function setFunc;
  final Function deleteFunc;

  @override
  _IsAvailableCardState createState() => _IsAvailableCardState();
}

class _IsAvailableCardState extends State<IsAvailableCard> {
  bool _isLoading = false;

  bool get presentIsAvailable {
    return widget.menu.isAvailable;
  }

  /* Menu Item Update Function */
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
          //Custom Universal Availability Widget
          child: AvailabilityCard(
            imageUrl: widget.menu.imageUrl,
            itemName: widget.menu.name,
            isAvailable: widget.menu.isAvailable,
            switchFunc: () async {
              await updateMenu(
                menuP,
                widget.menu.id,
              );
              widget.setFunc();
            },
            editButtonRequired: true,
            editButtonFunction: () {
              Navigator.of(context).pushNamed(
                AddEditMenuItemScreen.routeName,
                arguments: widget.menu.id,
              );
            },
            deleteButtonRequired: true,
            deleteButtonFunc: () {
              widget.deleteFunc();
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
