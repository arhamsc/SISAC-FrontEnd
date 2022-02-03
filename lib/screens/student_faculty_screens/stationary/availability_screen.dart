import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/stationary/availability_providers.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../widgets/component_widgets/stationary/display_cards/available_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

/* Stationary - Screen to view Bluebooks/Records */
class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/availability';

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  /* Pull to Refresh Function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<AvailabilityProvider>(context, listen: false)
          .fetchAvailableItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Stationary",
        context: context,
        subtitle: "Availability",
      ),
      body: FutureBuilder(
        future: Provider.of<AvailabilityProvider>(context, listen: false)
            .fetchAvailableItems(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.error != null) {
            Future.delayed(
              Duration.zero,
              () => dialog(
                ctx: context,
                errorMessage: dataSnapShot.error.toString(),
                tryAgainFunc: () => _refreshItems(context),
                pop2Pages: true,
              ),
            );
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: const Center(
                child: Text("Error"),
              ),
            );
          } else {
            return Consumer<AvailabilityProvider>(
              builder: (ctx, availabilityData, child) => RefreshIndicator(
                onRefresh: () => _refreshItems(context),
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    /* Card to Render the Items */
                    itemBuilder: (ctx, i) => AvailabilityCard(
                      availableItems: availabilityData.availableItems[i],
                      setFunc: () {
                        setState(() {});
                      },
                    ),
                    itemCount: availabilityData.availableItems.length,
                  ),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        isSelected: "Stationary",
        pageController: pageController,
      ),
    );
  }
}
