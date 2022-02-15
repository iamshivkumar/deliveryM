import 'dart:io';

import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/customer.dart';
import 'package:delivery_m/core/models/profile.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/core/models/wallet_transaction.dart';
import 'package:delivery_m/ui/profile/providers/profile_provider.dart';
import 'package:delivery_m/utils/formats.dart';
import 'package:flutter/foundation.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

final generatePdfViewModelProvider =
    Provider((ref) => GeneratePdfViewModel(ref));

class GeneratePdfViewModel {
  final Ref _ref;

  GeneratePdfViewModel(this._ref);

  Profile get _profile => _ref.read(profileProvider).value!;

  void generate({
    required Function(File) onDone,
    required Subscription subscription,
    required Customer customer,
  }) async {
    try {
      final file = await GeneratePdf.generateBill(
          subscription: subscription,
          customer: customer,
          name: _profile.businessName!);
      onDone(file);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}

class GeneratePdf {
  static Future<File> generateBill(
      {required Subscription subscription,
      required Customer customer,
      required String name}) async {
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
              pw.Center(
                child: pw.Text(
                  name,
                  style: theme.header4.copyWith(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
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
                  subscription.product.name,
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
                  "Rs ${subscription.product.price}",
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
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text('Date'),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Quantity"),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Total"),
                            ),
                          ],
                        ),
                      ] +
                      list
                          .where((element) => list.indexOf(element) < 17)
                          .map(
                            (e) => pw.TableRow(
                              decoration: pw.BoxDecoration(
                                border:
                                    pw.Border.all(color: PdfColors.blueGrey),
                              ),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    Formats.monthDayFromDate(e.date),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text("${e.quantity}"),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                      "${e.quantity * subscription.product.price}"),
                                ),
                              ],
                            ),
                          )
                          .toList() +
                      (list.length <= 17
                          ? [
                              pw.TableRow(
                                decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.blueGrey),
                                  color: PdfColors.blueGrey50,
                                ),
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text('Grand Total'),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text(
                                      list
                                          .map((e) => e.quantity)
                                          .reduce((value, element) =>
                                              value + element)
                                          .toString(),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text(list
                                        .map((e) =>
                                            e.quantity * subscription.product.price)
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

    if (list.length > 17) {
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
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Date'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text("Quantity"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text("Total"),
                        ),
                      ],
                    ),
                  ] +
                  list
                      .where((element) => list.indexOf(element) >= 17)
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
                                  pw.Text("${e.quantity * subscription.product.price}"),
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
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Grand Total'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            list
                                .map((e) => e.quantity)
                                .reduce((value, element) => value + element)
                                .toString(),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(list
                              .map((e) => e.quantity * subscription.product.price)
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

  static Future<File> generateTransactionsHistory(
      {required List<WalletTransaction> transactions,
      required Customer customer,
      required String name}) async {
    final Directory tempDir = await getTemporaryDirectory();
    final theme = pw.ThemeData.base();
    final pdf = pw.Document();

    pw.Widget cell10(String value, {PdfColor? color}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            color: color,
          ),
        ),
      );
    }

    pw.TableRow header() => pw.TableRow(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.blueGrey,
              width: 0.2,
            ),
            color: PdfColors.blueGrey50,
          ),
          children: [
            cell10('Created At'),
            cell10("Amount (Rupees)"),
            cell10("Balance (Rupees)"),
            cell10("Product"),
            cell10("Date"),
            cell10("Quantity")
          ],
        );

    List<pw.TableRow> rows(Iterable<WalletTransaction> values) {
      return values
          .map(
            (e) => pw.TableRow(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.blueGrey,
                  width: 0.5,
                ),
              ),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    Formats.monthDayTime(e.createdAt),
                    style: const pw.TextStyle(
                      fontSize: 6,
                    ),
                  ),
                ),
                cell10("${e.amount}",
                    color:
                        e.amount.isNegative ? PdfColors.red : PdfColors.green),
                cell10("${e.balance}"),
                e.name != null ? cell10(e.name!) : pw.SizedBox(),
                e.date != null
                    ? cell10(Formats.monthDayFromDate(e.date!))
                    : pw.SizedBox(),
                e.quantity != null
                    ? cell10("${e.quantity}",
                        color: e.quantity!.isNegative
                            ? PdfColors.red
                            : PdfColors.green)
                    : pw.SizedBox(),
              ],
            ),
          )
          .toList();
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  name,
                  style: theme.header4.copyWith(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
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
              pw.Table(
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: [
                        header(),
                      ] +
                      rows(transactions.where(
                          (element) => transactions.indexOf(element) < 28))),
            ],
          ); // Center
        },
      ),
    );

    if (transactions.length > 28) {
      for (var i = 0;
          i < ((transactions.length - 28) / 34 + 0.5).toInt();
          i++) {
            
        final list = transactions
            .where((element) => transactions.indexOf(element) > 28)
            .where(
              (element) =>
                  transactions.indexOf(element) > (i - 1) * 32 &&
                  transactions.indexOf(element) < i * 32,
            );

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: rows(list),
              );
            },
          ),
        );
      }
    }

    final file = await File('${tempDir.path}/generated2.pdf')
        .writeAsBytes(await pdf.save());
    return file;
  }
}
