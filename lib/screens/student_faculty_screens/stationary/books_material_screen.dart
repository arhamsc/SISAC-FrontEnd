import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/stationary/books_material_providers.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../widgets/component_widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/component_widgets/stationary/display_cards/books_material_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

class BooksMaterialScreen extends StatefulWidget {
  const BooksMaterialScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/booksMaterial';

  @override
  State<BooksMaterialScreen> createState() => _BooksMaterialScreenState();
}

class _BooksMaterialScreenState extends State<BooksMaterialScreen> {
  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<BooksMaterialProvider>(context, listen: false)
        .fetchAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Stationary",
        context: context,
        subtitle: "Book Material",
      ),
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
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: Column(
                children: [
                  Consumer<BooksMaterialProvider>(
                    builder: (ctx, booksMaterialData, child) => Container(
                      child: SingleChildScrollView(
                        child: Container(
                          height: ScreenSize.usableHeight(context),
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => BooksMaterialCard(
                              booksMaterial: booksMaterialData.booksMaterial[i],
                              setStateFunc: () {
                                setState(() {});
                              },
                            ),
                            itemCount: booksMaterialData.booksMaterial.length,
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
