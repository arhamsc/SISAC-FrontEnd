import "package:flutter/material.dart";

class AnnouncementScreen extends StatefulWidget {
  AnnouncementScreen({Key? key, required this.pageController}) : super(key: key);
 PageController? pageController;
  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Annoucements"),)
    );
  }
}