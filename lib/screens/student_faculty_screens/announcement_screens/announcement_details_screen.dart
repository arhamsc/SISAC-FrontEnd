import 'package:flutter/material.dart';
import 'package:sisac/utils/general/customColor.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/announcements/announcement_providers.dart';

import '../../../widgets/ui_widgets/pdf_view.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';


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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _announcement.title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          // Name and Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "By: ${_announcement.byUser.name} (${_announcement.byUser.role})",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
              ),
              Text(
                "Level: ${_announcement.level}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          // Description Column
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
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
          ),
          SizedBox(
            height: 10.h,
          ),
          _announcement.links?.isNotEmpty ?? false
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
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
                    ],
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 10.h,
          ),
          _announcement.posterUrl != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: PDFCard(
                    pdfUrl: _announcement.posterUrl!,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class PDFCard extends StatelessWidget {
  final String pdfUrl;
  const PDFCard({
    required this.pdfUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.w,
      child: ListTile(
        tileColor: SecondaryPallete.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.sp),
        ),
        leading: Icon(
          Icons.picture_as_pdf_rounded,
          color: SecondaryPallete.primary,
          size: 32.sp,
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            "View attachment",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        onTap: () =>
            Navigator.of(context).pushNamed(PDFView.routeName, arguments: {
          'pdfData': {'url': pdfUrl}
        }),
      ),
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
