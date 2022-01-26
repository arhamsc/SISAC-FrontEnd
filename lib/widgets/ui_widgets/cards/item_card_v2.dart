import 'package:flutter/material.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart';

class ItemCardV2 extends StatelessWidget {
  const ItemCardV2(
      {Key? key,
      required this.imageUrl,
      required this.itemName,
      required this.subtitles,
      this.largerItemName})
      : super(key: key);

  final String imageUrl;
  final String itemName;
  final List<String> subtitles;
  final bool? largerItemName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.screenHeight(context) * .14,
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
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              itemName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: largerItemName != null &&
                                            largerItemName!
                                        ? 18
                                        : 15,
                                  ),
                            ),
                            SizedBox(
                              height: ScreenSize.screenHeight(context) * .008,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (String e in subtitles)
                                  Text(
                                    e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                              ],
                            )
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
        ],
      ),
    );
  }
}