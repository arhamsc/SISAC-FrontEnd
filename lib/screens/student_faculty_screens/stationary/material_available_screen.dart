import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/stationary/material_available_providers.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../widgets/component_widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/component_widgets/stationary/display_cards/material_available_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

class MaterialAvailableScreen extends StatefulWidget {
  const MaterialAvailableScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/materialAvailable';

  @override
  State<MaterialAvailableScreen> createState() =>
      _MaterialAvailableScreenState();
}

class _MaterialAvailableScreenState extends State<MaterialAvailableScreen> {
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
        subtitle: "Materials",
      ),
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
                      vendor: false,
                      
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
      ),
    );
  }
}
