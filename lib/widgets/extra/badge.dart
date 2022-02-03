import 'package:flutter/material.dart';

import '../../utils/general/customColor.dart';

/* Badge Widget to display on recommended menu items */
class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          left: 20,
          top: 2,
          child: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Palette.quinaryDefault,
            ),
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: const Icon(
              Icons.star,
              color: Palette.senaryDefault,
            ),
          ),
        )
      ],
    );
  }
}
