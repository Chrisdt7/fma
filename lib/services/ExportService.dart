import 'dart:io';
import 'package:fma/templates/AppLocalization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class ExportService {
  Future<void> exportToPDF({
    context,
    required double income,
    required double expense,
    required double netBalance,
    required List<Map<String, dynamic>> chartData,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final pdf = pw.Document();
    final localizations = AppLocalizations.of(context);

    // Add content to PDF
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
              level: 0,
              child: pw.Text(localizations.translate("Reports-Export-title"))),
          if (startDate != null && endDate != null)
            pw.Paragraph(
                text:
                    '${localizations.translate("text-utility-1")} ${startDate.toLocal()} ${localizations.translate("text-utility-2")} ${endDate.toLocal()}'),
          pw.SizedBox(height: 20),
          pw.Text(
              '${localizations.translate("Currency-income")} ${localizations.translate("Currency-start")}${income.toStringAsFixed(2)}${localizations.translate("Currency-end")}'),
          pw.Text(
              '${localizations.translate("Currency-expense")} ${localizations.translate("Currency-start")}${expense.toStringAsFixed(2)}${localizations.translate("Currency-end")}'),
          pw.Text(
              '${localizations.translate("Currency-balance")} ${localizations.translate("Currency-start")}${netBalance.toStringAsFixed(2)}${localizations.translate("Currency-end")}',
              style: pw.TextStyle(
                  color: netBalance >= 0 ? PdfColors.green : PdfColors.red)),
          pw.SizedBox(height: 20),
          pw.Text(localizations.translate("Chart-data")),
          pw.Table.fromTextArray(
            headers: [
              localizations.translate("Transactions-label-category"),
              localizations.translate("Transactions-label-amount")
            ],
            data: chartData.map((data) {
              return [
                data['category']?.toString() ??
                    localizations.translate("text-3"),
                data['amount']?.toString() ?? '0'
              ];
            }).toList(),
          ),
        ],
      ),
    );

    try {
      // Save PDF to file
      final output = await getTemporaryDirectory();
      final file = File(
          "${output.path}/${localizations.translate("Reports-Export-filename")}");
      await file.writeAsBytes(await pdf.save());

      // Optionally, you can open the PDF using the printing package
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      throw Exception('Error generating PDF: $e');
    }
  }

  Future<void> exportToExcel({
    context,
    required double income,
    required double expense,
    required double netBalance,
    required List<Map<String, dynamic>> chartData,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final localizations = AppLocalizations.of(context);
    var excel = Excel.createExcel();
    Sheet sheetObject = excel[localizations.translate("reports-title")];

    // Add headers
    sheetObject.appendRow([localizations.translate("Reports-Export-title")]);
    if (startDate != null && endDate != null) {
      sheetObject.appendRow([
        localizations.translate("text-utility-1"),
        startDate.toLocal().toString(),
        localizations.translate("text-utility-2"),
        endDate.toLocal().toString()
      ]);
    }
    sheetObject.appendRow([]);
    sheetObject.appendRow([
      localizations.translate("Transactions-label-type-a"),
      localizations.translate("Transactions-label-type-b"),
      localizations.translate("Transactions-label-type-c")
    ]);
    sheetObject.appendRow([
      income.toStringAsFixed(2),
      expense.toStringAsFixed(2),
      netBalance.toStringAsFixed(2),
    ]);
    sheetObject.appendRow([]);

    // Add chart data
    sheetObject.appendRow([localizations.translate("Chart-data")]);
    sheetObject.appendRow([
      localizations.translate("Transactions-label-category"),
      localizations.translate("Transactions-label-amount")
    ]);
    for (var data in chartData) {
      sheetObject
          .appendRow([data['category'].toString(), data['amount'].toString()]);
    }

    try {
      // Save Excel file
      final output = await getTemporaryDirectory();
      final file = File(
          "${output.path}/${localizations.translate("Reports-Export-filename")}");
      await file.writeAsBytes(excel.encode()!);

      // Optionally, share or open the Excel file
      // You might need additional packages like 'share_plus' for sharing
    } catch (e) {
      throw Exception('Error generating Excel: $e');
    }
  }
}
