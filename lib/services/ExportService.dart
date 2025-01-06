import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class ExportService {
  Future<void> exportToPDF({
    required double income,
    required double expense,
    required double netBalance,
    required List<Map<String, dynamic>> chartData,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final pdf = pw.Document();

    // Add content to PDF
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text('Financial Report')),
          if (startDate != null && endDate != null)
            pw.Paragraph(
                text: 'From ${startDate.toLocal()} to ${endDate.toLocal()}'),
          pw.SizedBox(height: 20),
          pw.Text('Income: Rp.${income.toStringAsFixed(2)},-'),
          pw.Text('Expense: Rp.${expense.toStringAsFixed(2)},-'),
          pw.Text('Net Balance: Rp.${netBalance.toStringAsFixed(2)},-',
              style: pw.TextStyle(
                  color: netBalance >= 0 ? PdfColors.green : PdfColors.red)),
          pw.SizedBox(height: 20),
          pw.Text('Chart Data:'),
          pw.Table.fromTextArray(
            headers: ['Category', 'Amount'],
            data: chartData.map((data) {
              return [
                data['category']?.toString() ?? 'Unknown',
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
      final file = File("${output.path}/report.pdf");
      await file.writeAsBytes(await pdf.save());

      // Optionally, you can open the PDF using the printing package
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      throw Exception('Error generating PDF: $e');
    }
  }

  Future<void> exportToExcel({
    required double income,
    required double expense,
    required double netBalance,
    required List<Map<String, dynamic>> chartData,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Report'];

    // Add headers
    sheetObject.appendRow(['Financial Report']);
    if (startDate != null && endDate != null) {
      sheetObject.appendRow([
        'From',
        startDate.toLocal().toString(),
        'To',
        endDate.toLocal().toString()
      ]);
    }
    sheetObject.appendRow([]);
    sheetObject.appendRow(['Income', 'Expense', 'Net Balance']);
    sheetObject.appendRow([
      income.toStringAsFixed(2),
      expense.toStringAsFixed(2),
      netBalance.toStringAsFixed(2),
    ]);
    sheetObject.appendRow([]);

    // Add chart data
    sheetObject.appendRow(['Chart Data']);
    sheetObject.appendRow(['Category', 'Amount']);
    for (var data in chartData) {
      sheetObject
          .appendRow([data['category'].toString(), data['amount'].toString()]);
    }

    try {
      // Save Excel file
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/report.xlsx");
      await file.writeAsBytes(excel.encode()!);

      // Optionally, share or open the Excel file
      // You might need additional packages like 'share_plus' for sharing
    } catch (e) {
      throw Exception('Error generating Excel: $e');
    }
  }
}
