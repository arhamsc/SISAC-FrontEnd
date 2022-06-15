import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../pdf_view.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/themes.dart';

class PDFCard extends StatelessWidget {
  final String pdfUrl;
  final bool showChangeButton;
  final Function? changeFunction;
  const PDFCard({
    required this.pdfUrl,
    required this.showChangeButton,
    this.changeFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.w,
      child: ListTile(
        tileColor: SecondaryPallete.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.sp),
        ),
        leading: Icon(
          Icons.picture_as_pdf_rounded,
          color: SecondaryPallete.primary,
          size: 32.sp,
        ),
        title: Center(
          //padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Text(
            "View attachment",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        trailing: showChangeButton
            ? ElevatedButton(
                onPressed: () => showChangeButton && changeFunction != null
                    ? changeFunction!()
                    : null,
                child: const Icon(Icons.edit),
                style: ButtonThemes.elevatedButtonConfirmation)
            : null,
        onTap: () => Navigator.of(context).pushNamed(
          PDFView.routeName,
          arguments: {
            'pdfData': {'url': pdfUrl}
          },
        ),
      ),
    );
  }
}
