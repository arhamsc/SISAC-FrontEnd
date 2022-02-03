import "package:flutter/material.dart";

/* Announcements - Navigation Screen */
class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController? pageController;
  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Announcements"),
    );
  }
}
