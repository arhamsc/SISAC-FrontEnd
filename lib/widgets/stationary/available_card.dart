import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stationary/availability_providers.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

class AvailabilityCard extends StatefulWidget {
  AvailabilityCard(
      {Key? key, required this.availableItems, required this.setFunc})
      : super(key: key);

  final Availability availableItems;
  final Function setFunc;

  @override
  _AvailabilityCardState createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends State<AvailabilityCard> {
  bool _isLoading = false;

  bool get presentIsAvailable {
    return widget.availableItems.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final menuP = Provider.of<AvailabilityProvider>(context);
    return Column(
      key: widget.key,
      children: [
        const SizedBox(height: 25),
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
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.availableItems.materialType,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Row(
                  children: [
                    Container(
                      child: Center(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: widget.availableItems.isAvailable
                                  ? Colors.green
                                  : Colors.red,
                              radius: 5,
                            ),
                            const SizedBox(width: 5),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                widget.availableItems.isAvailable
                                    ? Text(
                                        'Available',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                              color: Palette.quinaryDefault,
                                              fontSize: 16,
                                            ),
                                      )
                                    : Text(
                                        'Unavailable',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                              color: Palette.quinaryDefault,
                                              fontSize: 16,
                                            ),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
