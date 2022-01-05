import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/stationary/material_available_providers.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/stationary/material_available_card.dart';

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
    return await Provider.of<MaterialAvailableProvider>(context, listen: false)
        .fetchAllMaterials();
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
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: Column(
                children: [
                  Consumer<MaterialAvailableProvider>(
                    builder: (ctx, booksMaterialData, child) => Container(
                      child: SingleChildScrollView(
                        child: Container(
                          height: ScreenSize.usableHeight(context),
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => MaterialAvailableCard(
                              materialAvailable:
                                  booksMaterialData.materialsAvailable[i],
                              setStateFunc: () {
                                setState(() {});
                              },
                            ),
                            itemCount:
                                booksMaterialData.materialsAvailable.length,
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
