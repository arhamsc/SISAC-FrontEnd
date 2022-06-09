import 'package:flutter/material.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';

class MakeAnnouncementScreen extends StatelessWidget {
  static const routeName = "/announcements/makeAnnouncement";
  const MakeAnnouncementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar.getAppBar(
          title: "Announcement",
          context: context,
          subtitle: "Make an Announcement",
        ),
        body: Center(
          child: Text("Dash"),
        ));
  }
}
