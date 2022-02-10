
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocViewerPage extends StatelessWidget {
  const DocViewerPage({ Key? key, required this.file }) : super(key: key);
  
  final File file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SfPdfViewer.file(file),
    );
  }
}