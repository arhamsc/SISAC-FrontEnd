// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../providers/stationary/books_material_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../../widgets/ui_widgets/inputs/form_input_text_field.dart';
import '../../../../widgets/ui_widgets/inputs/form_image_input.dart';

import '../../../../utils/general/screen_size.dart';
import '../../../../utils/general/themes.dart';
import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/loader.dart';

/* Stationary - Add/Edit Books */
class AddEditStationaryItemScreen extends StatefulWidget {
  static const routeName = '/stationary/vendor/addEditStationaryItem';
  const AddEditStationaryItemScreen({Key? key}) : super(key: key);

  @override
  _AddEditStationaryItemScreenState createState() =>
      _AddEditStationaryItemScreenState();
}

class _AddEditStationaryItemScreenState
    extends State<AddEditStationaryItemScreen> {
  File? _storedStationaryImage;
  final _formKey1 = GlobalKey<FormState>();

  //controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _editionController = TextEditingController();
  final _authorController = TextEditingController();

  bool _isInit = true;
  bool _isLoading = false;
  bool _imageChanged = false;
  bool _editing = false;

  //Initial Book Data
  var _bookItem = BooksMaterial(
    id: '',
    name: '',
    price: 0,
    author: '',
    edition: 0,
    imageUrl: '',
    imageFileName: '',
  );

  //Data to store new Book details
  final _editedItem = {
    'name': '',
    'author': '',
    'edition': '',
    'price': '',
    'image': null,
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      /* Arguments Check to split Add or Edit functionality */
      final bookId = ModalRoute.of(context)?.settings.arguments as String;
      if (bookId.isNotEmpty) {
        _editing = true;
        _bookItem =
            Provider.of<BooksMaterialProvider>(context).findBookById(bookId);
      } else {
        _editing = false;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  /* Image getting function */
  Future<void> _getImage({
    bool camera = true,
  }) async {
    final _picker = ImagePicker();
    XFile? _pickedImage;
    if (camera) {
      _pickedImage =
          await _picker.pickImage(source: ImageSource.camera, maxWidth: 400);
    } else {
      _pickedImage =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 400);
    }
    setState(() {
      _imageChanged = true;
      _storedStationaryImage =
          _pickedImage != null ? File(_pickedImage.path) : null;
    });
  }

  /* Book Data setter to fields according to the given title */
  void setBookItem(String val, String fieldToSet) {
    switch (fieldToSet) {
      case "Name":
        {
          _bookItem = BooksMaterial(
            id: _bookItem.id,
            name: val,
            author: _bookItem.author,
            edition: _bookItem.edition,
            price: _bookItem.price,
            imageUrl: _bookItem.imageUrl,
            imageFileName: _bookItem.imageFileName,
          );
          break;
        }
      case "Price":
        {
          _bookItem = BooksMaterial(
            id: _bookItem.id,
            name: _bookItem.name,
            author: _bookItem.author,
            edition: _bookItem.edition,
            price: int.parse(val),
            imageUrl: _bookItem.imageUrl,
            imageFileName: _bookItem.imageFileName,
          );
          break;
        }
      case "Edition":
        {
          _bookItem = BooksMaterial(
            id: _bookItem.id,
            name: _bookItem.name,
            edition: int.parse(val),
            author: _bookItem.author,
            price: _bookItem.price,
            imageUrl: _bookItem.imageUrl,
            imageFileName: _bookItem.imageFileName,
          );
          break;
        }
      case "Author":
        {
          _bookItem = BooksMaterial(
            id: _bookItem.id,
            name: _bookItem.name,
            edition: _bookItem.edition,
            author: val,
            price: _bookItem.price,
            imageUrl: _bookItem.imageUrl,
            imageFileName: _bookItem.imageFileName,
          );
          break;
        }
    }
  }

  /* Save form function to trigger HTTP request */
  Future<void> _saveForm({
    String? patchItemId,
    String? patchItemName,
    String? patchItemPrice,
    String? patchItemAuthor,
    String? patchItemEdition,
  }) async {
    final isValid = _formKey1.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _formKey1.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (!_editing) {
      _editedItem['name'] = _nameController.text;
      _editedItem['price'] = _priceController.text;
      _editedItem['author'] = _authorController.text;
      _editedItem['edition'] = _editionController.text;

      try {
        /* Function to insert a new book */
        await Provider.of<BooksMaterialProvider>(context, listen: false)
            .newBook(
          _editedItem['name']!,
          _editedItem['price']!,
          _editedItem['author']!,
          _editedItem['edition']!,
          _storedStationaryImage!,
        );
        await dialog(
          ctx: context,
          errorMessage: "Book Created",
          title: "Success",
          pop2Pages: true,
        );
        setState(() {
          _isLoading = false;
        });
      } on HttpException catch (error) {
        await dialog(ctx: context, errorMessage: error.toString());
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      try {
        if (patchItemId != null &&
            patchItemName != null &&
            patchItemPrice != null &&
            patchItemAuthor != null &&
            patchItemEdition != null) {
          if (_imageChanged) {
            /* Function to patch the book if there is a new Image */
            await Provider.of<BooksMaterialProvider>(context, listen: false)
                .patchBook(
              patchItemId,
              patchItemName,
              patchItemPrice,
              patchItemAuthor,
              patchItemEdition,
              imageChanged: true,
              image: _storedStationaryImage,
            );
            await dialog(
              ctx: context,
              errorMessage: "Book Edited",
              title: "Success",
              pop2Pages: true,
            );
            setState(() {
              _isLoading = false;
            });
          } else {
            /* Function to patch the book if there is no new Image */
            await Provider.of<BooksMaterialProvider>(context, listen: false)
                .patchBook(
              patchItemId,
              patchItemName,
              patchItemPrice,
              patchItemAuthor,
              patchItemEdition,
              imageChanged: false,
            );
            await dialog(
              ctx: context,
              errorMessage: "Book Edited",
              title: "Success",
              pop2Pages: true,
            );
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          await dialog(
              ctx: context, errorMessage: "Patching Book not provided");
        }
      } catch (error) {
        await dialog(ctx: context, errorMessage: error.toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _authorController.dispose();
    _editionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Stationary",
        context: context,
        subtitle: _editing ? "Edit Book" : "Add Book",
        showActions: false,
      ),
      body: SizedBox(
        height: ScreenSize.usableHeight(context),
        child: Center(
          child: _isLoading
              ? SISACLoader()
              : Form(
                  key: _formKey1,
                  child: SizedBox(
                    width: ScreenSize.screenWidth(context) * .76,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //Name Input Widget
                        FormInputTextField(
                          title: "Name",
                          initialValue:
                              _bookItem.name.isEmpty ? null : _bookItem.name,
                          controller:
                              _bookItem.name.isEmpty ? _nameController : null,
                          setter: setBookItem,
                        ),
                        //Author Input Widget
                        FormInputTextField(
                          title: "Author",
                          initialValue: _bookItem.author.isEmpty
                              ? null
                              : _bookItem.author,
                          controller: _bookItem.author.isEmpty
                              ? _authorController
                              : null,
                          setter: setBookItem,
                        ),
                        //Image Input Image
                        FormImageInput(
                          displayImage: _storedStationaryImage,
                          pickImageFunc: _getImage,
                          initialImage:
                              !_imageChanged ? _bookItem.imageUrl : null,
                        ),
                        //Edition Input Image
                        FormInputTextField(
                          title: "Edition",
                          initialValue: _bookItem.edition == 0
                              ? null
                              : _bookItem.edition.toString(),
                          controller: _bookItem.edition == 0
                              ? _editionController
                              : null,
                          setter: setBookItem,
                          numberKeyboard: true,
                        ),
                        //Price Input Image
                        FormInputTextField(
                          title: "Price",
                          initialValue: _bookItem.price == 0
                              ? null
                              : _bookItem.price.toString(),
                          controller:
                              _bookItem.price == 0 ? _priceController : null,
                          setter: setBookItem,
                          numberKeyboard: true,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight(context) * .02,
                        ),
                        //Confirm Button
                        ElevatedButton(
                          onPressed: () async {
                            await _saveForm(
                              patchItemId: _bookItem.id,
                              patchItemName: _bookItem.name,
                              patchItemPrice: _bookItem.price.toString(),
                              patchItemAuthor: _bookItem.author,
                              patchItemEdition: _bookItem.edition.toString(),
                            );
                          },
                          child: const Text("Confirm"),
                          style: ButtonThemes.elevatedButtonConfirmation,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const BottomNav(
        isSelected: "Stationary",
        showOnlyOne: true,
      ),
    );
  }
}
