import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sisac/providers/announcements/announcement_providers.dart';

import 'package:sisac/utils/general/customColor.dart';
import 'package:sisac/utils/helpers/loader.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../../utils/helpers/error_dialog.dart';

import '../../../widgets/ui_widgets/cards/item_card.dart';

import '../../../../utils/general/screen_size.dart';

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
      final announcementP =
          Provider.of<AnnouncementProvider>(context, listen: false);
      announcementP.fetchAllAnnouncements();
    }());
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

  @override
  Widget build(BuildContext context) {
    final pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
    final announcementsP =
        Provider.of<AnnouncementProvider>(context, listen: false);
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "All",
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
                child: Text("Error"),
              ),
            );
          } else {
            return Consumer<AnnouncementProvider>(
              builder: (ctx, announcementsData, child) => RefreshIndicator(
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                    itemBuilder: (ctx, i) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 0.5.h,
                          ),
                          SizedBox(
                            width: 90.w,
                            child: ItemCard(
                              itemName: announcementsData.announcements.values
                                  .elementAt(i)
                                  .title,
                              leftSubtitle: announcementsData
                                  .announcements.values
                                  .elementAt(i)
                                  .level,
                              rightSubtitle: announcementsData
                                  .announcements.values
                                  .elementAt(i)
                                  .level,
                              showTwoButtons: false,
                              buttonOneText: "View More",
                              buttonOneFunction: () {},
                              expanded: false,
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                        ],
                      );
                    },
                    itemCount: announcementsData.announcements.length,
                  ),
                ),
                onRefresh: () => _refreshItems(context),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        isSelected: "Cafetaria",
        pageController: pageController,
      ),
    );
  }
}
