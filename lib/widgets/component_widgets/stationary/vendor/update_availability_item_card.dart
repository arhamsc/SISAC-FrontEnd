import 'package:flutter/material.dart';

import '../../../ui_widgets/cards/availability_card.dart';

class UpdateIsAvailableCard extends StatefulWidget {
  const UpdateIsAvailableCard({
    Key? key,
    required this.setFunc,
    required this.itemName,
    required this.switchFunc,
    required this.isAvailable,
  }) : super(key: key);

  final String itemName;
  final bool isAvailable;
  final Function switchFunc;
  final Function setFunc;

  @override
  _UpdateIsAvailableCardState createState() => _UpdateIsAvailableCardState();
}

class _UpdateIsAvailableCardState extends State<UpdateIsAvailableCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      children: [
        const SizedBox(height: 10),
        Center(
          child: AvailabilityCard(
            itemName: widget.itemName,
            isAvailable: widget.isAvailable,
            switchFunc: () async {
              widget.switchFunc();
            },
            editButtonRequired: false,
            deleteButtonRequired: false,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
