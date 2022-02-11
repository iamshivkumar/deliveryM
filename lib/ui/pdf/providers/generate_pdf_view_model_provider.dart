import 'dart:io';

import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

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
    final theme = pw.ThemeData.base();
    final pdf = pw.Document();
    final list = subscription.deliveries
        .where((e) => e.status == DeliveryStatus.delivered)
        .toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                customer.name,
                style: theme.header5.copyWith(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                customer.address.formated,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "+91${customer.mobile}",
              ),
              pw.SizedBox(height: 16),
              pw.Row(children: [
                pw.Text(
                  "Product Name:",
                ),
                pw.Spacer(),
                pw.Text(
                  subscription.productName,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Spacer(flex: 2),
                pw.Text(
                  "Product Price:",
                ),
                pw.Spacer(),
                pw.Text(
                  "Rs ${subscription.price}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ]),
              pw.SizedBox(height: 16),
              pw.Table(
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.blueGrey),
                            color: PdfColors.blueGrey50,
                          ),
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text('Date'),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text("Quantity"),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text("Total"),
                            ),
                          ],
                        ),
                      ] +
                      list
                          .where((element) => list.indexOf(element) < 18)
                          .map(
                            (e) => pw.TableRow(
                              decoration: pw.BoxDecoration(
                                border:
                                    pw.Border.all(color: PdfColors.blueGrey),
                              ),
                              children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(8),
                                  child:
                                      pw.Text(Formats.monthDayFromDate(e.date)),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(8),
                                  child: pw.Text("${e.quantity}"),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                      "${e.quantity * subscription.price}"),
                                ),
                              ],
                            ),
                          )
                          .toList() +
                      (list.length <= 18
                          ? [
                              pw.TableRow(
                                decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.blueGrey),
                                  color: PdfColors.blueGrey50,
                                ),
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(8),
                                    child: pw.Text('Grand Total'),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(8),
                                    child: pw.Text(
                                      list
                                          .map((e) => e.quantity)
                                          .reduce((value, element) =>
                                              value + element)
                                          .toString(),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(8),
                                    child: pw.Text(list
                                        .map((e) =>
                                            e.quantity * subscription.price)
                                        .reduce(
                                            (value, element) => value + element)
                                        .toString()),
                                  ),
                                ],
                              ),
                            ]
                          : [])),
            ],
          ); // Center
        },
      ),
    );

    if (list.length > 18) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.blueGrey),
                        color: PdfColors.blueGrey50,
                      ),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Date'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text("Quantity"),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text("Total"),
                        ),
                      ],
                    ),
                  ] +
                  list
                      .where((element) => list.indexOf(element) >= 18)
                      .map(
                        (e) => pw.TableRow(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.blueGrey),
                          ),
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(Formats.monthDayFromDate(e.date)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("${e.quantity}"),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child:
                                  pw.Text("${e.quantity * subscription.price}"),
                            ),
                          ],
                        ),
                      )
                      .toList() +
                  [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.blueGrey),
                        color: PdfColors.blueGrey50,
                      ),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Grand Total'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            list
                                .map((e) => e.quantity)
                                .reduce((value, element) => value + element)
                                .toString(),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(list
                              .map((e) => e.quantity * subscription.price)
                              .reduce((value, element) => value + element)
                              .toString()),
                        ),
                      ],
                    ),
                  ],
            );
          },
        ),
      ); // Page
    }

    final file = await File('${tempDir.path}/generated.pdf')
        .writeAsBytes(await pdf.save());
    return file;
  }
}
