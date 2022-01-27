import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/stationary/availability_providers.dart';

import '../../../../widgets/component_widgets/stationary/vendor/update_availability_item_card.dart';
import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/bottom_nav.dart';

import '../../../../../utils/helpers/error_dialog.dart';
import '../../../../../utils/general/screen_size.dart';

class UpdateAvailabilityScreen extends StatefulWidget {
  const UpdateAvailabilityScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/vendor/updateAvailability';

  @override
  State<UpdateAvailabilityScreen> createState() =>
      _UpdateAvailabilityScreenState();
}

class _UpdateAvailabilityScreenState extends State<UpdateAvailabilityScreen> {
  bool _isLoading = false;

  Future<void> updateAvailabilityFunc(
    AvailabilityProvider avalP,
    String id,
    bool available,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      available = !available; //Switching logic here itself
      await avalP.updateAvailability(id, available);
      await dialog(
          ctx: context, errorMessage: "Availability Updated", title: "Success");
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      await dialog(
        ctx: context,
        errorMessage: error.toString(),
        tryAgainFunc: () async {
          await avalP.updateAvailability(id, available);
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Stationary",
        context: context,
        subtitle: "Update Availability",
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
                tryAgainFunc: () => {},
                pop2Pages: true,
              ),
            );
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  Provider.of<AvailabilityProvider>(context, listen: false)
                      .fetchAvailableItems();
                });
              },
              child: const Center(
                child: Text("Error"),
              ),
            );
          } else {
            return Consumer<AvailabilityProvider>(
              builder: (ctx, availabilityData, child) => RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    availabilityData.fetchAvailableItems();
                  });
                },
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    itemBuilder: (ctx, i) => UpdateIsAvailableCard(
                      itemName: availabilityData.availableItems[i].materialType,
                      setFunc: () {
                        setState(() {});
                      },
                      switchFunc: () => updateAvailabilityFunc(
                        availabilityData,
                        availabilityData.availableItems[i].id,
                        availabilityData.availableItems[i].isAvailable,
                      ),
                      isAvailable:
                          availabilityData.availableItems[i].isAvailable,
                      key: Key(availabilityData.availableItems[i].id),
                    ),
                    itemCount: availabilityData.availableItems.length,
                  ),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNav(
        isSelected: "Stationary",
        showOnlyOne: true,
      ),
    );
  }
}
