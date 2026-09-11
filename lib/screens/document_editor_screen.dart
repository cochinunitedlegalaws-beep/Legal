import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';

import '../theme/app_theme.dart';
import '../models/chamber_document.dart';
import '../models/document_audit_log.dart';
import '../services/document_service.dart';
import '../utils/document_crypto.dart';
import 'package:docx_creator/docx_creator.dart' as docx;
import '../utils/docx_parser.dart';
import '../widgets/responsive.dart';

/// Intent for Ctrl+S save shortcut.
class _SaveIntent extends Intent {
  const _SaveIntent();
}

/// Rich text document editor with Microsoft Word-style ribbon toolbar,
/// ruler, page canvas, and status bar — preserving AES-256 encryption,
/// audit logging, and the Cochin United brand aesthetic.
class DocumentEditorScreen extends StatefulWidget {
  final String userEmail;
  final ChamberDocument? existingDocument; // null = create mode

  const DocumentEditorScreen({
    super.key,
    required this.userEmail,
    this.existingDocument,
  });

  @override
  State<DocumentEditorScreen> createState() => _DocumentEditorScreenState();
}

class _DocumentEditorScreenState extends State<DocumentEditorScreen> {
  // ── Core Editor State ──────────────────────────────────────────────
  late QuillController _quillController;
  late TextEditingController _titleController;
  late TextEditingController _headerController;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  bool _isNewDocument = true;
  String _documentId = '';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _editorContentKey = GlobalKey();
  late FocusNode _editorFocusNode;

  // ── Page State ─────────────────────────────────────────────────────
  bool _isPageView = true;
  bool _showNavigationPane = true;
  int _currentPageNum = 1;
  int _totalPages = 1;
  int _requestedPageCount = 1;
  docx.DocxPageSize _pageSize = docx.DocxPageSize.a4;

  // ── New Word-Style UI State ────────────────────────────────────────
  int _activeRibbonTab = 0; // 0=Home, 1=Insert, 2=Layout
  int _wordCount = 0;
  bool _isLandscape = false;
  String _marginPreset = 'Normal'; // Normal, Narrow, Wide
  double _lineSpacing = 1.5;

  // Font options
  static const List<String> _fontFamilies = [
    'Montserrat', 'Cinzel', 'Arial', 'Times New Roman',
    'Courier New', 'Georgia', 'Verdana', 'Calibri',
  ];
  static const List<String> _fontSizes = [
    '8', '9', '10', '11', '12', '14', '16', '18',
    '20', '22', '24', '26', '28', '36', '48', '72',
  ];

  // ══════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ══════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    _isNewDocument = widget.existingDocument == null;
    _titleController = TextEditingController(
      text: widget.existingDocument?.title ?? 'Untitled Document',
    );

    if (widget.existingDocument != null) {
      _documentId = widget.existingDocument!.id;
      _loadExistingDocument();
    } else {
      _documentId = ChamberDocument.generateId();
      _quillController = QuillController.basic();
    }

    _editorFocusNode = FocusNode();

    _titleController.addListener(() {
      if (!_hasUnsavedChanges) {
        setState(() => _hasUnsavedChanges = true);
      }
    });

    _headerController = TextEditingController();
    _headerController.addListener(() {
      if (!_hasUnsavedChanges) {
        setState(() => _hasUnsavedChanges = true);
      }
    });

    _scrollController.addListener(_updatePageCount);

    _quillController.addListener(_onEditorChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageCount();
      _updateWordCount();
    });
  }

  void _onEditorChanged() {
    _hasUnsavedChanges = true;
    _updatePageCount();
    _updateWordCount();
    if (mounted) setState(() {});
  }

  void _loadExistingDocument() {
    try {
      final decryptedJson = DocumentCrypto.decryptContent(
        widget.existingDocument!.encryptedContent,
      );
      if (decryptedJson.isNotEmpty) {
        final List<dynamic> delta = jsonDecode(decryptedJson);
        _quillController = QuillController(
          document: Document.fromJson(delta),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        _quillController = QuillController.basic();
      }
    } catch (_) {
      _quillController = QuillController.basic();
    }

    DocumentService.logAuditEvent(DocumentAuditLog(
      documentId: _documentId,
      documentTitle: widget.existingDocument!.title,
      action: DocumentAction.viewed, details: '',
      performedBy: widget.userEmail,
      performedAt: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updatePageCount);
    _scrollController.dispose();
    _editorFocusNode.dispose();
    _quillController.removeListener(_onEditorChanged);
    _quillController.dispose();
    _titleController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════
  // HELPERS — Margin, Word Count, Formatting
  // ══════════════════════════════════════════════════════════════════

  double _getMarginMm() {
    switch (_marginPreset) {
      case 'Narrow':
        return 12.7;
      case 'Wide':
        return 38.1;
      default:
        return 25.4;
    }
  }

  void _updateWordCount() {
    final text = _quillController.document.toPlainText().trim();
    _wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }

  bool _isFormatActive(String key) {
    return _quillController.getSelectionStyle().attributes.containsKey(key);
  }

  dynamic _getFormatValue(String key) {
    return _quillController.getSelectionStyle().attributes[key]?.value;
  }

  void _toggleFormat(Attribute attr) {
    if (_isFormatActive(attr.key)) {
      _quillController.formatSelection(Attribute.clone(attr, null));
    } else {
      _quillController.formatSelection(attr);
    }
  }

  void _setBlockFormat(Attribute attr) {
    final current = _getFormatValue(attr.key);
    if (current == attr.value) {
      _quillController.formatSelection(Attribute.clone(attr, null));
    } else {
      _quillController.formatSelection(attr);
    }
  }

  void _setFont(String font) {
    _quillController.formatSelection(
      Attribute('font', AttributeScope.inline, font),
    );
  }

  void _setFontSize(String size) {
    _quillController.formatSelection(
      Attribute('size', AttributeScope.inline, size),
    );
  }

  void _indent() {
    final level = (_getFormatValue('indent') as int?) ?? 0;
    if (level < 5) {
      _quillController.formatSelection(
        Attribute('indent', AttributeScope.block, level + 1),
      );
    }
  }

  void _outdent() {
    final level = (_getFormatValue('indent') as int?) ?? 0;
    if (level > 0) {
      final newLevel = level - 1;
      _quillController.formatSelection(
        Attribute('indent', AttributeScope.block, newLevel == 0 ? null : newLevel),
      );
    }
  }

  String get _currentFont {
    return _getFormatValue('font')?.toString() ?? 'Montserrat';
  }

  String get _currentSize {
    final v = _getFormatValue('size');
    return v?.toString() ?? '15';
  }

  // ══════════════════════════════════════════════════════════════════
  // PAGE CALCULATIONS
  // ══════════════════════════════════════════════════════════════════

  double _pageWidthMm() {
    double pw, ph;
    switch (_pageSize) {
      case docx.DocxPageSize.letter:
        pw = 216.0; ph = 279.4;
        break;
      case docx.DocxPageSize.legal:
        pw = 216.0; ph = 355.6;
        break;
      case docx.DocxPageSize.a4:
      default:
        pw = 210.0; ph = 297.0;
    }
    return _isLandscape ? ph : pw;
  }

  double _pageHeightMm() {
    double pw, ph;
    switch (_pageSize) {
      case docx.DocxPageSize.letter:
        pw = 216.0; ph = 279.4;
        break;
      case docx.DocxPageSize.legal:
        pw = 216.0; ph = 355.6;
        break;
      case docx.DocxPageSize.a4:
      default:
        pw = 210.0; ph = 297.0;
    }
    return _isLandscape ? pw : ph;
  }

  double _pageAspectRatio() {
    return _pageHeightMm() / _pageWidthMm();
  }

  double _calculatePageWidth(BuildContext context) {
    // Exact mapping to physical paper size at 96 DPI (standard web resolution).
    // 1 inch = 96 pixels -> 25.4 mm = 96 pixels -> 1 mm = 3.7795 pixels.
    return _pageWidthMm() * (96.0 / 25.4);
  }

  double _calculatePageHeight(BuildContext context) {
    return _calculatePageWidth(context) * _pageAspectRatio();
  }

  void _updatePageCount() {
    if (!_isPageView || !_scrollController.hasClients) return;

    final double pageWidth = _calculatePageWidth(context);
    final double pageHeight = pageWidth * _pageAspectRatio();

    final offset = _scrollController.offset;
    final double actualContentHeight =
        _editorContentKey.currentContext?.size?.height ?? 0;
    final double editorHeight = actualContentHeight > 56 ? actualContentHeight - 56 : actualContentHeight;
    final double totalHeight = editorHeight > 0
        ? editorHeight
        : _scrollController.position.maxScrollExtent +
            _scrollController.position.viewportDimension;

    final current = (offset / pageHeight).floor() + 1;
    final total = ((totalHeight - 1.0) / pageHeight).ceil();
    final effectiveTotal = total < 1 ? 1 : total;
    final displayedTotal = effectiveTotal < _requestedPageCount
        ? _requestedPageCount
        : effectiveTotal;

    if (current != _currentPageNum ||
        displayedTotal != _totalPages ||
        effectiveTotal > _requestedPageCount) {
      _currentPageNum =
          current < 1 ? 1 : (current > displayedTotal ? displayedTotal : current);
      _totalPages = displayedTotal;
      _requestedPageCount =
          effectiveTotal > _requestedPageCount ? effectiveTotal : _requestedPageCount;
    }
  }

  void _scrollToPage(int page) {
    final pageHeight = _calculatePageHeight(context);
    if (!_scrollController.hasClients) return;
    final target = (page - 1) * pageHeight + 24.0;
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _focusEditorAtEnd() {
    final int offset = _quillController.document.length - 1;
    if (offset < 0) return;
    _quillController.updateSelection(
      TextSelection.collapsed(offset: offset),
      quill.ChangeSource.local,
    );
  }

  void _ensureDocumentHasPage(int page) {
    if (page < 1) return;
    final double pageWidth = _calculatePageWidth(context);
    final double pageHeight = _calculatePageHeight(context);
    final double marginMm = _getMarginMm();
    final double pageMargin = pageWidth * (marginMm / _pageWidthMm());

    const double fontSize = 15.0;
    final double lineHeightPx = fontSize * _lineSpacing;
    final double contentHeight = pageHeight - (pageMargin * 2);
    final double linesPerPage = contentHeight / lineHeightPx;

    const double avgCharWidthPx = 7.0;
    final double contentWidth = pageWidth - (pageMargin * 2);
    final double charsPerLine = contentWidth / avgCharWidthPx;
    final int approxCharsPerPage = (linesPerPage * charsPerLine).ceil();

    final String plain = _quillController.document.toPlainText();
    final int currentChars = plain.length;
    final int currentPages =
        (currentChars / (approxCharsPerPage > 0 ? approxCharsPerPage : 1)).ceil();
    if (currentPages >= page) return;

    final int neededPages = page - currentPages;
    final int charsToInsert = neededPages * approxCharsPerPage;
    if (charsToInsert <= 0) return;

    final int insertAt =
        _quillController.document.length > 0 ? _quillController.document.length - 1 : 0;
    final String filler = List.filled(charsToInsert, '\n').join();
    _quillController.document.insert(insertAt, filler);
  }

  void _focusEditorAtPage(int page) {
    if (page < 1) page = 1;
    _ensureDocumentHasPage(page);

    final double pageWidth = _calculatePageWidth(context);
    final double marginMm = _getMarginMm();
    final double pageMargin = pageWidth * (marginMm / _pageWidthMm());

    const double fontSize = 15.0;
    final double lineHeightPx = fontSize * _lineSpacing;

    final double contentWidth = pageWidth - (pageMargin * 2);
    const double avgCharWidthPx = 7.0;
    final double charsPerLine = contentWidth / avgCharWidthPx;

    final double pageHeight = _calculatePageHeight(context);
    final double contentHeight = pageHeight - (pageMargin * 2);
    final double linesPerPage = contentHeight / lineHeightPx;
    final int approxCharsPerPage = (linesPerPage * charsPerLine).ceil();

    final int targetOffset =
        ((page - 1) * approxCharsPerPage).clamp(0, _quillController.document.length - 1);

    _quillController.updateSelection(
      TextSelection.collapsed(offset: targetOffset),
      quill.ChangeSource.local,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editorFocusNode.requestFocus();
    });
  }

  void _insertPageBreak() {
    final int offset = _quillController.selection.baseOffset;
    if (offset < 0) return;

    final block = quill.BlockEmbed.custom(const quill.CustomBlockEmbed('pageBreak', 'pageBreak'));
    _quillController.document.insert(offset, block);
    _quillController.document.insert(offset + 1, '\n');
    
    _quillController.updateSelection(
      TextSelection.collapsed(offset: offset + 2),
      quill.ChangeSource.local,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageCount();
      _scrollToPage(_totalPages);
    });
  }

  void _addNextPage() {
    _insertPageBreak();
  }

  // ══════════════════════════════════════════════════════════════════
  // SAVE / EXPORT / IMPORT  (Business logic — unchanged)
  // ══════════════════════════════════════════════════════════════════

  Future<void> _saveDocument() async {
    setState(() => _isSaving = true);
    try {
      final deltaJson =
          jsonEncode(_quillController.document.toDelta().toJson());
      final encryptedContent = DocumentCrypto.encryptContent(deltaJson);
      final now = DateTime.now();
      final doc = ChamberDocument(
        id: _documentId,
        title: _titleController.text.trim().isEmpty
            ? 'Untitled Document'
            : _titleController.text.trim(),
        encryptedContent: encryptedContent,
        createdBy:
            _isNewDocument ? widget.userEmail : widget.existingDocument!.createdBy,
        category: '',
        createdAt:
            _isNewDocument ? now : widget.existingDocument!.createdAt,
        lastEditedBy: widget.userEmail,
        lastEditedAt: now,
      );
      await DocumentService.saveDocument(doc);
      await DocumentService.logAuditEvent(DocumentAuditLog(
        documentId: _documentId,
        documentTitle: doc.title,
        action: _isNewDocument ? DocumentAction.created : DocumentAction.edited,
        performedBy: widget.userEmail,
        performedAt: now,
        details: '',
      ));
      _isNewDocument = false;
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _hasUnsavedChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.lock_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Document encrypted & saved to Chamber Vault',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.successGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving document: $e',
              style: const TextStyle(fontFamily: 'Montserrat')),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.errorRed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  docx.DocxBuiltDocument _buildDocxDocument() {
    final builder = docx.docx();
    builder.section(pageSize: _pageSize);

    if (_headerController.text.trim().isNotEmpty) {
      builder.p(_headerController.text.trim());
      builder.p(''); // Space below header
    }

    builder.h1(_titleController.text.trim().isEmpty
        ? 'Untitled Document'
        : _titleController.text.trim());
    builder.p('');
    for (final child in _quillController.document.root.children) {
      if (child is quill.Line) {
        final attributes = child.style.attributes;
        final headerVal = attributes['header']?.value;
        final listVal = attributes['list']?.value;
        final alignVal = attributes['align']?.value;
        final textRuns = <docx.DocxText>[];
        for (final leaf in child.children) {
          if (leaf is quill.QuillText) {
            final text = leaf.value;
            final style = leaf.style;
            final isBold = style.containsKey('bold');
            final isItalic = style.containsKey('italic');
            final isStrike = style.containsKey('strike');
            final isUnderline = style.containsKey('underline');
            textRuns.add(docx.DocxText(
              text,
              fontWeight: isBold
                  ? docx.DocxFontWeight.bold
                  : docx.DocxFontWeight.normal,
              fontStyle: isItalic
                  ? docx.DocxFontStyle.italic
                  : docx.DocxFontStyle.normal,
              decoration: isUnderline
                  ? docx.DocxTextDecoration.underline
                  : (isStrike
                      ? docx.DocxTextDecoration.strikethrough
                      : docx.DocxTextDecoration.none),
            ));
          }
        }
        docx.DocxAlign align = docx.DocxAlign.left;
        if (alignVal == 'center') align = docx.DocxAlign.center;
        if (alignVal == 'right') align = docx.DocxAlign.right;
        if (alignVal == 'justify') align = docx.DocxAlign.justify;
        if (headerVal == 1) {
          final text = child.toPlainText().trim();
          if (text.isNotEmpty) builder.h1(text);
        } else if (headerVal == 2) {
          final text = child.toPlainText().trim();
          if (text.isNotEmpty) builder.h2(text);
        } else if (listVal == 'bullet') {
          builder.bullet([child.toPlainText().trim()]);
        } else if (listVal == 'ordered') {
          builder.numbered([child.toPlainText().trim()]);
        } else {
          final text = child.toPlainText().replaceAll('\n', '').trim();
          if (text.isEmpty && child.toPlainText() == '\n') {
            builder.p('');
          } else {
            builder.paragraph(
                docx.DocxParagraph(align: align, children: textRuns));
          }
        }
      } else if (child is quill.Block) {
        for (final blockChild in child.children) {
          if (blockChild is quill.Line) {
            final listVal = blockChild.style.attributes['list']?.value;
            final text = blockChild.toPlainText().trim();
            if (listVal == 'bullet') {
              builder.bullet([text]);
            } else if (listVal == 'ordered') {
              builder.numbered([text]);
            } else {
              builder.p(text);
            }
          }
        }
      }
    }
    return builder.build();
  }

  Future<void> _exportDocument() async {
    try {
      final docxDoc = _buildDocxDocument();
      final bytes = await docx.DocxExporter().exportToBytes(docxDoc);
      final title = _titleController.text.trim().isEmpty
          ? 'Untitled_Document'
          : _titleController.text.trim().replaceAll(' ', '_');
      final result = await FilePicker.saveFile(
        dialogTitle: 'Export Chamber Document (Word)',
        fileName: '$title.docx',
        type: FileType.custom,
        allowedExtensions: ['docx'],
        bytes: bytes,
      );
      if (result != null) {
        await DocumentService.logAuditEvent(DocumentAuditLog(
          documentId: _documentId,
          documentTitle: _titleController.text.trim(),
          action: DocumentAction.exported,
          performedBy: widget.userEmail,
          performedAt: DateTime.now(),
          details: 'Exported as DOCX to $result',
        ));
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.successGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.download_done_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Exported to $result',
                      style: const TextStyle(
                          fontFamily: 'Montserrat', color: Colors.white),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.errorRed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('Export error: $e',
              style: const TextStyle(fontFamily: 'Montserrat')),
        ),
      );
    }
  }

  Future<void> _importWordDocument() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: AppTheme.accentColor.withValues(alpha: 0.25)),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: AppTheme.accentColor, size: 22),
            SizedBox(width: 10),
            Text('Import Word Document',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary)),
          ],
        ),
        content: const Text(
          'Importing a Word document will replace all current contents of this editor. Do you want to continue?',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCEL',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('IMPORT',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;
        final fileTitle =
            fileName.replaceAll('.docx', '').replaceAll('_', ' ');
        final deltaOps = DocxParser.parseDocxToDelta(fileBytes);
        setState(() {
          _quillController.document = Document.fromJson(deltaOps);
          if (_titleController.text == 'Untitled Document' ||
              _titleController.text.trim().isEmpty) {
            _titleController.text = fileTitle;
          }
          _hasUnsavedChanges = true;
        });
        await DocumentService.logAuditEvent(DocumentAuditLog(
          documentId: _documentId,
          documentTitle: _titleController.text,
          action: DocumentAction.imported,
          performedBy: widget.userEmail,
          performedAt: DateTime.now(),
          details: 'Imported Word document: $fileName to editor',
        ));
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.successGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.upload_file_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Imported "$fileName". Remember to save to encrypt and store.',
                    style: const TextStyle(
                        fontFamily: 'Montserrat', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.errorRed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('Import error: $e',
              style: const TextStyle(fontFamily: 'Montserrat')),
        ),
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // BUILD — Main scaffold
  // ══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.keyS, control: true):
            const _SaveIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SaveIntent: CallbackAction<_SaveIntent>(
            onInvoke: (_) {
              _saveDocument();
              return null;
            },
          ),
        },
        child: Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF3F2F1),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2B579A),
              surface: Colors.white,
            ),
          ),
          child: ResponsiveScaffold(
            backgroundColor: const Color(0xFFF3F2F1),
            body: SafeArea(
              child: Column(
              children: [
                _buildWordTitleBar(),
                _buildRibbonArea(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showNavigationPane) _buildNavigationPane(),
                      Expanded(
                        child: Column(
                          children: [
                            if (_isPageView) _buildRuler(),
                            Expanded(child: _buildPageCanvas()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBar(),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TITLE BAR — Word-style compact title bar
  // ══════════════════════════════════════════════════════════════════

  Widget _buildWordTitleBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2B579A), // Word Blue
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 20),
            onPressed: () {
              if (_hasUnsavedChanges) {
                _showUnsavedChangesDialog();
              } else {
                Navigator.of(context).pop(true);
              }
            },
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          // Logo
          Image.asset('assets/logo.png', width: 24, height: 24),
          const SizedBox(width: 10),
          // Document icon
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.description_outlined,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          // Editable title
          Expanded(
            child: TextField(
              controller: _titleController,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Untitled Document',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          // AES-256 badge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded,
                    size: 11, color: Colors.white),
                SizedBox(width: 4),
                Text('AES-256',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
          // Save button
          _isSaving
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentColor)),
                  ),
                )
              : IconButton(
                  tooltip: _hasUnsavedChanges ? 'Save (Ctrl+S)' : 'Saved',
                  icon: Icon(
                    _hasUnsavedChanges
                        ? Icons.save_rounded
                        : Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: _saveDocument,
                ),
          // More menu
          PopupMenuButton<String>(
            tooltip: 'More actions',
            icon: const Icon(Icons.more_vert_rounded,
                color: Colors.white, size: 20),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: AppTheme.accentColor.withValues(alpha: 0.15)),
            ),
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportDocument();
                  break;
                case 'import':
                  _importWordDocument();
                  break;
                case 'addPage':
                  _addNextPage();
                  break;
              }
            },
            itemBuilder: (ctx) => [
              _popupItem('export', Icons.file_download_outlined,
                  'Export as Word (.docx)'),
              _popupItem('import', Icons.file_upload_outlined,
                  'Import from Word (.docx)'),
              _popupItem(
                  'addPage', Icons.post_add_rounded, 'Add Next Page'),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _popupItem(
      String value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RIBBON — Tab strip + active tab content
  // ══════════════════════════════════════════════════════════════════

  Widget _buildRibbonArea() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2F1),
        border: Border(
          bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabStrip(),
          _buildActiveRibbonContent(),
        ],
      ),
    );
  }

  Widget _buildTabStrip() {
    const tabs = ['Home', 'Insert', 'Layout'];
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = _activeRibbonTab == i;
          return InkWell(
            onTap: () => setState(() => _activeRibbonTab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active
                        ? const Color(0xFF2B579A)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active
                      ? const Color(0xFF2B579A)
                      : Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveRibbonContent() {
    switch (_activeRibbonTab) {
      case 1:
        return _buildInsertRibbon();
      case 2:
        return _buildLayoutRibbon();
      default:
        return _buildHomeRibbon();
    }
  }

  // ── Home Ribbon ────────────────────────────────────────────────────

  Widget _buildHomeRibbon() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Font Group ───
            _ribbonGroup('Font', [
              _fontFamilyPicker(),
              const SizedBox(width: 4),
              _fontSizePicker(),
              const SizedBox(width: 2),
              _ribbonIconBtn(Icons.text_increase_rounded, 'Increase Size',
                  () {
                final cur =
                    double.tryParse(_currentSize) ?? 15;
                final idx = _fontSizes
                    .indexWhere((s) => (double.tryParse(s) ?? 0) > cur);
                if (idx >= 0) _setFontSize(_fontSizes[idx]);
              }),
              _ribbonIconBtn(Icons.text_decrease_rounded, 'Decrease Size',
                  () {
                final cur =
                    double.tryParse(_currentSize) ?? 15;
                final idx = _fontSizes
                    .lastIndexWhere((s) => (double.tryParse(s) ?? 0) < cur);
                if (idx >= 0) _setFontSize(_fontSizes[idx]);
              }),
            ]),
            _ribbonDivider(),

            // ─── Format Group ───
            _ribbonGroup('Format', [
              _ribbonToggle(Icons.format_bold_rounded, 'Bold', 'bold',
                  () => _toggleFormat(Attribute.bold)),
              _ribbonToggle(Icons.format_italic_rounded, 'Italic',
                  'italic', () => _toggleFormat(Attribute.italic)),
              _ribbonToggle(
                  Icons.format_underlined_rounded,
                  'Underline',
                  'underline',
                  () => _toggleFormat(Attribute.underline)),
              _ribbonToggle(
                  Icons.format_strikethrough_rounded,
                  'Strikethrough',
                  'strike',
                  () => _toggleFormat(Attribute.strikeThrough)),
            ]),
            _ribbonDivider(),

            // ─── Paragraph Group ───
            _ribbonGroup('Paragraph', [
              _ribbonAlignBtn(Icons.format_align_left_rounded, 'Left',
                  'left', Attribute.leftAlignment),
              _ribbonAlignBtn(Icons.format_align_center_rounded, 'Center',
                  'center', Attribute.centerAlignment),
              _ribbonAlignBtn(Icons.format_align_right_rounded, 'Right',
                  'right', Attribute.rightAlignment),
              _ribbonAlignBtn(Icons.format_align_justify_rounded,
                  'Justify', 'justify', Attribute.justifyAlignment),
            ]),
            _ribbonDivider(),

            // ─── Lists Group ───
            _ribbonGroup('Lists', [
              _ribbonListBtn(Icons.format_list_bulleted_rounded, 'Bullets',
                  'bullet', Attribute.ul),
              _ribbonListBtn(Icons.format_list_numbered_rounded, 'Numbers',
                  'ordered', Attribute.ol),
              _ribbonListBtn(Icons.checklist_rounded, 'Checklist',
                  'unchecked', Attribute.unchecked),
            ]),
            _ribbonDivider(),

            // ─── Indent Group ───
            _ribbonGroup('Indent', [
              _ribbonIconBtn(
                  Icons.format_indent_decrease_rounded, 'Outdent', _outdent),
              _ribbonIconBtn(
                  Icons.format_indent_increase_rounded, 'Indent', _indent),
            ]),
            _ribbonDivider(),

            // ─── Styles Group ───
            _ribbonGroup('Styles', [
              _ribbonHeaderBtn('H1', 1),
              _ribbonHeaderBtn('H2', 2),
              _ribbonHeaderBtn('H3', 3),
            ]),
            _ribbonDivider(),

            // ─── Spacing Group ───
            _ribbonGroup('Spacing', [
              _lineSpacingPicker(),
            ]),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // ── Insert Ribbon ──────────────────────────────────────────────────

  Widget _buildInsertRibbon() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ribbonGroup('Pages', [
            _ribbonTextBtn(Icons.post_add_rounded, 'Add Page', () {
              _insertPageBreak();
            }),
          ]),
          _ribbonDivider(),
          _ribbonGroup('Blocks', [
            _ribbonToggle(Icons.code_rounded, 'Code Block', 'code-block',
                () => _setBlockFormat(Attribute.codeBlock)),
            _ribbonToggle(
                Icons.format_quote_rounded,
                'Block Quote',
                'blockquote',
                () => _setBlockFormat(Attribute.blockQuote)),
          ]),
          _ribbonDivider(),
          _ribbonGroup('Tools', [
            _ribbonIconBtn(Icons.search_rounded, 'Search & Replace', () {
              // Trigger QuillEditor's built-in search
              _editorFocusNode.requestFocus();
            }),
            _ribbonIconBtn(Icons.undo_rounded, 'Undo', () {
              _quillController.undo();
            }),
            _ribbonIconBtn(Icons.redo_rounded, 'Redo', () {
              _quillController.redo();
            }),
          ]),
        ],
      ),
    );
  }

  // ── Layout Ribbon ──────────────────────────────────────────────────

  Widget _buildLayoutRibbon() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Page Size ───
            _ribbonGroup('Page Size', [
              _layoutDropdown<docx.DocxPageSize>(
                value: _pageSize,
                items: {
                  docx.DocxPageSize.a4: 'A4',
                  docx.DocxPageSize.letter: 'Letter',
                  docx.DocxPageSize.legal: 'Legal',
                },
                onChanged: (v) => setState(() => _pageSize = v),
              ),
            ]),
            _ribbonDivider(),

            // ─── Margins ───
            _ribbonGroup('Margins', [
              _layoutDropdown<String>(
                value: _marginPreset,
                items: const {
                  'Normal': 'Normal (1")',
                  'Narrow': 'Narrow (½")',
                  'Wide': 'Wide (1½")',
                },
                onChanged: (v) => setState(() => _marginPreset = v),
              ),
            ]),
            _ribbonDivider(),

            // ─── Orientation ───
            _ribbonGroup('Orientation', [
              _ribbonIconBtn(
                Icons.crop_portrait_rounded,
                'Portrait',
                () => setState(() => _isLandscape = false),
                active: !_isLandscape,
              ),
              _ribbonIconBtn(
                Icons.crop_landscape_rounded,
                'Landscape',
                () => setState(() => _isLandscape = true),
                active: _isLandscape,
              ),
            ]),
            _ribbonDivider(),

            // ─── View ───
            _ribbonGroup('View', [
              _ribbonIconBtn(
                Icons.article_rounded,
                'Page View',
                () {
                  setState(() {
                    _isPageView = true;
                    _currentPageNum = 1;
                    _totalPages = 1;
                    _requestedPageCount = 1;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updatePageCount();
                  });
                },
                active: _isPageView,
              ),
              _ribbonIconBtn(
                Icons.subject_rounded,
                'Continuous',
                () {
                  setState(() {
                    _isPageView = false;
                    _currentPageNum = 1;
                    _totalPages = 1;
                    _requestedPageCount = 1;
                  });
                },
                active: !_isPageView,
              ),
              _ribbonIconBtn(
                Icons.vertical_split_rounded,
                'Nav Pane',
                () {
                  setState(() {
                    _showNavigationPane = !_showNavigationPane;
                  });
                },
                active: _showNavigationPane,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // NAVIGATION PANE
  // ══════════════════════════════════════════════════════════════════

  Widget _buildNavigationPane() {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(2, 0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
            child: const Text(
              'Navigation',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B579A),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final int page = index + 1;
                final bool isSelected = _currentPageNum == page;
                return InkWell(
                  onTap: () {
                    if (_isPageView) {
                      _scrollToPage(page);
                    } else {
                      _focusEditorAtPage(page);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2B579A).withValues(alpha: 0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2B579A) : Colors.grey.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Abstract lines simulating text
                              Positioned(top: 12, left: 10, right: 10, child: Container(height: 3, color: Colors.grey[300])),
                              Positioned(top: 20, left: 10, right: 20, child: Container(height: 3, color: Colors.grey[300])),
                              Positioned(top: 28, left: 10, right: 15, child: Container(height: 3, color: Colors.grey[300])),
                              Positioned(top: 40, left: 10, right: 10, child: Container(height: 3, color: Colors.grey[300])),
                              Positioned(top: 48, left: 10, right: 30, child: Container(height: 3, color: Colors.grey[300])),
                              Positioned(top: 56, left: 10, right: 10, child: Container(height: 3, color: Colors.grey[300])),
                              Center(
                                child: Icon(Icons.description_outlined,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Page $page',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? const Color(0xFF2B579A) : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RULER
  // ══════════════════════════════════════════════════════════════════

  Widget _buildRuler() {
    final pageWidth = _calculatePageWidth(context);
    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        border: Border(
          bottom: BorderSide(
              color: AppTheme.textSecondary.withValues(alpha: 0.10)),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: pageWidth,
          height: 26,
          child: CustomPaint(
            painter: _RulerPainter(
              pageWidthMm: _pageWidthMm(),
              marginMm: _getMarginMm(),
              tickColor: AppTheme.textSecondary.withValues(alpha: 0.45),
              marginColor: AppTheme.accentColor,
              bgColor: AppTheme.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // PAGE CANVAS
  // ══════════════════════════════════════════════════════════════════

  Widget _buildPageCanvas() {
    final double pageWidth = _calculatePageWidth(context);
    final double pageHeight = _calculatePageHeight(context);
    final double marginMm = _getMarginMm();
    final double pageMargin = pageWidth * (marginMm / _pageWidthMm());

    final Color textColor =
        _isPageView ? Colors.black87 : Colors.black87;
    final Color hintColor = _isPageView
        ? Colors.black38
        : Colors.black38;
    final Color h1Color =
        _isPageView ? Colors.black87 : const Color(0xFF2B579A); // Word Blue for headings
    final Color h2Color =
        _isPageView ? Colors.black87 : const Color(0xFF2B579A);

    final Widget baseEditor = QuillEditor.basic(
      controller: _quillController,
      focusNode: _editorFocusNode,
      scrollController: _isPageView ? ScrollController() : _scrollController,
      config: QuillEditorConfig(
        autoFocus: false,
        scrollable: !_isPageView,
        expands: !_isPageView,
        padding: _isPageView
            ? EdgeInsets.symmetric(
                horizontal: pageMargin, vertical: pageMargin)
            : const EdgeInsets.all(32),
        embedBuilders: [const PageBreakEmbedBuilder()],
        placeholder: 'Start typing your document here...',
        customStyles: DefaultStyles(
          paragraph: DefaultTextBlockStyle(
            TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: textColor,
              height: _lineSpacing,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(6, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
          h1: DefaultTextBlockStyle(
            TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: h1Color,
              height: 1.4,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(16, 6),
            const VerticalSpacing(0, 0),
            null,
          ),
          h2: DefaultTextBlockStyle(
            TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: h2Color,
              height: 1.4,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(12, 4),
            const VerticalSpacing(0, 0),
            null,
          ),
          h3: DefaultTextBlockStyle(
            TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.4,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(10, 4),
            const VerticalSpacing(0, 0),
            null,
          ),
          bold: TextStyle(fontWeight: FontWeight.w800, color: textColor),
          italic: TextStyle(fontStyle: FontStyle.italic, color: textColor),
          placeHolder: DefaultTextBlockStyle(
            TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: hintColor,
              height: _lineSpacing,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(6, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
        ),
      ),
    );

    if (!_isPageView) {
      // Continuous view — dark background, full-width editor
      return Container(
        color: Colors.white,
        child: baseEditor,
      );
    }

    // Page view — white page sheets on dark canvas
    return Container(
      color: const Color(0xFFE6E6E6), // Word-like light canvas
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - (_showNavigationPane ? 180 : 0),
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Align(
          key: _editorContentKey,
          alignment: Alignment.topCenter,
          child: Container(
            width: pageWidth,
            constraints: BoxConstraints(
              minHeight: pageHeight * _requestedPageCount,
            ),
            margin: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRect(
              child: CustomPaint(
                foregroundPainter: _PageBoundaryPainter(
                  pageHeight: pageHeight,
                  pageMargin: pageMargin,
                  lineColor:
                      Colors.grey.withValues(alpha: 0.3),
                  textColor:
                      Colors.grey.withValues(alpha: 0.8),
                  gapColor: const Color(0xFFE6E6E6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isPageView)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: pageMargin, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                        ),
                        child: TextField(
                          controller: _headerController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Colors.grey.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add Global Header...',
                            hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.4)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    baseEditor,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // STATUS BAR
  // ══════════════════════════════════════════════════════════════════

  Widget _buildStatusBar() {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B579A), // Word Blue
        border: Border(
          top: BorderSide(
              color: Colors.white.withValues(alpha: 0.10)),
        ),
      ),
      child: Row(
        children: [
          // Page indicator
          Icon(Icons.description_outlined,
              size: 12,
              color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(width: 6),
          Text(
            _isPageView
                ? 'Page $_currentPageNum of $_totalPages'
                : 'Continuous View',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),

          // Separator
          Container(
            width: 1,
            height: 14,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 20),

          // Word count
          Icon(Icons.text_fields_rounded,
              size: 12,
              color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(width: 6),
          Text(
            '$_wordCount word${_wordCount == 1 ? '' : 's'}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          // Document status
          Text(
            _isNewDocument ? 'New Document' : 'Editing',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 12),

          // Zoom display
          Text(
            '100%',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  // ══════════════════════════════════════════════════════════════════
  // RIBBON HELPER WIDGETS
  // ══════════════════════════════════════════════════════════════════

  /// Wraps children in a labeled ribbon group with a small label below.
  Widget _ribbonGroup(String label, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 2),
        Row(mainAxisSize: MainAxisSize.min, children: children),
        const Spacer(),
        Text(label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 2),
      ],
    );
  }

  /// Thin vertical separator between ribbon groups.
  Widget _ribbonDivider() {
    return Container(
      width: 1,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppTheme.textSecondary.withValues(alpha: 0.10),
    );
  }

  /// Simple icon button for the ribbon.
  Widget _ribbonIconBtn(
      IconData icon, String tooltip, VoidCallback onPressed,
      {bool active = false}) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active
                ? AppTheme.accentColor.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon,
              size: 18,
              color: active
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary),
        ),
      ),
    );
  }

  /// Text button with an icon for prominent ribbon actions.
  Widget _ribbonTextBtn(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.accentColor),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentColor,
            )),
          ],
        ),
      ),
    );
  }

  /// Toggle button that reads active state from the controller.
  Widget _ribbonToggle(
      IconData icon, String tooltip, String attrKey, VoidCallback onTap) {
    final active = _isFormatActive(attrKey);
    return _ribbonIconBtn(icon, tooltip, onTap, active: active);
  }

  /// Alignment button — checks current alignment value.
  Widget _ribbonAlignBtn(
      IconData icon, String tooltip, String value, Attribute attr) {
    final current = _getFormatValue('align')?.toString();
    final active = current == value || (value == 'left' && current == null);
    return _ribbonIconBtn(icon, tooltip, () => _setBlockFormat(attr),
        active: active);
  }

  /// List button — checks current list type.
  Widget _ribbonListBtn(
      IconData icon, String tooltip, String value, Attribute attr) {
    final current = _getFormatValue('list')?.toString();
    final active = current == value;
    return _ribbonIconBtn(icon, tooltip, () => _setBlockFormat(attr),
        active: active);
  }

  /// Header style button (H1, H2, H3).
  Widget _ribbonHeaderBtn(String label, int level) {
    final current = _getFormatValue('header');
    final active = current == level;
    return Tooltip(
      message: 'Heading $level',
      child: InkWell(
        onTap: () {
          if (active) {
            _quillController.formatSelection(
                Attribute('header', AttributeScope.block, null));
          } else {
            _quillController.formatSelection(
                Attribute('header', AttributeScope.block, level));
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active
                ? AppTheme.accentColor.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: active
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  /// Font family picker dropdown.
  Widget _fontFamilyPicker() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _fontFamilies.contains(_currentFont) ? _currentFont : 'Montserrat',
          isDense: true,
          dropdownColor: AppTheme.surfaceColor,
          icon: const Icon(Icons.arrow_drop_down,
              size: 16, color: AppTheme.textSecondary),
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: AppTheme.textPrimary),
          items: _fontFamilies
              .map((f) => DropdownMenuItem(
                    value: f,
                    child: Text(f,
                        style: TextStyle(
                            fontFamily: f,
                            fontSize: 11,
                            color: AppTheme.textPrimary)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) _setFont(v);
          },
        ),
      ),
    );
  }

  /// Font size picker dropdown.
  Widget _fontSizePicker() {
    final curSize = _fontSizes.contains(_currentSize) ? _currentSize : '15';
    return Container(
      height: 30,
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _fontSizes.contains(curSize) ? curSize : null,
          hint: Text(curSize,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: AppTheme.textPrimary)),
          isDense: true,
          dropdownColor: AppTheme.surfaceColor,
          icon: const Icon(Icons.arrow_drop_down,
              size: 16, color: AppTheme.textSecondary),
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: AppTheme.textPrimary),
          items: _fontSizes
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: AppTheme.textPrimary)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) _setFontSize(v);
          },
        ),
      ),
    );
  }

  /// Line spacing picker.
  Widget _lineSpacingPicker() {
    const spacings = [1.0, 1.15, 1.5, 2.0, 2.5, 3.0];
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<double>(
          value: spacings.contains(_lineSpacing) ? _lineSpacing : 1.5,
          isDense: true,
          dropdownColor: AppTheme.surfaceColor,
          icon: const Icon(Icons.arrow_drop_down,
              size: 16, color: AppTheme.textSecondary),
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: AppTheme.textPrimary),
          items: spacings
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text('${s}x',
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: AppTheme.textPrimary)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _lineSpacing = v);
          },
        ),
      ),
    );
  }

  /// Generic dropdown for the Layout ribbon.
  Widget _layoutDropdown<T>({
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          dropdownColor: AppTheme.surfaceColor,
          icon: const Icon(Icons.arrow_drop_down,
              size: 16, color: AppTheme.textSecondary),
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: AppTheme.textPrimary),
          items: items.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: AppTheme.textPrimary)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // UNSAVED CHANGES DIALOG
  // ══════════════════════════════════════════════════════════════════

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: AppTheme.accentColor.withValues(alpha: 0.25)),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: AppTheme.accentColor, size: 22),
            SizedBox(width: 10),
            Text('Unsaved Changes',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary)),
          ],
        ),
        content: const Text(
          'You have unsaved changes. Do you want to save before leaving?',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text('DISCARD',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _saveDocument();
              if (!mounted) return;
              Navigator.of(context).pop(true);
            },
            child: const Text('SAVE & EXIT',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ══════════════════════════════════════════════════════════════════════

/// Draws a horizontal ruler with cm tick marks and margin indicators.
class _RulerPainter extends CustomPainter {
  final double pageWidthMm;
  final double marginMm;
  final Color tickColor;
  final Color marginColor;
  final Color bgColor;

  _RulerPainter({
    required this.pageWidthMm,
    required this.marginMm,
    required this.tickColor,
    required this.marginColor,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pxPerMm = size.width / pageWidthMm;
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 0.8;

    // Baseline
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      tickPaint,
    );

    // Content area background (between margins)
    final leftMarginPx = marginMm * pxPerMm;
    final rightMarginPx = (pageWidthMm - marginMm) * pxPerMm;
    canvas.drawRect(
      Rect.fromLTRB(leftMarginPx, 2, rightMarginPx, size.height - 2),
      Paint()..color = bgColor,
    );

    // Tick marks
    for (int mm = 0; mm <= pageWidthMm.round(); mm += 5) {
      final x = mm * pxPerMm;
      final isCm = mm % 10 == 0;
      final tickH = isCm ? 10.0 : 5.0;

      canvas.drawLine(
        Offset(x, size.height - 1),
        Offset(x, size.height - 1 - tickH),
        tickPaint,
      );

      // Cm number labels
      if (isCm && mm > 0 && mm < pageWidthMm.round()) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${mm ~/ 10}',
            style: TextStyle(
                color: tickColor,
                fontSize: 8,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(
          canvas,
          Offset(x - tp.width / 2,
              size.height - 1 - tickH - tp.height - 1),
        );
      }
    }

    // Margin triangles
    final mPaint = Paint()..color = marginColor;
    // Left margin ▼
    _drawTriangle(canvas, leftMarginPx, size.height - 2, mPaint);
    // Right margin ▼
    _drawTriangle(canvas, rightMarginPx, size.height - 2, mPaint);
  }

  void _drawTriangle(Canvas canvas, double cx, double bottom, Paint paint) {
    canvas.drawPath(
      Path()
        ..moveTo(cx, bottom)
        ..lineTo(cx - 5, bottom - 7)
        ..lineTo(cx + 5, bottom - 7)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RulerPainter old) {
    return old.pageWidthMm != pageWidthMm || old.marginMm != marginMm;
  }
}

/// Draws page boundary indicators (dashed lines + gap strips) on the editor.
class _PageBoundaryPainter extends CustomPainter {
  final double pageHeight;
  final double pageMargin;
  final Color lineColor;
  final Color textColor;
  final Color gapColor;

  _PageBoundaryPainter({
    required this.pageHeight,
    required this.pageMargin,
    required this.lineColor,
    required this.textColor,
    required this.gapColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gapPaint = Paint()..color = gapColor;

    const double dashW = 6.0;
    const double dashS = 4.0;
    const double gapH = 12.0;

    final tp = TextPainter(textDirection: TextDirection.ltr);

    double pageTop = 0;
    int pageNum = 1;
    while (pageTop + pageHeight <= size.height) {
      final y = pageTop + pageHeight;

      // Dashed line at center of gap
      double sx = 0;
      while (sx < size.width) {
        canvas.drawLine(Offset(sx, y), Offset(sx + dashW, y), paint);
        sx += dashW + dashS;
      }

      // Page break label
      final textSpan = TextSpan(
        text: '  Page $pageNum  ',
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          backgroundColor: gapColor,
        ),
      );
      tp.text = textSpan;
      tp.layout();
      tp.paint(
        canvas,
        Offset(size.width - tp.width - 16, y - tp.height / 2),
      );

      pageTop += pageHeight;
      pageNum++;
    }
  }

  @override
  bool shouldRepaint(covariant _PageBoundaryPainter old) {
    return old.pageHeight != pageHeight || old.lineColor != lineColor;
  }
}

class PageBreakEmbedBuilder extends quill.EmbedBuilder {
  const PageBreakEmbedBuilder();

  @override
  String get key => 'pageBreak';

  @override
  Widget build(
    BuildContext context,
    quill.EmbedContext embedContext,
  ) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Text(
          '--- PAGE BREAK ---',
          style: TextStyle(color: Colors.black54, fontSize: 10, letterSpacing: 2, fontFamily: 'Montserrat'),
        ),
      ),
    );
  }
}

