import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/inward_post_model.dart';
import '../services/inward_post_service.dart';
import 'package:intl/intl.dart';
import '../widgets/responsive.dart';

class InwardPostScreen extends StatefulWidget {
  final String currentUserRole;
  final String currentUserName;

  const InwardPostScreen({
    super.key,
    required this.currentUserRole,
    required this.currentUserName,
  });

  @override
  State<InwardPostScreen> createState() => _InwardPostScreenState();
}

class _InwardPostScreenState extends State<InwardPostScreen> {
  final _senderController = TextEditingController();
  final _recipientController = TextEditingController();
  final _receivedByController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<InwardPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await InwardPostService.getPosts();
    if (mounted) {
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _senderController.dispose();
    _recipientController.dispose();
    _receivedByController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _logNewPost() async {
    if (_senderController.text.trim().isEmpty || _recipientController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sender and Recipient are required'), backgroundColor: AppTheme.errorRed),
      );
      return;
    }

    final newPost = InwardPost(
      id: 'POST-\${DateTime.now().millisecondsSinceEpoch}',
      senderName: _senderController.text.trim(),
      recipientName: _recipientController.text.trim(),
      receivedBy: _receivedByController.text.trim().isEmpty ? widget.currentUserName : _receivedByController.text.trim(),
      receivedDate: DateTime.now(),
      status: PostStatus.pendingConfirmation,
      description: _descriptionController.text.trim(),
    );

    await InwardPostService.addPost(newPost);
    
    setState(() {
      _senderController.clear();
      _recipientController.clear();
      _receivedByController.clear();
      _descriptionController.clear();
    });

    await _loadPosts();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post logged successfully!'), backgroundColor: AppTheme.successGreen),
      );
    }
  }

  Future<void> _confirmReceipt(InwardPost post) async {
    await InwardPostService.updatePostStatus(post.id, PostStatus.confirmed);
    await _loadPosts();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt confirmed.'), backgroundColor: AppTheme.successGreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which posts to show. Advocates see only their posts, Staff see all.
    final visiblePosts = _posts.where((post) {
      if (widget.currentUserRole == 'Admin' || widget.currentUserRole == 'Advocate') {
        return post.recipientName.toLowerCase().contains(widget.currentUserName.toLowerCase()) || 
               widget.currentUserName.toLowerCase().contains('admin'); // Simple mock rule
      }
      return true; // Staff/Admins see all
    }).toList();

    return Container(
      color: AppTheme.backgroundColor,
      child: ResponsiveScaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Inward Post Register', 
            style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.textPrimary)
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel: Register New Post (Visible mainly to Staff, but keeping it visible for demo)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('LOG NEW POST', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentColor, letterSpacing: 1.2)),
                        const SizedBox(height: 24),
                        _buildInputField(controller: _senderController, hint: 'Sender / Client Name', icon: Icons.person_outline),
                        const SizedBox(height: 16),
                        _buildInputField(controller: _recipientController, hint: 'Intended Advocate Name', icon: Icons.badge_outlined),
                        const SizedBox(height: 16),
                        _buildInputField(controller: _receivedByController, hint: 'Received Staff Name', icon: Icons.person_search_outlined),
                        const SizedBox(height: 16),
                        _buildInputField(controller: _descriptionController, hint: 'Description / Contents', icon: Icons.description_outlined, maxLines: 3),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _logNewPost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('REGISTER POST', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Right Panel: Post Log List
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('POST ARCHIVES', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _isLoading 
                            ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
                            : ListView.separated(
                            itemCount: visiblePosts.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final post = visiblePosts[index];
                              final isPending = post.status == PostStatus.pendingConfirmation;
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isPending ? AppTheme.errorRed.withOpacity(0.3) : AppTheme.successGreen.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isPending ? AppTheme.errorRed.withOpacity(0.1) : AppTheme.successGreen.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(isPending ? Icons.mark_email_unread_outlined : Icons.mark_email_read_outlined, 
                                            color: isPending ? AppTheme.errorRed : AppTheme.successGreen, size: 20),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('From: \${post.senderName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                                          const SizedBox(height: 4),
                                          Text('To: \${post.recipientName}  •  Recv by: \${post.receivedBy}', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary.withOpacity(0.8))),
                                          if (post.description.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(post.description, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
                                          ]
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(DateFormat('MMM dd, yyyy - hh:mm a').format(post.receivedDate), style: const TextStyle(fontSize: 11, color: AppTheme.accentColor)),
                                        const SizedBox(height: 8),
                                        if (isPending)
                                          ElevatedButton(
                                            onPressed: () => _confirmReceipt(post),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppTheme.errorRed,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              minimumSize: Size.zero,
                                            ),
                                            child: const Text('CONFIRM RECEIPT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          )
                                        else
                                          const Text('RECEIVED', style: TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: maxLines == 1 ? Icon(icon, color: AppTheme.textSecondary.withOpacity(0.8), size: 20) : null,
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5), fontSize: 14),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
