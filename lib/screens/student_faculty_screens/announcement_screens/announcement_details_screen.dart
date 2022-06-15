import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/announcements/announcement_providers.dart';

import './functional_screens/make_announcement.dart';

import '../../../widgets/ui_widgets/tiles/pdf_tile.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../utils/general/customColor.dart';

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
    final bool _isAuthor = _arguments['isAuthor'];
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
          // _announcement.links?.isNotEmpty ?? false
          //     ? Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 5.w),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Links: ",
          //               style: Theme.of(context).textTheme.headline4!.copyWith(
          //                     fontWeight: FontWeight.w500,
          //                     fontSize: 18.sp,
          //                   ),
          //             ),
          //             Column(
          //               children: [
          //                 ..._announcement.links!
          //                     .map(
          //                       (e) => Row(
          //                         children: [
          //                           SizedBox(
          //                             width: 2.w,
          //                           ),
          //                           const MyBullet(),
          //                           SizedBox(
          //                             width: 2.w,
          //                           ),
          //                           Text(
          //                             e,
          //                             style: Theme.of(context)
          //                                 .textTheme
          //                                 .bodyText1!
          //                                 .copyWith(
          //                                   fontWeight: FontWeight.w400,
          //                                 ),
          //                           ),
          //                         ],
          //                       ),
          //                     )
          //                     .toList()
          //               ],
          //             ),
          //           ],
          //         ),
          //       )
          //     : const SizedBox(),
          SizedBox(
            height: 10.h,
          ),
          _announcement.posterUrl != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: PDFCard(
                    pdfUrl: _announcement.posterUrl!,
                    showChangeButton: false,
                  ),
                )
              : const SizedBox(),
          SizedBox(height: 1.h),
          _isAuthor
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Icon(Icons.delete_rounded),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 1.h,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                          MakeAnnouncementScreen.routeName,
                          arguments: {'announcementToEdit': _announcement}),
                      child: const Icon(Icons.edit),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 1.h,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox()
        ],
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
