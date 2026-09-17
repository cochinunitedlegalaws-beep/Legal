import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../services/excel_import_service.dart';

class ExcelImportDialog extends StatefulWidget {
  const ExcelImportDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => const ExcelImportDialog(),
    );
  }

  @override
  State<ExcelImportDialog> createState() => _ExcelImportDialogState();
}

class _ExcelImportDialogState extends State<ExcelImportDialog> {
  final _importService = ExcelImportService();
  bool _isImporting = false;
  int _current = 0;
  int _total = 0;
  String _statusMessage = '';
  ExcelImportResult? _result;

  Future<void> _startImport({String? customPath}) async {
    setState(() {
      _isImporting = true;
      _statusMessage = 'Reading file records...';
      _current = 0;
      _total = 0;
      _result = null;
    });

    try {
      final records = await _importService.loadRecords(filePath: customPath);
      if (records.isEmpty) {
        setState(() {
          _isImporting = false;
          _statusMessage = 'No valid records found to import.';
        });
        return;
      }

      final result = await _importService.importRecords(
        records: records,
        onProgress: (current, total, status) {
          if (mounted) {
            setState(() {
              _current = current;
              _total = total;
              _statusMessage = status;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isImporting = false;
          _result = result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isImporting = false;
          _statusMessage = 'Import error: $e';
        });
      }
    }
  }

  Future<void> _pickFileAndImport() async {
    try {
      final res = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (res != null && res.files.single.path != null) {
        await _startImport(customPath: res.files.single.path!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.table_view_rounded, color: Color(0xFFC5A059), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Excel Data Importer',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Import Client Data and Workfiles seamlessly',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isImporting)
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                      onPressed: () => Navigator.of(context).pop(_result != null),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 20),

              // Content based on state
              if (_isImporting) ...[
                _buildImportingState(),
              ] else if (_result != null) ...[
                _buildResultState(),
              ] else ...[
                _buildSelectionState(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_statusMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            ),
            child: Text(
              _statusMessage,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        Text(
          'Select an option to add records to Client Details and Workfiles:',
          style: GoogleFonts.montserrat(fontSize: 14, color: const Color(0xFF334155)),
        ),
        const SizedBox(height: 16),

        // Primary Action: Downloaded Cochin United File
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _startImport(),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFC5A059), width: 1.5),
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFC5A059).withValues(alpha: 0.04),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5A059),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.file_download_done_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cochin United File (Downloads)',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Import 124 records from Cochin United FIle.xlsx (UN, AN, BN, CN, DN series)',
                          style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFC5A059)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Secondary Action: Pick custom file
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _pickFileAndImport,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFF8FAFC),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.folder_open_rounded, color: Color(0xFF475569), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Another Excel File...',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Browse storage for another .xlsx spreadsheet',
                          style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportingState() {
    final progress = _total > 0 ? (_current / _total) : 0.0;
    final percent = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Importing Records...',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF0F172A)),
            ),
            Text(
              '$_current of $_total ($percent%)',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xFFC5A059),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress > 0 ? progress : null,
            minHeight: 10,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC5A059)),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            _statusMessage,
            style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF64748B)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultState() {
    final r = _result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Import Complete!',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Processed ${r.totalRecords} records from Excel spreadsheet.',
                      style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Stats summary cards
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Clients',
                added: r.clientsAdded,
                skipped: r.clientsSkipped,
                icon: Icons.people_alt_rounded,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Workfiles',
                added: r.workfilesAdded,
                skipped: r.workfilesSkipped,
                icon: Icons.folder_special_rounded,
                color: const Color(0xFFC5A059),
              ),
            ),
          ],
        ),

        if (r.errors.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Warnings / Notes (${r.errors.length}):',
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(maxHeight: 100),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            ),
            child: SingleChildScrollView(
              child: Text(
                r.errors.join('\n'),
                style: const TextStyle(fontSize: 11, color: Colors.red),
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Done & View Updated Records',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required int added,
    required int skipped,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF475569)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '+$added',
                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
              ),
              const SizedBox(width: 6),
              Text(
                'added',
                style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF64748B)),
              ),
            ],
          ),
          if (skipped > 0) ...[
            const SizedBox(height: 4),
            Text(
              '$skipped existing (skipped)',
              style: GoogleFonts.montserrat(fontSize: 11, color: const Color(0xFF94A3B8)),
            ),
          ],
        ],
      ),
    );
  }
}
