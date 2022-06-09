import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';

class PDFView extends StatefulWidget {
  static const routeName = 'pdfViewer';
  const PDFView({Key? key}) : super(key: key);

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    final _arguments = (ModalRoute.of(context)?.settings.arguments as Map);
    final _pdfUrl = _arguments['pdfData']['url'];

    return Scaffold(
      appBar: BaseAppBar.getAppBar(title: "PDF View", context: context),
      body: _pdfUrl != null
          ? SfPdfViewer.network(
              _pdfUrl!,
            )
          : Center(
              child: Text(
                "Something went wrong",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
    );
  }
}
