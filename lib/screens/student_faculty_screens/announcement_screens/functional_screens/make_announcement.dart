import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../providers/announcements/announcement_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/ui_widgets/tiles/pdf_tile.dart';
import '../../../../widgets/ui_widgets/inputs/form_input_text_field.dart';
import '../../../../widgets/ui_widgets/inputs/input_dropdown.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/general/themes.dart';
import '../../../../utils/helpers/loader.dart';
import '../../../../utils/helpers/error_dialog.dart';

class MakeAnnouncementScreen extends StatefulWidget {
  static const routeName = "/announcements/makeAnnouncement";
  const MakeAnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<MakeAnnouncementScreen> createState() => _MakeAnnouncementScreenState();
}

class _MakeAnnouncementScreenState extends State<MakeAnnouncementScreen> {
  final _announcementFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _editing = false;
  Announcement? _announcementToBeEdited;

  String? levelDropDownValue;
  String? deptDropDownValue;
  String? titleTextValue;
  String? descriptionTextValue;
  FilePickerResult? _attachment;
  File? _pickedAttachmentName;
  String? _attachmentName;
  String? _announcementId; //this is only if we are editing an announcement
  //to change the pdf card accordingly
  bool _editedAttachmentChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var _arguments = {};
    setState(() {
      _arguments = ModalRoute.of(context)?.settings.arguments as Map;
      _editing = _arguments['announcementToEdit'] != null;
      if (_editing) {
        _announcementToBeEdited = _arguments['announcementToEdit'];
        if (_editing) {
          titleTextValue = _announcementToBeEdited?.title ?? "";
          descriptionTextValue = _announcementToBeEdited?.description ?? "";
          _attachmentName = _announcementToBeEdited?.posterFileName;
          levelDropDownValue = _announcementToBeEdited?.level;
          deptDropDownValue = _announcementToBeEdited?.department;
          _announcementId = _announcementToBeEdited?.id;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _levelController.dispose();
    _departmentController.dispose();
    _descriptionController.dispose();
    _attachment = null;
    super.dispose();
  }

  List<DropdownMenuItem<String>> get levelDropdownItems {
    List<DropdownMenuItem<String>> levelItems = const [
      DropdownMenuItem(child: Text("College"), value: "College"),
      DropdownMenuItem(child: Text("Department"), value: "Department"),
      DropdownMenuItem(child: Text("Class"), value: "Class"),
      DropdownMenuItem(child: Text("Placements"), value: "Placements"),
      DropdownMenuItem(child: Text("Staff"), value: "Staff"),
      DropdownMenuItem(child: Text("Faculty"), value: "Faculty"),
    ];
    return levelItems;
  }

  List<DropdownMenuItem<String>> get deptDropdownItems {
    List<DropdownMenuItem<String>> levelItems = const [
      DropdownMenuItem(child: Text("CSE"), value: "CSE"),
      DropdownMenuItem(child: Text("ISE"), value: "ISE"),
      DropdownMenuItem(child: Text("AIML"), value: "AIML"),
      DropdownMenuItem(child: Text("ECE"), value: "ECE"),
      DropdownMenuItem(child: Text("EEE"), value: "EEE"),
      DropdownMenuItem(child: Text("ETE"), value: "ETE"),
      DropdownMenuItem(child: Text("MECH"), value: "MECH"),
      DropdownMenuItem(child: Text("CIVIL"), value: "CIVIL"),
    ];
    return levelItems;
  }

  Future<void> _pickAttachment() async {
    _editedAttachmentChanged = true;
    _attachment = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);
    _pickedAttachmentName = File(_attachment?.files.single.path ?? "");
    _attachmentName = _attachment?.files.single.name;
    setState(() => {});
  }

  void setAnnouncement(String val, String fieldToSet) {
    switch (fieldToSet) {
      case "Level":
        setState(() => {});
        levelDropDownValue = val;
        break;
      case "Department":
        deptDropDownValue = val;
        break;
      case 'Title':
        titleTextValue = val;
        break;
      case 'Description':
        descriptionTextValue = val;
        break;
    }
  }

  Future<void> submitForm() async {
    final isValid = _announcementFormKey.currentState?.validate();
    if (titleTextValue == null) {
      dialog(
        ctx: context,
        errorMessage: "Check the fields",
      );
      return;
    }
    try {
      if (isValid != null && !isValid) {
        dialog(
          ctx: context,
          errorMessage: "Check the fields",
        );
        return;
      }
      setState(() => _isLoading = true);
      if (!_editing) {
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .makeAnnouncement(
          title: titleTextValue ?? "Default",
          description: descriptionTextValue ?? "No Description",
          level: levelDropDownValue!,
          department: deptDropDownValue,
          poster: _pickedAttachmentName,
        );
        await dialog(
          ctx: context,
          errorMessage: "Announcement Made Successfully!",
          title: "Success",
          pop2Pages: true,
        );
      } else {
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .editAnnouncement(
          id: _announcementId ?? "",
          title: titleTextValue ?? "Default",
          description: descriptionTextValue ?? "No Description",
          level: levelDropDownValue!,
          department: deptDropDownValue,
          poster: _pickedAttachmentName,
        );
        await dialog(
          ctx: context,
          errorMessage: "Announcement Edited Successfully!",
          title: "Success",
          pop2Pages: true,
        );
      }
      setState(() => _isLoading = false);
    } catch (e) {
      await dialog(ctx: context, errorMessage: e.toString());
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Announcement",
        context: context,
        subtitle: "Make an Announcement",
      ),
      body: Center(
        child: _isLoading
            ? SISACLoader()
            : Form(
                key: _announcementFormKey,
                child: SizedBox(
                  width: 90.w,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      FormInputTextField(
                        initialValue: titleTextValue != null
                            ? titleTextValue!.isEmpty
                                ? null
                                : titleTextValue
                            : null,
                        title: "Title",
                        controller: titleTextValue != null
                            ? titleTextValue!.isNotEmpty
                                ? null
                                : _titleController
                            : null,
                        setter: setAnnouncement,
                      ),
                      DropDownInputForm(
                        title: "Level",
                        dropDownMenuItems: levelDropdownItems,
                        value: levelDropDownValue ?? 'College',
                        setter: setAnnouncement,
                      ),
                      levelDropDownValue == 'Department'
                          ? DropDownInputForm(
                              title: "Department",
                              dropDownMenuItems: deptDropdownItems,
                              value: deptDropDownValue ?? 'CSE',
                              setter: setAnnouncement,
                            )
                          : const SizedBox(),
                      FormInputTextField(
                        title: "Description",
                        initialValue: descriptionTextValue != null
                            ? descriptionTextValue!.isEmpty
                                ? null
                                : descriptionTextValue
                            : null,
                        maxLines: 4,
                        description: true,
                        controller: descriptionTextValue != null
                            ? descriptionTextValue!.isNotEmpty
                                ? null
                                : _descriptionController
                            : null,
                        setter: setAnnouncement,
                      ),
                      _editedAttachmentChanged ||
                              _announcementToBeEdited?.posterUrl == null
                          ? _editing ||
                                  _announcementToBeEdited?.posterUrl == null
                              ? AddAttachmentCard(
                                  title: _attachment == null &&
                                          _attachmentName == null
                                      ? "Pick Attachment"
                                      : _attachmentName ?? "Pick",
                                  attachmentFunc: _pickAttachment,
                                )
                              : PDFCard(
                                  pdfUrl: _announcementToBeEdited!.posterUrl!,
                                  showChangeButton: true,
                                  changeFunction: _pickAttachment,
                                )
                          : PDFCard(
                              pdfUrl: _announcementToBeEdited!.posterUrl!,
                              showChangeButton: true,
                              changeFunction: _pickAttachment,
                            ),
                      SizedBox(height: 4.h),
                      ElevatedButton(
                        onPressed: submitForm,
                        //     () {
                        //   // _announcementFormKey.currentState?.validate();
                        //   print("CONT" + _titleController.text);
                        //   print(titleTextValue);
                        //   print(_pickedAttachmentName);
                        //   print(deptDropDownValue);
                        //   print(levelDropDownValue);
                        //   print(descriptionTextValue);
                        // },
                        child: const Text("Confirm"),
                        style: ButtonThemes.elevatedButtonConfirmation,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      // bottomNavigationBar: BottomNav(
      //   isSelected: "Announcements",
      //   pageController: _pageController,
      // ),
    );
  }
}

class AddAttachmentCard extends StatelessWidget {
  final String title;
  final Function attachmentFunc;
  const AddAttachmentCard({
    required this.title,
    required this.attachmentFunc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.w,
      child: ListTile(
        tileColor: SecondaryPallete.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.sp),
        ),
        leading: Icon(
          Icons.picture_as_pdf_rounded,
          color: Palette.quinaryDefault,
          size: 32.sp,
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        onTap: () => attachmentFunc(),
      ),
    );
  }
}
