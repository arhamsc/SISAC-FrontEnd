import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/general/customColor.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/announcements/announcement_providers.dart';

import '../../../utils/helpers/loader.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../widgets/ui_widgets/cards/item_card.dart';

import '../../../../utils/general/screen_size.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  static const routeName = '/announcements/announcement_details';
  const AnnouncementDetailsScreen({Key? key}) : super(key: key);
  @override
  State<AnnouncementDetailsScreen> createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final Announcement _announcement = _arguments[
        'announcement']; //This is because if we accept the argument as the constructor then we have to pass it inside the main.dart too.
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Announcement",
        context: context,
        subtitle: "Details",
      ),
      //Title
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              _announcement.title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          // Name and Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "By: ${_announcement.byUser.name} (${_announcement.byUser.role})",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "${_announcement.level} Level",
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          // Description Column
          Column(
            children: [
              Text(
                "Description: ",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
              ),
              Text(
                _announcement.description,
                style: Theme.of(context).textTheme.bodyText1,
                softWrap: true,
              ),
            ],
          ),
          _announcement.links?.isNotEmpty ?? false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Links: ",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                    ),
                    Column(
                      children: [
                        ..._announcement.links!
                            .map(
                              (e) => Row(
                                children: [
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  const MyBullet(),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            )
                            .toList()
                      ],
                    ),
                    const PDFCard()
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class PDFCard extends StatelessWidget {
  const PDFCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("PDF"),
    );
  }
}

class MyBullet extends StatelessWidget {
  const MyBullet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.sp,
      width: 5.sp,
      decoration: const BoxDecoration(
        color: Palette.tertiaryDefault,
        shape: BoxShape.circle,
      ),
    );
  }
}
