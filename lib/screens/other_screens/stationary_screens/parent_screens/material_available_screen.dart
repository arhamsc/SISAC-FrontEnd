import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/stationary/material_available_providers.dart';

import '../../../../screens/other_screens/stationary_screens/updation_screens/add_edit_material_available_screen.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/bottom_nav.dart';
import '../../../../widgets/component_widgets/stationary/display_cards/material_available_card.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/general/screen_size.dart';

class VendorMaterialAvailableScreen extends StatefulWidget {
  const VendorMaterialAvailableScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/vendor/materials_available';

  @override
  State<VendorMaterialAvailableScreen> createState() =>
      _VendorMaterialAvailableScreenState();
}

class _VendorMaterialAvailableScreenState
    extends State<VendorMaterialAvailableScreen> {
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<MaterialAvailableProvider>(context, listen: false)
          .fetchAllMaterials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
          title: "Stationary",
          context: context,
          subtitle: "Materials-Vendor",
          showAddIcon: true,
          addButtonFunc: () {
            Navigator.of(context).pushNamed(
              AddEditMaterialAvailableScreen.routeName,
              arguments: '',
            );
          }),
      body: FutureBuilder(
        future: Provider.of<MaterialAvailableProvider>(context, listen: false)
            .fetchAllMaterials(),
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
            return Consumer<MaterialAvailableProvider>(
              builder: (ctx, booksMaterialData, child) => RefreshIndicator(
                onRefresh: () => _refreshItems(context),
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    itemBuilder: (ctx, i) => MaterialAvailableCard(
                      materialAvailable:
                          booksMaterialData.materialsAvailable[i],
                      setStateFunc: () {
                        setState(() {});
                      },
                      vendor: true,
                    ),
                    itemCount: booksMaterialData.materialsAvailable.length,
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
