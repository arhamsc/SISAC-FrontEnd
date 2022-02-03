/* Item Card Variant 1 */
import 'package:flutter/material.dart';

import '../buttons/small_button.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart';

/* Custom Item Card 1st Version */
class ItemCard extends StatefulWidget {
  const ItemCard({
    Key? key,
    required this.imageUrl,
    required this.itemName,
    required this.leftSubtitle,
    required this.rightSubtitle,
    required this.showTwoButtons,
    required this.buttonOneText,
    required this.buttonOneFunction,
    required this.expanded,
    this.expandedChildTitle,
    this.expandedButtonOneText,
    this.expandedChild,
    this.buttonTwoText,
    this.buttonTwoFunction,
    this.showSecondaryButtonOneColor,
    this.showSecondaryButtonTwoColor,
  }) : super(key: key);

  final String imageUrl;
  final String itemName;
  final String leftSubtitle;
  final String rightSubtitle;
  final bool expanded;
  final String? expandedChildTitle;
  final List<Widget>? expandedChild;
  final bool showTwoButtons;
  final String buttonOneText;
  final String? expandedButtonOneText;
  final Function buttonOneFunction;
  final String? buttonTwoText;
  final Function? buttonTwoFunction;
  final bool? showSecondaryButtonOneColor;
  final bool? showSecondaryButtonTwoColor;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: _expanded ? ScreenSize.screenHeight(context) * .4 : 0,
          width: ScreenSize.screenWidth(context) * .85,
          decoration: BoxDecoration(
            color: Palette.senaryDefault,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.expandedChildTitle ?? "No Title",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      widget.expanded
                          ? Column(
                              children: widget.expandedChild != null
                                  ? widget.expandedChild!
                                  : [const Text("No Expanded Child")],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: ScreenSize.screenHeight(context) * .108,
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
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
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
                                  widget.itemName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.leftSubtitle,
                                    ),
                                    Text(
                                      widget.rightSubtitle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.showTwoButtons
                              ? smallEleBtn(
                                  context: context,
                                  title: widget.buttonTwoText ?? "No Text",
                                  onPressFunc: () {
                                    widget.buttonTwoFunction != null
                                        ? widget.buttonTwoFunction!()
                                        : null;
                                  },
                                  showSecondaryColor:
                                      widget.showSecondaryButtonTwoColor ??
                                          false,
                                )
                              : const SizedBox(),
                          const SizedBox(width: 10),
                          smallEleBtn(
                            context: context,
                            title: !widget.expanded
                                ? widget.buttonOneText
                                : !_expanded
                                    ? widget.buttonOneText
                                    : widget.expandedButtonOneText ?? "No Text",
                            onPressFunc: widget.expanded
                                ? () {
                                    setState(
                                      () {
                                        _expanded = !_expanded;
                                      },
                                    );
                                  }
                                : () {
                                    widget.buttonOneFunction();
                                  },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
