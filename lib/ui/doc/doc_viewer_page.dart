import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocViewerPage extends StatelessWidget {
  const DocViewerPage({Key? key, required this.file, required this.mobile})
      : super(key: key);

  final String mobile;
  final File file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: mobile)).then((_) {
             Fluttertoast.showToast(msg: 'Customer mobile number copied.');
          });
          Share.shareFiles([file.path]);
        },
        child: const Icon(Icons.share),
      ),
      body: SfPdfViewer.file(file),
    );
  }
}
