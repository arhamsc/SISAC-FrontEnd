import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/stationary/books_material_providers.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../widgets/component_widgets/stationary/display_cards/books_material_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/helpers/loader.dart';
import '../../../utils/general/screen_size.dart';

/* Stationary - Screen to View Books */
class BooksMaterialScreen extends StatefulWidget {
  const BooksMaterialScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/booksMaterial';

  @override
  State<BooksMaterialScreen> createState() => _BooksMaterialScreenState();
}

class _BooksMaterialScreenState extends State<BooksMaterialScreen> {
  /* Pull to Refresh Function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<BooksMaterialProvider>(context, listen: false)
          .fetchAllBooks();
    });
  }

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
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
            return Center(
              child: SISACLoader(),
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
            return Consumer<BooksMaterialProvider>(
              builder: (ctx, booksMaterialData, child) => _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshItems(context),
                      child: SizedBox(
                        height: ScreenSize.usableHeight(context),
                        child: ListView.builder(
                          /* Card to Render Books */
                          itemBuilder: (ctx, i) => BooksMaterialCard(
                            booksMaterial: booksMaterialData.booksMaterial[i],
                            setStateFunc: () {
                              setState(() {});
                            },
                            vendor: false,
                          ),
                          itemCount: booksMaterialData.booksMaterial.length,
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
