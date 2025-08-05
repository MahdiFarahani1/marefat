import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentScreen extends StatefulWidget {
  final bool isBack;
  const CommentScreen({super.key, this.isBack = true});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  Future<List<Map<String, dynamic>>>? _commentsFuture;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _commentsFuture = DatabaseStorageHelper.getAllcomments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'کامنت‌های ذخیره شده',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: widget.isBack
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: _loadComments,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'بروزرسانی',
          ),
        ],
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 80, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'خطا در بارگذاری کامنت‌ها',
                    style: TextStyle(fontSize: 18, color: Colors.red.shade600),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loadComments,
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            );
          }

          final comments = snapshot.data ?? [];

          if (comments.isEmpty) {
            return _buildEmptyState();
          }

          return _buildCommentsList(comments);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.comment_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'هیچ کامنتی ذخیره نشده است!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(List<Map<String, dynamic>> comments) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadComments();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _buildCommentItem(comment, index, comments);
        },
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, int index,
      List<Map<String, dynamic>> comments) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.orange.shade50,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with book info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: context
                                .read<SettingsCubit>()
                                .state
                                .primry
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.comment,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['book_name'] ?? 'بدون عنوان',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.bookmark_outline,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'صفحه ${comment['page_number']?.toString() ?? '0'}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              if (comment['title'] != null &&
                                  comment['title'].toString().isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.title,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    comment['title'],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Delete button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        onPressed: () => _showDeleteDialog(
                          context,
                          comment['id'].toString(),
                          comment['book_name'] ?? 'بدون عنوان',
                          index,
                        ),
                        tooltip: 'حذف التعليق',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Comment text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    comment['_text'] ?? comment['comment_text'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Footer with date and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          comment['date_time'] ?? 'تاریخ نامشخص',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Edit button
                    TextButton.icon(
                      onPressed: () => _showEditDialog(context, comment, index),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.blue.shade600,
                      ),
                      label: Text(
                        'ویرایش',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String commentId, String bookName, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text('حذف التعليق'),
            ],
          ),
          content: Text(
            'هل أنت متأكد أنك تريد حذف هذا التعليق من "$bookName"؟',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لغو', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Delete from database
                  await DatabaseStorageHelper.deleteComment(
                    bookName,
                    double.tryParse(commentId) ?? 0.0,
                  );

                  Navigator.of(dialogContext).pop();

                  // Reload comments
                  _loadComments();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('کامنت با موفقیت حذف شد'),
                      backgroundColor: Colors.green.withOpacity(0.4),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('خطأ في حذف التعليق'),
                      backgroundColor: Colors.red.withOpacity(0.4),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('حذف', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      BuildContext context, Map<String, dynamic> comment, int index) {
    final TextEditingController controller = TextEditingController(
      text: comment['_text'] ?? comment['comment_text'] ?? '',
    );
    final TextEditingController titleController = TextEditingController(
      text: comment['title'] ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text('ویرایش کامنت'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان کامنت',
                    hintText: 'عنوان کامنت را وارد کنید...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.read<SettingsCubit>().state.primry,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Comment content field
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'متن کامنت',
                    hintText: 'کامنت خود را وارد کنید...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.read<SettingsCubit>().state.primry,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لغو', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  try {
                    // Update comment in database
                    await DatabaseStorageHelper.updateComment(
                      comment['book_name'] ?? '',
                      comment['page_number']?.toDouble() ?? 0.0,
                      titleController.text.trim().isEmpty
                          ? 'بدون عنوان'
                          : titleController.text.trim(),
                      controller.text.trim(),
                    );

                    Navigator.of(dialogContext).pop();

                    // Reload comments to show changes
                    _loadComments();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('کامنت با موفقیت ویرایش شد'),
                        backgroundColor: Colors.green.withOpacity(0.4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('خطا در ویرایش کامنت'),
                        backgroundColor: Colors.red.withOpacity(0.4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('لطفاً متن کامنت را وارد کنید'),
                      backgroundColor: Colors.orange.withOpacity(0.4),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('ذخیره', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}
