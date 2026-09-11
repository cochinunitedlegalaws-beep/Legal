import 'package:flutter/material.dart';
import '../models/chamber_document.dart';
import '../theme/app_theme.dart';

/// A dialog that allows users to select documents and link them to a case.
class DocumentSelectionDialog extends StatefulWidget {
  final List<ChamberDocument> availableDocuments;
  final List<String> selectedDocumentIds;
  final Function(List<String>) onConfirm;

  const DocumentSelectionDialog({
    Key? key,
    required this.availableDocuments,
    required this.selectedDocumentIds,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<DocumentSelectionDialog> createState() => _DocumentSelectionDialogState();
}

class _DocumentSelectionDialogState extends State<DocumentSelectionDialog> {
  late List<String> _selectedIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedDocumentIds);
  }

  List<ChamberDocument> get _filteredDocuments {
    if (_searchQuery.isEmpty) {
      return widget.availableDocuments;
    }
    return widget.availableDocuments
        .where((doc) => doc.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleDocument(String documentId, bool isSelected) {
    setState(() {
      if (isSelected && !_selectedIds.contains(documentId)) {
        _selectedIds.add(documentId);
      } else if (!isSelected) {
        _selectedIds.remove(documentId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Link Documents to Case',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search field
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search documents...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),

            // Document list
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredDocuments.length,
                itemBuilder: (context, index) {
                  final doc = _filteredDocuments[index];
                  final isSelected = _selectedIds.contains(doc.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) => _toggleDocument(doc.id, value ?? false),
                    title: Text(
                      doc.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Created by ${doc.createdBy}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    activeColor: AppTheme.accentColor,
                    checkColor: AppTheme.primaryColor,
                    tileColor: isSelected ? AppTheme.surfaceColor : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                },
              ),
            ),

            // Selection info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                '${_selectedIds.length} document(s) selected',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: AppTheme.textPrimary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onConfirm(_selectedIds);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Link Documents'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
