import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/stationary/material_available_providers.dart';

import '../../../../screens/other_screens/stationary_screens/updation_screens/add_edit_material_available_screen.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/stationary/display_cards/material_available_card.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/confirmation_dialog.dart';
import '../../../../utils/general/screen_size.dart';

/* Stationary - Screen to Add/Edit Materials Available */
class VendorMaterialAvailableScreen extends StatefulWidget {
  const VendorMaterialAvailableScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/vendor/materials_available';

  @override
  State<VendorMaterialAvailableScreen> createState() =>
      _VendorMaterialAvailableScreenState();
}

class _VendorMaterialAvailableScreenState
    extends State<VendorMaterialAvailableScreen> {
  bool _isLoading = false;
  /* Pull to refresh function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<MaterialAvailableProvider>(context, listen: false)
          .fetchAllMaterials();
    });
  }

  /* Delete material function */
  Future<void> _deleteMaterialItem(
      MaterialAvailableProvider matP, String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await matP.deleteMaterial(id);
      setState(() {
        _isLoading = false;
      });
      await dialog(
        ctx: context,
        errorMessage: "Successfully Deleted",
        title: "Success",
      );
    } catch (error) {
      await dialog(
        ctx: context,
        errorMessage: "Could not delete the Item",
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showDeleteDialog(
      MaterialAvailableProvider matP, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Are you sure?",
          content: "Deleting a menu item.",
          confirmationFunction: () => _deleteMaterialItem(matP, id),
        );
      },
    );
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
              builder: (ctx, materialAvailableData, child) => _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshItems(context),
                      child: SizedBox(
                        height: ScreenSize.usableHeight(context),
                        child: ListView.builder(
                          /* Card to Render Material */
                          itemBuilder: (ctx, i) => MaterialAvailableCard(
                            materialAvailable:
                                materialAvailableData.materialsAvailable[i],
                            setStateFunc: () {
                              setState(() {});
                            },
                            vendor: true,
                            deleteFunction: () => _showDeleteDialog(
                                materialAvailableData,
                                materialAvailableData.materialsAvailable[i].id),
                          ),
                          itemCount:
                              materialAvailableData.materialsAvailable.length,
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
