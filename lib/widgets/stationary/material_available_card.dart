import 'package:flutter/material.dart';

import '../../providers/stationary/material_available_providers.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

class MaterialAvailableCard extends StatefulWidget {
  MaterialAvailableCard(
      {Key? key, required this.materialAvailable, required this.setStateFunc})
      : super(key: key);

  final MaterialAvailable materialAvailable;
  final Function setStateFunc;

  @override
  _MaterialAvailableCardState createState() => _MaterialAvailableCardState();
}

class _MaterialAvailableCardState extends State<MaterialAvailableCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            height: ScreenSize.screenHeight(context) * .115,
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
              children: [
                Container(
                  width: ScreenSize.screenWidth(context) * .25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.materialAvailable.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      widget.materialAvailable.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Price: ${widget.materialAvailable.price.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
