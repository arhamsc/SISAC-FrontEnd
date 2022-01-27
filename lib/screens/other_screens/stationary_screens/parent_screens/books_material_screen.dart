import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/screens/other_screens/stationary_screens/updation_screens/add_edit_book_screen.dart';

import '../../../../providers/stationary/books_material_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/bottom_nav.dart';
import '../../../../widgets/component_widgets/stationary/display_cards/books_material_card.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/general/screen_size.dart';

class VendorBooksMaterialScreen extends StatefulWidget {
  const VendorBooksMaterialScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/vendor/booksMaterial';

  @override
  State<VendorBooksMaterialScreen> createState() =>
      _VendorBooksMaterialScreenState();
}

class _VendorBooksMaterialScreenState extends State<VendorBooksMaterialScreen> {
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<BooksMaterialProvider>(context, listen: false)
          .fetchAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
          title: "Stationary",
          context: context,
          subtitle: "Book Material",
          showAddIcon: true,
          addButtonFunc: () {
            Navigator.of(context).pushNamed(
              AddEditStationaryItemScreen.routeName,
              arguments: '',
            );
          }),
      body: FutureBuilder(
        future: Provider.of<BooksMaterialProvider>(context, listen: false)
            .fetchAllBooks(),
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
            return Consumer<BooksMaterialProvider>(
              builder: (ctx, booksMaterialData, child) => RefreshIndicator(
                onRefresh: () => _refreshItems(context),
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    itemBuilder: (ctx, i) => BooksMaterialCard(
                      booksMaterial: booksMaterialData.booksMaterial[i],
                      setStateFunc: () {
                        setState(() {});
                      },
                      vendor: true,
                    ),
                    itemCount: booksMaterialData.booksMaterial.length,
                    
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
