import 'dart:io';

import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

final generatePdfViewModelProvider =
    Provider((ref) => GeneratePdfViewModel(ref));

class GeneratePdfViewModel {
  final Ref ref;

  GeneratePdfViewModel(this.ref);

  void generate({
    required Function(File) onDone,
    required Subscription subscription,
    required Customer customer,
  }) async {
    try {
      final file = await Generate.generateBill(
        subscription: subscription,
        customer: customer,
      );
      onDone(file);
    } catch (e) {
      print('$e');
    }
  }
}

class Generate {
  static Future<File> generateBill(
      {required Subscription subscription, required Customer customer}) async {
    final Directory tempDir = await getTemporaryDirectory();

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    page.graphics.drawString(
      customer.name,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(0, 0, 150, 20),
    );
    page.graphics.drawString(
      customer.address.formated,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(0, 24, 150, 20),
    );
    page.graphics.drawString(
      "+91${customer.mobile}",
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(0, 48, 150, 20),
    );
    page.graphics.drawString(
      "Product Name:",
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfBrushes.gray,
      bounds: const Rect.fromLTWH(0, 96, 150, 20),
    );
    page.graphics.drawString(
      subscription.productName,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfBrushes.black,
      bounds: const Rect.fromLTWH(100, 96, 150, 20),
    );
    page.graphics.drawString(
      "Product Price:",
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfBrushes.gray,
      bounds: const Rect.fromLTWH(300, 96, 150, 20),
    );
    page.graphics.drawString(
      "Rs ${subscription.price}",
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfBrushes.black,
      bounds: const Rect.fromLTWH(400, 96, 150, 20),
    );
    
    

    final file = await File('${tempDir.path}/generated.pdf')
        .writeAsBytes(document.save());
    document.dispose();
    return file;
  }
}
