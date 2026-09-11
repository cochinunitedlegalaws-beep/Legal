import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/vault_service.dart';
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/responsive.dart';

class ClientFolderScreen extends StatefulWidget {
  final String clientName;
  final String clientEmail;
  final String folderName;

  const ClientFolderScreen({
    Key? key,
    required this.clientName,
    required this.clientEmail,
    required this.folderName,
  }) : super(key: key);

  @override
  State<ClientFolderScreen> createState() => _ClientFolderScreenState();
}

class _ClientFolderScreenState extends State<ClientFolderScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final allFiles = await VaultService.getFiles(widget.clientEmail);
    setState(() {
      _files = allFiles.where((f) => (f['folder_name'] ?? 'Personal Files') == widget.folderName).toList();
      _isLoading = false;
    });
  }

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc', 'zip', 'jpg', 'png'],
      withData: true,
    );

    if (result != null) {
      PlatformFile pickedFile = result.files.first;
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading ${pickedFile.name}...')));

      await Future.delayed(const Duration(milliseconds: 600)); // Simulate processing
      
      final dateStr = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      final double sizeInMb = pickedFile.size / (1024 * 1024);
      final sizeStr = '${sizeInMb.toStringAsFixed(1)} MB';

      await VaultService.addFile(
        fileName: pickedFile.name,
        uploadDate: dateStr,
        fileSize: sizeStr,
        ownerEmail: widget.clientEmail,
        folderName: widget.folderName,
        fileBytes: pickedFile.bytes,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document uploaded successfully.')));
        _loadFiles();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.folderName, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontFamily: 'Cinzel', fontWeight: FontWeight.bold)),
            Text(widget.clientName, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file, color: AppTheme.accentColor),
            tooltip: 'Upload File',
            onPressed: _uploadFile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
          : _files.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text('This folder is empty', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _uploadFile,
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: const Text('UPLOAD DOCUMENT'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _files.length,
                  itemBuilder: (context, index) {
                    final file = _files[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description, color: AppTheme.accentColor),
                        ),
                        title: Text(file['file_name'] ?? 'Unknown', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('${file['upload_date']} • ${file['file_size']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed, size: 22),
                              tooltip: 'Delete Document',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppTheme.primaryColor,
                                    title: const Text('Delete File?', style: TextStyle(color: AppTheme.textPrimary)),
                                    content: Text('Are you sure you want to delete ${file['file_name']}? This cannot be undone.', style: const TextStyle(color: AppTheme.textSecondary)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary))),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: AppTheme.errorRed))),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await VaultService.deleteClientFile(file['file_name'], file['upload_date'], file['owner_email']);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${file['file_name']} deleted')));
                                    _loadFiles();
                                  }
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility, color: AppTheme.accentColor, size: 22),
                              tooltip: 'View Document',
                              onPressed: () async {
                                String? url;
                                if (file['file_path'] != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Retrieving secure file link...')));
                                  url = await VaultService.getFileUrl(file['file_path']);
                                }
                                
                                if (!context.mounted) return;
                                
                                bool isImage = file['file_name']?.toString().toLowerCase().endsWith('.png') == true ||
                                               file['file_name']?.toString().toLowerCase().endsWith('.jpg') == true ||
                                               file['file_name']?.toString().toLowerCase().endsWith('.jpeg') == true;

                                if (url != null && !isImage) {
                                  // Launch PDF/Docx in browser
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open document.')));
                                  }
                                  return;
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(color: AppTheme.accentColor.withOpacity(0.2)),
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            file['file_name'] ?? 'Document Preview',
                                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontFamily: 'Montserrat'),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (url != null && isImage)
                                              IconButton(
                                                icon: const Icon(Icons.fullscreen, color: AppTheme.textSecondary),
                                                tooltip: 'Full Screen',
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => ResponsiveScaffold(
                                                    backgroundColor: Colors.black,
                                                    appBar: AppBar(
                                                      backgroundColor: Colors.black,
                                                      iconTheme: const IconThemeData(color: Colors.white),
                                                      title: Text(file['file_name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                                    ),
                                                    body: Center(
                                                      child: InteractiveViewer(
                                                        panEnabled: true,
                                                        minScale: 0.5,
                                                        maxScale: 5.0,
                                                        child: Image.network(url!),
                                                      ),
                                                    ),
                                                  )));
                                                },
                                              ),
                                            IconButton(
                                              icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: 600,
                                      height: 400,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceColor,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
                                        ),
                                        child: Center(
                                          child: url != null && isImage 
                                              ? Image.network(url, fit: BoxFit.contain)
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      (file['file_name']?.toString().toLowerCase().endsWith('.pdf') ?? false)
                                                          ? Icons.picture_as_pdf
                                                          : isImage
                                                              ? Icons.image
                                                              : Icons.description,
                                                      size: 80,
                                                      color: AppTheme.accentColor.withOpacity(0.4),
                                                    ),
                                                    const SizedBox(height: 24),
                                                    Text(
                                                      'Previewing ${file['file_name'] ?? 'File'}',
                                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      child: Text(
                                                        file['file_path'] != null ? 'Generating cloud preview...' : '(File preview simulation - File uploaded before cloud storage link)',
                                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.download, color: AppTheme.textSecondary, size: 22),
                              tooltip: 'Download',
                              onPressed: () async {
                                if (file['file_path'] != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Starting download...')));
                                  final url = await VaultService.getFileUrl(file['file_path']);
                                  if (url != null) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get download link.')));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot download simulated file.')));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
