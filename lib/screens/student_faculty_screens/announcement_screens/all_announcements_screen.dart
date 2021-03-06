import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/announcements/announcement_providers.dart';

import './announcement_details_screen.dart';

import '../../../utils/helpers/loader.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../widgets/ui_widgets/cards/item_card.dart';
import '../../../utils/general/screen_size.dart';

class AllAnnouncementScreen extends StatefulWidget {
  static const routeName = 'announcements/all_announcements';
  const AllAnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AllAnnouncementScreen> createState() => _AllAnnouncementScreenState();
}

class _AllAnnouncementScreenState extends State<AllAnnouncementScreen> {
  @override
  void initState() {
    /* Fetching the Menu Items at the time of initial Rendering */
    Future.delayed(Duration.zero, () {
      setState(() {
        final announcementP =
            Provider.of<AnnouncementProvider>(context, listen: false);
        announcementP.fetchAllAnnouncements();
      });
    });
    super.initState();
  }

  Future<void> _refreshItems(BuildContext context) async {
    setState(
      () {
        Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchAllAnnouncements();
      },
    );
  }

  // Future<void> deleteAnnouncement(String id, Function annDelete) async {
  //   try {
  //     return showDialog(
  //       context: context,
  //       builder: (context) => ConfirmationDialog(
  //         title: "Delete Announcement",
  //         confirmationFunction: () => annDelete(id),
  //         content: "Are you sure you want to delete it?",
  //       ),
  //     );
  //   } catch (e) {
  //     throw HttpException(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final pageController = _arguments['controller'] as PageController;
    final pageLevel = _arguments['level'].toString();
    final announcementsP =
        Provider.of<AnnouncementProvider>(context, listen: false);
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: pageLevel,
        context: context,
      ),
      body: FutureBuilder(
        future: announcementsP.fetchAllAnnouncements(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: SISACLoader());
          } else if (dataSnapShot.error != null) {
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: const Center(
                child: Text("Error, Pull to Refresh."),
              ),
            );
          } else {
            return Consumer<AnnouncementProvider>(
                builder: (ctx, announcementsData, child) {
              final int _announcementsLength = pageLevel != 'All'
                  ? announcementsData.announcementByLevel(pageLevel).length
                  : announcementsData.announcements.length;
              return RefreshIndicator(
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: _announcementsLength != 0
                      ? AnnouncementList(
                          pageLevel: pageLevel,
                          announcementsData: announcementsData,
                          isAuthor: announcementsData.isAnnouncementAuthor,
                          providerDeleteFunc:
                              announcementsData.deleteAnnouncement,
                        )
                      : Center(
                          child: Text(
                            "There are no Announcements!",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                ),
                onRefresh: () => _refreshItems(context),
              );
            });
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        isSelected: "Announcements",
        pageController: pageController,
      ),
    );
  }
}

class AnnouncementList extends StatelessWidget {
  const AnnouncementList(
      {Key? key,
      required this.pageLevel,
      required this.announcementsData,
      required this.isAuthor,
      required this.providerDeleteFunc})
      : super(key: key);

  final String pageLevel;
  final AnnouncementProvider announcementsData;
  final Function isAuthor;
  final Function providerDeleteFunc;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
      itemBuilder: (ctx, i) {
        final Announcement _announcements = pageLevel != 'All'
            ? announcementsData
                .announcementByLevel(pageLevel)
                .values
                .elementAt(i)
            : announcementsData.announcements.values.elementAt(i);
        return Column(
          children: [
            SizedBox(
              height: 0.5.h,
            ),
            SizedBox(
              width: 90.w,
              child: ItemCard(
                itemName: _announcements.title,
                leftSubtitle: _announcements.level,
                rightSubtitle: _announcements.level,
                showTwoButtons: false,
                buttonOneText: "View More",
                buttonOneFunction: () {
                  Navigator.of(context).pushNamed(
                    AnnouncementDetailsScreen.routeName,
                    arguments: {
                      'announcement': _announcements,
                      'isAuthor': isAuthor(_announcements.id),
                      'deleteFunc': providerDeleteFunc
                    },
                  );
                },
                expanded: false,
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
          ],
        );
      },
      itemCount: pageLevel != 'All'
          ? announcementsData.announcementByLevel(pageLevel).length
          : announcementsData.announcements.length,
    );
  }
}
