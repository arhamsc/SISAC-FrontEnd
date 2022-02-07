// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../providers/stationary/material_available_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../../widgets/ui_widgets/inputs/form_input_text_field.dart';
import '../../../../widgets/ui_widgets/inputs/form_image_input.dart';
import '../../../../widgets/ui_widgets/inputs/input_dropdown.dart';

import '../../../../utils/general/screen_size.dart';
import '../../../../utils/general/themes.dart';
import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/loader.dart';

/* Stationary - Add/Edit Materials */
class AddEditMaterialAvailableScreen extends StatefulWidget {
  static const routeName = '/stationary/vendor/addEditMaterialAvailable';
  const AddEditMaterialAvailableScreen({Key? key}) : super(key: key);

  @override
  _AddEditMaterialAvailableScreenState createState() =>
      _AddEditMaterialAvailableScreenState();
}

class _AddEditMaterialAvailableScreenState
    extends State<AddEditMaterialAvailableScreen> {
  File? _storedStationaryImage;
  final _formKey1 = GlobalKey<FormState>();

  //controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isInit = true;
  bool _isLoading = false;
  bool _imageChanged = false;
  bool _editing = false;

  //Initial Material Data
  var _materialItem = MaterialAvailable(
    id: '',
    name: '',
    price: 0,
    materialType: '',
    imageUrl: '',
    imageFileName: '',
  );

  //Variable to store new Material data
  final _editedItem = {
    'name': '',
    'price': '',
    'materialType': '',
    'image': null,
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      /* Arguments Check to split Add or Edit functionality */
      final materialId = ModalRoute.of(context)?.settings.arguments as String;
      if (materialId.isNotEmpty) {
        _editing = true;
        _materialItem = Provider.of<MaterialAvailableProvider>(context)
            .findMaterialById(materialId);
        materialTypeDropDownValue = _materialItem.materialType;
      } else {
        _editing = false;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //Function to get a new Image
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

  //Setting Material item data
  void setMaterialItem(String val, String fieldToSet) {
    switch (fieldToSet) {
      case "Name":
        {
          _materialItem = MaterialAvailable(
            id: _materialItem.id,
            name: val,
            materialType: _materialItem.materialType,
            price: _materialItem.price,
            imageUrl: _materialItem.imageUrl,
            imageFileName: _materialItem.imageFileName,
          );
          break;
        }
      case "Price":
        {
          _materialItem = MaterialAvailable(
            id: _materialItem.id,
            name: _materialItem.name,
            materialType: _materialItem.materialType,
            price: int.parse(val),
            imageUrl: _materialItem.imageUrl,
            imageFileName: _materialItem.imageFileName,
          );
          break;
        }
      case "Material Type":
        {
          materialTypeDropDownValue = val;
        }
    }
  }

  String materialTypeDropDownValue = 'Stationary';

  /* Function to trigger HTTP request */
  Future<void> _saveForm({
    String? patchItemId,
    String? patchItemName,
    String? patchItemPrice,
    String? patchItemMaterialType,
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
      _editedItem['materialType'] = materialTypeDropDownValue;

      try {
        /* Function to create a new Material */
        await Provider.of<MaterialAvailableProvider>(context, listen: false)
            .newMaterial(
          _editedItem['name']!,
          _editedItem['price']!,
          materialTypeDropDownValue,
          _storedStationaryImage!,
        );
        await dialog(
          ctx: context,
          errorMessage: "Material Created",
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
            patchItemMaterialType != null) {
          if (_imageChanged) {
            /* Function to patch a material if Image has changed */
            await Provider.of<MaterialAvailableProvider>(context, listen: false)
                .patchMaterial(
              patchItemId,
              patchItemName,
              patchItemPrice,
              patchItemMaterialType,
              imageChanged: true,
              image: _storedStationaryImage,
            );
            await dialog(
              ctx: context,
              errorMessage: "Material Edited",
              title: "Success",
              pop2Pages: true,
            );
            setState(() {
              _isLoading = false;
            });
          } else {
            /* Function to patch the Material if image has NOT changed */
            await Provider.of<MaterialAvailableProvider>(context, listen: false)
                .patchMaterial(
              patchItemId,
              patchItemName,
              patchItemPrice,
              patchItemMaterialType,
              imageChanged: false,
            );
            await dialog(
              ctx: context,
              errorMessage: "Material Edited",
              title: "Success",
              pop2Pages: true,
            );
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          await dialog(
              ctx: context, errorMessage: "Patching Material not provided");
        }
      } catch (error) {
        await dialog(ctx: context, errorMessage: error.toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //Drop down item list for material type
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Stationary"), value: "Stationary"),
      DropdownMenuItem(child: Text("Food"), value: "Food"),
      DropdownMenuItem(child: Text("Reference"), value: "Reference"),
      DropdownMenuItem(child: Text("Service"), value: "Service"),
    ];
    return menuItems;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
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
                        //Material Name Input Widget
                        FormInputTextField(
                          title: "Name",
                          initialValue: _materialItem.name.isEmpty
                              ? null
                              : _materialItem.name,
                          controller: _materialItem.name.isEmpty
                              ? _nameController
                              : null,
                          setter: setMaterialItem,
                        ),
                        //Material Price Input Widget
                        FormInputTextField(
                          title: "Price",
                          initialValue: _materialItem.price == 0
                              ? null
                              : _materialItem.price.toString(),
                          controller: _materialItem.price == 0
                              ? _priceController
                              : null,
                          setter: setMaterialItem,
                          numberKeyboard: true,
                        ),
                        //Image Input Widget
                        FormImageInput(
                          displayImage: _storedStationaryImage,
                          pickImageFunc: _getImage,
                          initialImage:
                              !_imageChanged ? _materialItem.imageUrl : null,
                        ),
                        //Material Type dropdown
                        DropDownInputForm(
                          dropDownMenuItems: dropdownItems,
                          title: "Material Type",
                          value: materialTypeDropDownValue,
                          setter: setMaterialItem,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight(context) * .02,
                        ),
                        //Confirm Button
                        ElevatedButton(
                          onPressed: () async {
                            await _saveForm(
                              patchItemId: _materialItem.id,
                              patchItemName: _materialItem.name,
                              patchItemPrice: _materialItem.price.toString(),
                              patchItemMaterialType: materialTypeDropDownValue,
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
