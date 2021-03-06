import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/screens/other_screens/stationary_screens/updation_screens/add_edit_book_screen.dart';

import '../../../../providers/stationary/books_material_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/stationary/display_cards/books_material_card.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/confirmation_dialog.dart';
import '../../../../utils/helpers/loader.dart';
import '../../../../utils/general/screen_size.dart';
/* Stationary - Screen to Add/Edit Books */
class VendorBooksMaterialScreen extends StatefulWidget {
  const VendorBooksMaterialScreen({Key? key}) : super(key: key);
  static const routeName = '/stationary/vendor/booksMaterial';

  @override
  State<VendorBooksMaterialScreen> createState() =>
      _VendorBooksMaterialScreenState();
}

class _VendorBooksMaterialScreenState extends State<VendorBooksMaterialScreen> {
  /* Pull To Refresh Function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<BooksMaterialProvider>(context, listen: false)
          .fetchAllBooks();
    });
  }

  bool _isLoading = false;

  /* Deleting a book Function */
  Future<void> _deleteBook(BooksMaterialProvider bookP, String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await bookP.deleteBook(id);
      setState(() {
        _isLoading = false;
      });
      await dialog(
          ctx: context, errorMessage: "Book Deleted", title: "Success");
    } catch (error) {
      await dialog(ctx: context, errorMessage: "Failed to delete the Book");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showDeleteDialog(BooksMaterialProvider bookP, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Are you sure?",
          content: "Deleting the book!",
          confirmationFunction: () => _deleteBook(bookP, id),
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
        subtitle: "Book Material",
        showAddIcon: true,
        addButtonFunc: () {
          Navigator.of(context).pushNamed(
            AddEditStationaryItemScreen.routeName,
            arguments: '',
          );
        },
      ),
      body: FutureBuilder(
        future: Provider.of<BooksMaterialProvider>(context, listen: false)
            .fetchAllBooks(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: SISACLoader());
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
                          /* Card to render Books */
                          itemBuilder: (ctx, i) => BooksMaterialCard(
                            booksMaterial: booksMaterialData.booksMaterial[i],
                            setStateFunc: () {
                              setState(() {});
                            },
                            vendor: true,
                            deleteFunc: () => _showDeleteDialog(
                              booksMaterialData,
                              booksMaterialData.booksMaterial[i].id,
                            ),
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
