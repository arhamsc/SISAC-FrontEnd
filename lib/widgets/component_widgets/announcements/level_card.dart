import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/general/customColor.dart';

class LevelCard extends StatelessWidget {
  final String title;
  final Function onCardTap;
  const LevelCard({Key? key, required this.title, required this.onCardTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      height: 10.7.h,
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => onCardTap(),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Palette.quinaryDefault,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                ),
              ),
            ],
          ),
        ),
        color: SecondaryPallete.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(1.h),
          ),
        ),
      ),
    );
  }
}
