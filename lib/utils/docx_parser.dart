import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;

/// Helper utility to parse Microsoft Word OpenXML (.docx) files
/// and convert their text & formatting to Quill Delta operations.
class DocxParser {
  /// Parses document bytes from a .docx file and returns a list of Quill Delta operations.
  static List<Map<String, dynamic>> parseDocxToDelta(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    
    // Check for word/document.xml inside ZIP
    final documentFile = archive.findFile('word/document.xml');
    if (documentFile == null) {
      throw Exception('Not a valid DOCX file: word/document.xml was not found.');
    }

    final contentBytes = documentFile.content as List<int>;
    final contentString = utf8.decode(contentBytes);
    
    final xmlDoc = xml.XmlDocument.parse(contentString);
    final body = xmlDoc.findAllElements('w:body').firstOrNull;
    if (body == null) {
      return [{'insert': '\n'}];
    }

    final List<Map<String, dynamic>> deltaOps = [];

    // Parse elements in body (paragraphs w:p, tables w:tbl etc.)
    for (final child in body.children) {
      if (child is xml.XmlElement) {
        if (child.name.local == 'p') {
          _parseParagraph(child, deltaOps);
        } else if (child.name.local == 'tbl') {
          // If a table is encountered, extract paragraph elements inside table cells.
          // This ensures table text is imported cleanly without crashing.
          for (final row in child.findAllElements('w:tr')) {
            for (final cell in row.findAllElements('w:tc')) {
              for (final p in cell.findAllElements('w:p')) {
                _parseParagraph(p, deltaOps);
              }
            }
          }
        }
      }
    }

    // Ensure we return at least a newline if the doc was empty
    if (deltaOps.isEmpty) {
      deltaOps.add({'insert': '\n'});
    }

    return deltaOps;
  }

  static void _parseParagraph(xml.XmlElement pElement, List<Map<String, dynamic>> deltaOps) {
    final pPr = pElement.getElement('w:pPr');
    
    // Check for list item numbering
    final numPr = pPr?.getElement('w:numPr');
    final isList = numPr != null;
    String? listType;
    if (isList) {
      final numId = numPr.getElement('w:numId')?.getAttribute('w:val');
      final pStyle = pPr?.getElement('w:pStyle')?.getAttribute('w:val');
      
      if (pStyle != null && pStyle.toLowerCase().contains('bullet')) {
        listType = 'bullet';
      } else {
        // Simple heuristic: odd numId / bullet styles are bullets, others are ordered
        if (numId == '1' || numId == '3' || numId == '5') {
          listType = 'bullet';
        } else {
          listType = 'ordered';
        }
      }
    }

    // Check for headings style (Heading1, Heading2, Heading3)
    final pStyleVal = pPr?.getElement('w:pStyle')?.getAttribute('w:val');
    int? headerLevel;
    if (pStyleVal != null) {
      final styleLower = pStyleVal.toLowerCase();
      if (styleLower == 'heading1' || styleLower == '1' || styleLower.contains('title')) {
        headerLevel = 1;
      } else if (styleLower == 'heading2' || styleLower == '2') {
        headerLevel = 2;
      } else if (styleLower == 'heading3' || styleLower == '3') {
        headerLevel = 3;
      }
    }

    // Check for text alignment (left, right, center, both/justify)
    final jcVal = pPr?.getElement('w:jc')?.getAttribute('w:val');
    String? alignment;
    if (jcVal != null) {
      if (jcVal == 'center') {
        alignment = 'center';
      } else if (jcVal == 'right') {
        alignment = 'right';
      } else if (jcVal == 'both' || jcVal == 'justify') {
        alignment = 'justify';
      }
    }

    // Extract all runs inside the paragraph
    final runs = pElement.findAllElements('w:r');
    for (final r in runs) {
      final t = r.getElement('w:t');
      if (t == null) continue;

      final text = t.innerText;
      if (text.isEmpty) continue;

      final rPr = r.getElement('w:rPr');
      final Map<String, dynamic> attributes = {};

      // Bold style check
      final b = rPr?.getElement('w:b');
      if (b != null) {
        final val = b.getAttribute('w:val');
        if (val == null || val == 'true' || val == '1') {
          attributes['bold'] = true;
        }
      }

      // Italic style check
      final i = rPr?.getElement('w:i');
      if (i != null) {
        final val = i.getAttribute('w:val');
        if (val == null || val == 'true' || val == '1') {
          attributes['italic'] = true;
        }
      }

      // Underline style check
      final u = rPr?.getElement('w:u');
      if (u != null) {
        final val = u.getAttribute('w:val');
        if (val != null && val != 'none') {
          attributes['underline'] = true;
        }
      }

      // Strikethrough style check
      final strike = rPr?.getElement('w:strike');
      if (strike != null) {
        final val = strike.getAttribute('w:val');
        if (val == null || val == 'true' || val == '1') {
          attributes['strike'] = true;
        }
      }

      if (attributes.isNotEmpty) {
        deltaOps.add({
          'insert': text,
          'attributes': attributes,
        });
      } else {
        deltaOps.add({
          'insert': text,
        });
      }
    }

    // Apply paragraph formatting attributes to the terminating newline '\n'
    final Map<String, dynamic> pAttributes = {};
    if (headerLevel != null) {
      pAttributes['header'] = headerLevel;
    }
    if (listType != null) {
      pAttributes['list'] = listType;
    }
    if (alignment != null) {
      pAttributes['align'] = alignment;
    }

    if (pAttributes.isNotEmpty) {
      deltaOps.add({
        'insert': '\n',
        'attributes': pAttributes,
      });
    } else {
      deltaOps.add({
        'insert': '\n',
      });
    }
  }
}
