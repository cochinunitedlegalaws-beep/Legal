import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import '../utils/number_to_words.dart';

class InvoicePdfService {
  static pw.MemoryImage? _logoImage;
  static pw.MemoryImage? _signImage;
  static pw.MemoryImage? _qrImage;
  static pw.MemoryImage? _sealImage;
  
  static pw.Font? _headerFont;
  static pw.Font? _bodyFont;
  static pw.Font? _bodyBold;
  static pw.Font? _titleFont;
  static pw.Font? _subtitleFont;
  static pw.Font? _fallbackFont;

  static Future<Uint8List> generateInvoicePdf({
    required String type,
    required String category,
    required String clientName,
    required String clientAddress,
    required String date,
    required String invoiceNo,
    required String authorities,
    required List<Map<String, dynamic>> items,
    required String totalAmount,
    required String amountInWords,
    String outstandingAmount = '',
    String advanceReceived = '',
    String grandTotal = '',
    String balanceDue = '',
    List<String>? quotationTerms,
    bool isReceipt = false,
  }) async {
    final pdf = pw.Document();

    final bool isLegal = true;

    // Load assets safely and cache them
    if (_signImage == null) {
      try {
        final signData = await rootBundle.load('assets/sign.png');
        _signImage = pw.MemoryImage(signData.buffer.asUint8List());
      } catch (e) {
        debugPrint('Error loading signature: $e');
      }
    }
    
    if (_qrImage == null) {
      try {
        final qrData = await rootBundle.load('assets/legal_qr.jpeg');
        _qrImage = pw.MemoryImage(qrData.buffer.asUint8List());
      } catch (e) {
        debugPrint('Error loading QR: $e');
      }
    }

    if (_sealImage == null) {
      try {
        final sealData = await rootBundle.load('assets/seal.png');
        _sealImage = pw.MemoryImage(sealData.buffer.asUint8List());
      } catch (e) {
        debugPrint('Error loading seal: $e');
      }
    }

    // Fonts caching
    _headerFont ??= await PdfGoogleFonts.interBold();
    _bodyFont ??= await PdfGoogleFonts.interRegular();
    _bodyBold ??= await PdfGoogleFonts.interBold();
    _titleFont ??= await PdfGoogleFonts.cinzelBold();
    _subtitleFont ??= await PdfGoogleFonts.montserratSemiBold();
    _fallbackFont ??= await PdfGoogleFonts.robotoRegular();

    final headerFont = _headerFont!;
    final bodyFont = _bodyFont!;
    final bodyBold = _bodyBold!;
    final titleFont = _titleFont!;
    final subtitleFont = _subtitleFont!;
    final fallbackFont = _fallbackFont!;

    pw.MemoryImage? logoImage = _logoImage;
    pw.MemoryImage? qrImage = _qrImage;
    pw.MemoryImage? sealImage = _sealImage;
    pw.MemoryImage? signImage = _signImage;

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: bodyFont,
          bold: bodyBold,
        ).copyWith(
          defaultTextStyle: pw.TextStyle(fontFallback: [fallbackFont]),
        ),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              if (logoImage != null)
                pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Image(logoImage, width: 480, height: 480),
                  ),
                ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header Row
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logoImage != null) pw.Image(logoImage, width: 90, height: 90) else pw.SizedBox(width: 90, height: 90),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'COCHIN UNITED LEGAL LLP',
                            style: pw.TextStyle(font: titleFont, fontSize: 18, color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'ADVOCATES AND LEGAL CONSULTANTS',
                            style: pw.TextStyle(font: subtitleFont, fontSize: 8, color: PdfColors.black, letterSpacing: 1.5),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '2ND FLOOR, AMRITA TOWER',
                            style: pw.TextStyle(font: bodyFont, fontSize: 8),
                          ),
                          pw.Text(
                            'COMBARA JUNCTION, ERNAKULAM - 682018',
                            style: pw.TextStyle(font: bodyFont, fontSize: 8),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text('email id: cochinunitedlegallp@gmail.com', style: pw.TextStyle(font: bodyFont, fontSize: 8, color: PdfColors.blue700)),
                          pw.Text('mob no: +91 8078090888', style: pw.TextStyle(font: bodyFont, fontSize: 8)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(thickness: 0.5, color: PdfColors.grey400),
                  pw.SizedBox(height: 12),

                  // Client Info
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('TO', style: pw.TextStyle(font: bodyBold, fontSize: 7, color: PdfColors.grey700)),
                          pw.SizedBox(height: 2),
                          pw.Text(clientName.toUpperCase(), style: pw.TextStyle(font: bodyBold, fontSize: 11)),
                          if (clientAddress.isNotEmpty)
                            pw.Container(width: 200, child: pw.Text(clientAddress, style: pw.TextStyle(font: bodyFont, fontSize: 8))),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('DATE: $date', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                          pw.Text('${isReceipt ? 'PAYMENT RECEIPT' : (type == 'QUOTATION' ? 'QUOTATION' : 'INVOICE')} NO: $invoiceNo', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),

                  // Items Table
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(40),
                      1: const pw.FlexColumnWidth(),
                      2: const pw.FixedColumnWidth(80),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                        children: [
                          _cell('Sl. No.', font: bodyBold, align: pw.Alignment.center),
                          _cell('PARTICULARS', font: bodyBold, align: pw.Alignment.center),
                          _cell('AMOUNT', font: bodyBold, align: pw.Alignment.center),
                        ],
                      ),
                      ...() {
                        int slNo = 1;
                        return items.map((e) {
                          final desc = (e['description'] ?? '').toString().toUpperCase();
                          final rawAmt = (e['amount'] ?? '').toString().trim();
                          final isHeading = rawAmt.isEmpty;

                          if (isHeading) {
                            return pw.TableRow(
                              children: [
                                _cell('', align: pw.Alignment.center),
                                _cell(desc, font: bodyBold, align: pw.Alignment.center),
                                _cell('', align: pw.Alignment.center),
                              ],
                            );
                          } else {
                            final formattedAmt = rawAmt.endsWith('/-') ? rawAmt : '$rawAmt/-';
                            final currentSlNo = slNo++;
                            return pw.TableRow(
                              children: [
                                _cell('$currentSlNo.', align: pw.Alignment.center),
                                _cell(desc, font: bodyFont),
                                _cell(formattedAmt, align: pw.Alignment.center),
                              ],
                            );
                          }
                        });
                      }(),
                      pw.TableRow(
                        children: [
                          _cell('', border: false),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                            child: pw.Text('SUBTOTAL', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                            child: pw.Text(totalAmount.endsWith('/-') ? totalAmount : '$totalAmount/-', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                          ),
                        ],
                      ),
                      if (outstandingAmount.isNotEmpty && outstandingAmount != '0' && outstandingAmount != '0/-')
                        pw.TableRow(
                          children: [
                            _cell('', border: false),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text('OUTSTANDING', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(outstandingAmount.endsWith('/-') ? outstandingAmount : '$outstandingAmount/-', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                          ],
                        ),
                      if (grandTotal.isNotEmpty && grandTotal != totalAmount)
                        pw.TableRow(
                          children: [
                            _cell('', border: false),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                              child: pw.Text('GRAND TOTAL', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                              child: pw.Text(grandTotal.endsWith('/-') ? grandTotal : '$grandTotal/-', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                          ],
                        ),
                      if (advanceReceived.isNotEmpty && advanceReceived != '0' && advanceReceived != '0/-')
                        pw.TableRow(
                          children: [
                            _cell('', border: false),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text('ADVANCE RECEIVED', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(advanceReceived.endsWith('/-') ? advanceReceived : '$advanceReceived/-', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                          ],
                        ),
                      if (balanceDue.isNotEmpty && balanceDue != '0' && balanceDue != '0/-')
                        pw.TableRow(
                          children: [
                            _cell('', border: false),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                              child: pw.Text('BALANCE DUE', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                              child: pw.Text(balanceDue.endsWith('/-') ? balanceDue : '$balanceDue/-', style: pw.TextStyle(font: bodyBold, fontSize: 9)),
                            ),
                          ],
                        ),
                    ],
                  ),

                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(vertical: 6),
                    child: pw.Text('(${amountInWords.toUpperCase()})', style: pw.TextStyle(font: bodyBold, fontSize: 7), textAlign: pw.TextAlign.center),
                  ),

                  if (quotationTerms != null && quotationTerms.isNotEmpty)
                    _quotationNotes(bodyFont, bodyBold, quotationTerms, type)
                  else if (type == 'QUOTATION')
                    _quotationNotes(bodyFont, bodyBold, null, type)
                  else
                    pw.Center(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 10),
                        child: pw.Text(
                          'For any clarifications or queries regarding the bill, or to report an error or omission, please contact us at cochinunitedlegallp@gmail.com',
                          style: pw.TextStyle(font: bodyFont, fontSize: 7, fontStyle: pw.FontStyle.italic),
                        ),
                      ),
                    ),

                  pw.SizedBox(height: 10),
                  pw.Center(child: pw.Text('We Value Your Relationship With Us!', style: pw.TextStyle(font: bodyBold, fontSize: 9))),
                  pw.SizedBox(height: 20),

                  // Bottom Section
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Bank Details
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Bank Details:', style: pw.TextStyle(font: bodyBold, fontSize: 8)),
                          pw.SizedBox(height: 4),
                          _bankRow('A/c no', ': 0522202100000749', bodyFont),
                          _bankRow('IFSC Code', ': PUNB0052220', bodyFont),
                          pw.Text('PUNJAB NATIONAL BANK', style: pw.TextStyle(font: bodyFont, fontSize: 7)),
                          pw.Text('Branch- Ernakulam (Market Road)', style: pw.TextStyle(font: bodyFont, fontSize: 7)),
                          pw.SizedBox(height: 8),
                          if (qrImage != null) pw.Image(qrImage, width: 60, height: 60) else pw.SizedBox(width: 60, height: 60),
                        ],
                      ),
                      // Seal Image
                      if (sealImage != null)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Image(sealImage, width: 160, height: 160),
                          ],
                        )
                      else
                        pw.Spacer(),
                      // Signature
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text('For COCHIN UNITED LEGAL LLP', style: pw.TextStyle(font: bodyFont, fontSize: 8, color: PdfColors.blue700)),
                          pw.SizedBox(height: 2),
                          if (signImage != null)
                            pw.Container(
                              width: 100,
                              child: pw.Image(signImage, fit: pw.BoxFit.contain),
                            )
                          else
                            pw.SizedBox(height: 40),
                          pw.SizedBox(height: 2),
                          pw.Text('Authorised Signatory', style: pw.TextStyle(font: bodyFont, fontSize: 7)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _cell(String text, {pw.Font? font, pw.Alignment align = pw.Alignment.centerLeft, bool border = true}) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9)),
    );
  }

  static pw.Widget _bankRow(String label, String value, pw.Font f) => pw.Row(
    children: [
      pw.SizedBox(width: 50, child: pw.Text(label, style: pw.TextStyle(font: f, fontSize: 7))),
      pw.Text(value, style: pw.TextStyle(font: f, fontSize: 7)),
    ],
  );

  static pw.Widget _quotationNotes(pw.Font f, pw.Font fb, List<String>? customTerms, String type) {
    final defaultNotes = [
      'This quotation is not comprehensive. Inspection charges, additional consultation, statutory fees, and any additional work required as per instructions from authorities are excluded from this quotation and will be charged separately, if required.',
      'Any increase in government fees or additional expenses during the application process must be borne by you.',
      'We are not liable for delays caused by changes in government regulations, system failures, network issues, or unforeseen circumstances beyond our control.',
      'If additional documents or steps are required, your cooperation and support will be necessary, and any extra expenses incurred must be reimbursed by you.',
      'Please regularly follow up on the application process and promptly share any required OTPs.',
      'In case of any unethical practices or misbehavior by our staff, please contact our Client Relationship Manager immediately.',
    ];

    final notes = customTerms ?? defaultNotes;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('NB:', style: pw.TextStyle(font: fb, fontSize: 8)),
        pw.SizedBox(height: 4),
        ...notes.map((note) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2, left: 10),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('• ', style: pw.TextStyle(font: f, fontSize: 7)),
              pw.Expanded(child: pw.Text(note, style: pw.TextStyle(font: f, fontSize: 7))),
            ],
          ),
        )),
        if (type == 'QUOTATION') ...[
          pw.SizedBox(height: 12),
          pw.Text(
            'To accept this quotation, Please sign here and return: ..................................................................................',
            style: pw.TextStyle(font: f, fontSize: 7),
          ),
        ],
      ],
    );
  }

  static Future<void> printInvoice({
    required String type,
    required String category,
    required String clientName,
    required String clientAddress,
    required String date,
    required String invoiceNo,
    required String authorities,
    required List<Map<String, dynamic>> items,
    required String totalAmount,
    required String amountInWords,
    String outstandingAmount = '',
    String advanceReceived = '',
    String grandTotal = '',
    String balanceDue = '',
    List<String>? quotationTerms,
    bool isReceipt = false,
  }) async {
    try {
      final pdfBytes = await generateInvoicePdf(
        type: type,
        category: category,
        clientName: clientName,
        clientAddress: clientAddress,
        date: date,
        invoiceNo: invoiceNo,
        authorities: authorities,
        items: items,
        totalAmount: totalAmount,
        amountInWords: amountInWords,
        outstandingAmount: outstandingAmount,
        advanceReceived: advanceReceived,
        grandTotal: grandTotal,
        balanceDue: balanceDue,
        quotationTerms: quotationTerms,
        isReceipt: isReceipt,
      );
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
    } catch (e) {
      print('Error printing invoice: $e');
    }
  }
}

