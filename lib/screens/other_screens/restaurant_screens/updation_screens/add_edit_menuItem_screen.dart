// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart' as CafeP;
import '../../../../providers/cafetaria/restaurant_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../../widgets/ui_widgets/inputs/form_input_text_field.dart';
import '../../../../widgets/ui_widgets/inputs/form_image_input.dart';

import '../../../../utils/general/screen_size.dart';
import '../../../../utils/general/themes.dart';
import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/loader.dart';

/* Restaurant - Add/Edit a Menu Item Screen */
class AddEditMenuItemScreen extends StatefulWidget {
  static const routeName = '/cafetaria/restaurant/addEditMenuItem';
  const AddEditMenuItemScreen({Key? key}) : super(key: key);

  @override
  _AddEditMenuItemScreenState createState() => _AddEditMenuItemScreenState();
}

class _AddEditMenuItemScreenState extends State<AddEditMenuItemScreen> {
  File? _storedMenuImage;
  final _formKey = GlobalKey<FormState>();

  //controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isInit = true;
  bool _isLoading = false;
  bool _imageChanged = false;
  bool _editing = false;

  //Initial MenuItem
  var _menuItem = CafeP.MenuItem(
    id: '',
    name: '',
    description: '',
    rating: 0,
    price: 0,
    imageUrl: '',
    isAvailable: false,
    imageFileName: '',
  );

  //Edited item to store newly created value
  final _editedItem = {
    'name': '',
    'description': '',
    'price': '',
    'image': null,
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      /* Checking for ID to split between Editing or Adding Functionality */
      final menuId = ModalRoute.of(context)?.settings.arguments as String;
      if (menuId.isNotEmpty) {
        _editing = true;
        _menuItem =
            Provider.of<CafeP.MenuItemProvider>(context).findMenuById(menuId);
      } else {
        _editing = false;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  /* Image Getting function */
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
      _storedMenuImage = _pickedImage != null ? File(_pickedImage.path) : null;
    });
  }

  set nameSet(String name) {
    _editedItem['name'] = name;
  }

  /* Function to set the MenuItem details when edited for various fields according to the given title */
  void setItem(String val, String fieldToSet) {
    switch (fieldToSet) {
      case "Name":
        {
          _menuItem = CafeP.MenuItem(
            id: _menuItem.id,
            name: val,
            description: _menuItem.description,
            rating: _menuItem.rating,
            price: _menuItem.price,
            imageUrl: _menuItem.imageUrl,
            isAvailable: _menuItem.isAvailable,
            imageFileName: _menuItem.imageFileName,
          );
          break;
        }
      case "Price":
        {
          _menuItem = CafeP.MenuItem(
            id: _menuItem.id,
            name: _menuItem.name,
            description: _menuItem.description,
            rating: _menuItem.rating,
            price: int.parse(val),
            imageUrl: _menuItem.imageUrl,
            isAvailable: _menuItem.isAvailable,
            imageFileName: _menuItem.imageFileName,
          );
          break;
        }
      case "Description":
        {
          _menuItem = CafeP.MenuItem(
            id: _menuItem.id,
            name: _menuItem.name,
            description: val,
            rating: _menuItem.rating,
            price: _menuItem.price,
            imageUrl: _menuItem.imageUrl,
            isAvailable: _menuItem.isAvailable,
            imageFileName: _menuItem.imageFileName,
          );
          break;
        }
    }
  }

  /* Saving form function to Send HTTP Request and trigger validators */
  Future<void> _saveForm(
      {String? patchItemId,
      String? patchItemName,
      String? patchItemPrice,
      String? patchItemDescription}) async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (!_editing) {
      _editedItem['name'] = _nameController.text;
      _editedItem['price'] = _priceController.text;
      _editedItem['description'] = _descriptionController.text;

      try {
        /* Creating new Menu Item Function from Provider */
        await Provider.of<RestaurantProvider>(context, listen: false)
            .newMenuItem(
          _editedItem['name']!,
          _editedItem['price']!,
          _editedItem['description']!,
          _storedMenuImage!,
        );
        await dialog(
          ctx: context,
          errorMessage: "Menu Item Created",
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
            patchItemDescription != null) {
          if (_imageChanged) {
            /* Patch the Menu Item if new Image Added */
            await Provider.of<RestaurantProvider>(context, listen: false)
                .patchMenuitem(
              patchItemId,
              patchItemName,
              patchItemPrice,
              patchItemDescription,
              imageChanged: true,
              image: _storedMenuImage,
            );
            await dialog(
              ctx: context,
              errorMessage: "Menu Item Edited",
              title: "Success",
              pop2Pages: true,
            );
            setState(() {
              _isLoading = false;
            });
          } else {
            /* Patch Menu Item if image has not been changed */
            await Provider.of<RestaurantProvider>(context, listen: false)
                .patchMenuitem(
              patchItemId,
              patchItemName,
              patchItemPrice,
              patchItemDescription,
              imageChanged: false,
            );
            await dialog(
              ctx: context,
              errorMessage: "Menu Item Edited",
              title: "Success",
              pop2Pages: true,
            );
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          await dialog(
              ctx: context, errorMessage: "Patching Item not provided");
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
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Cafetaria",
        context: context,
        subtitle: _editing ? "Edit Menu Item" : "Add Menu Item",
        showActions: false,
      ),
      body: SizedBox(
        height: ScreenSize.usableHeight(context),
        child: Center(
          child: _isLoading
              ? SISACLoader()
              : Form(
                  key: _formKey,
                  child: SizedBox(
                    width: ScreenSize.screenWidth(context) * .76,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //Name Input Widget
                        FormInputTextField(
                          title: "Name",
                          initialValue:
                              _menuItem.name.isEmpty ? null : _menuItem.name,
                          controller:
                              _menuItem.name.isEmpty ? _nameController : null,
                          setter: setItem,
                        ),
                        //Price Input Widget
                        FormInputTextField(
                          title: "Price",
                          initialValue: _menuItem.price == 0
                              ? null
                              : _menuItem.price.toString(),
                          numberKeyboard: true,
                          controller:
                              _menuItem.price == 0 ? _priceController : null,
                          setter: setItem,
                        ),
                        //Image Input Widget
                        FormImageInput(
                          displayImage: _storedMenuImage,
                          pickImageFunc: _getImage,
                          initialImage:
                              !_imageChanged ? _menuItem.imageUrl : null,
                        ),
                        //Description Input Widget
                        FormInputTextField(
                          title: "Description",
                          initialValue: _menuItem.description.isEmpty
                              ? null
                              : _menuItem.description,
                          description: true,
                          maxLines: 5,
                          controller: _menuItem.description.isEmpty
                              ? _descriptionController
                              : null,
                          setter: setItem,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight(context) * .02,
                        ),
                        //Confirmation Button
                        ElevatedButton(
                          onPressed: () async {
                            await _saveForm(
                              patchItemId: _menuItem.id,
                              patchItemName: _menuItem.name,
                              patchItemPrice: _menuItem.price.toString(),
                              patchItemDescription: _menuItem.description,
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
        isSelected: "Cafetaria",
        showOnlyOne: true,
      ),
    );
  }
}
