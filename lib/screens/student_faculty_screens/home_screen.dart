import 'package:flutter/material.dart';

import '../../widgets/home/home_main_card.dart';
import '../../widgets/home/home_row_cards.dart';

import '../../utils/general/screen_size.dart';
import '../../utils/general/customColor.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final appBarHeight = AppBar().preferredSize.height;
  @override
  Widget build(BuildContext context) {
    final bottomHeight = ScreenSize.screenHeight(context) * 0.17;
    //final authData = Provider.of<Auth>(context);
    final screenHeight =
        MediaQuery.of(context).size.height - appBarHeight - bottomHeight;
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeMainCard(
              mainTitle: "Time Table",
              buttonTitle: "Click to View",
              buttonFunction: () {},
            ),
            Container(
              child: Column(
                children: [
                  HomeRowCards(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.chevron_left, color: Palette.quinaryDefault),
                      Icon(Icons.chevron_right, color: Palette.quinaryDefault),
                    ],
                  ),
                ],
              ),
            ),
            HomeMainCard(
              mainTitle: "Cafetaria",
              buttonTitle: "Click to visit",
              buttonFunction: () {},
              bgColor: SecondaryPallete.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// ElevatedButton(
//             child: const Text("Logout"),
//             onPressed: () {
//               authData.logout();
//               if (!authData.isAuth) {
//                 Navigator.popUntil(context, ModalRoute.withName("/"));
//               }
//             },
//           ),
