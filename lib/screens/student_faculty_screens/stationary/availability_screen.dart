import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/stationary/availability_providers.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/stationary/available_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/availability';

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  var _expanded = false;

  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<AvailabilityProvider>(context, listen: false)
        .fetchAvailableItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
            return const Center(child: CircularProgressIndicator());
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
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: Column(
                children: [
                  Consumer<AvailabilityProvider>(
                    builder: (ctx, availabilityData, child) => Container(
                      child: SingleChildScrollView(
                        child: Container(
                          height: ScreenSize.usableHeight(context),
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => AvailabilityCard(
                              availableItems:
                                  availabilityData.availableItems[i],
                              setFunc: () {
                                setState(() {});
                              },
                            ),
                            itemCount: availabilityData.availableItems.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BottomNav(
                      isSelected: "Stationary",
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
