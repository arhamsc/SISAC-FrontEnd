/* Item Card Variant 1 */
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../buttons/small_button.dart';

import '../../../utils/general/customColor.dart';

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
          height: _expanded ? 40.h : 0,
          width: 93.w,
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
                      SizedBox(height: 2.1.h),
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
          height: 11.h,
          width: 93.w,
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
                width: 25.w,
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
                    SizedBox(height: 1.h),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 5.sp),
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
                          SizedBox(width: 2.3.w)
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
                          SizedBox(width: 2.3.w),
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
                          SizedBox(width: 2.3.w),
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
