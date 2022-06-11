import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../providers/announcements/announcement_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/ui_widgets/inputs/form_input_text_field.dart';
import '../../../../widgets/ui_widgets/inputs/input_dropdown.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/general/themes.dart';

class MakeAnnouncementScreen extends StatefulWidget {
  static const routeName = "/announcements/makeAnnouncement";
  const MakeAnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<MakeAnnouncementScreen> createState() => _MakeAnnouncementScreenState();
}

class _MakeAnnouncementScreenState extends State<MakeAnnouncementScreen> {
  final _announcementFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  var _announcementFields = {
    'title': '',
    'level': '',
    'department': '',
    'description': '',
    'links': [],
  };

  @override
  void dispose() {
    _titleController.dispose();
    _levelController.dispose();
    _departmentController.dispose();
    _descriptionController.dispose();
    _attachment = null;
    super.dispose();
  }

  String levelDropDownValue = 'College';
  String deptDropDownValue = 'CSE';
  String titleTextValue = '';
  String descriptionTextValue = '';
  FilePickerResult? _attachment;

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
    _attachment = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);
    //File _pickedAttachmentName = File(_attachment?.files.single.name ?? "");
    setState(() => {}); //to update the button text
    //print(_pickedAttachmentName);
  }

  void setAnnouncement(String val, String fieldToSet) {
    switch (fieldToSet) {
      case "Level":
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

  @override
  Widget build(BuildContext context) {
    final _arguments = (ModalRoute.of(context)?.settings.arguments as Map);
    final PageController _pageController = _arguments['pageController'];
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Announcement",
        context: context,
        subtitle: "Make an Announcement",
      ),
      body: Center(
        child: Form(
          key: _announcementFormKey,
          child: SizedBox(
            width: 90.w,
            child: ListView(
              shrinkWrap: true,
              children: [
                FormInputTextField(
                  title: "Title",
                  controller: _titleController,
                  setter: setAnnouncement,
                ),
                DropDownInputForm(
                  title: "Level",
                  dropDownMenuItems: levelDropdownItems,
                  value: levelDropDownValue,
                  setter: setAnnouncement,
                ),
                DropDownInputForm(
                  title: "Department",
                  dropDownMenuItems: deptDropdownItems,
                  value: deptDropDownValue,
                  setter: setAnnouncement,
                ),
                FormInputTextField(
                  title: "Description",
                  maxLines: 4,
                  description: true,
                  controller: _descriptionController,
                  setter: setAnnouncement,
                ),
                AddAttachmentCard(
                  title: _attachment == null
                      ? "Pick Attachment"
                      : _attachment?.files.single.name ?? "Pick",
                  pickAttachment: _pickAttachment,
                ),
                SizedBox(height: 4.h),
                ElevatedButton(
                  onPressed: () {
                    print(deptDropDownValue);
                    print(levelDropDownValue);
                    print(titleTextValue);
                    print(descriptionTextValue);
                    print(_attachment?.files.single.name);
                  },
                  child: const Text("Confirm"),
                  style: ButtonThemes.elevatedButtonConfirmation,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        isSelected: "Announcements",
        pageController: _pageController,
      ),
    );
  }
}

class AddAttachmentCard extends StatelessWidget {
  final String title;
  final Function pickAttachment;
  const AddAttachmentCard({
    required this.title,
    required this.pickAttachment,
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
        onTap: () => pickAttachment(),
      ),
    );
  }
}
