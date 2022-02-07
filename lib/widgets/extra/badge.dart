import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
          left: 3.w,
          top: .2.h,
          child: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Palette.quinaryDefault,
            ),
            constraints: BoxConstraints(
              minWidth: 4.6.w,
              minHeight: 2.1.h,
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
