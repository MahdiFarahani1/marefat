import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_state.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageBookScreen extends StatefulWidget {
  final bool isBack;
  const StorageBookScreen({super.key, required this.isBack});

  @override
  State<StorageBookScreen> createState() => _StorageBookScreenState();
}

class _StorageBookScreenState extends State<StorageBookScreen> {
  @override
  void initState() {
    BlocProvider.of<BookmarkCubit>(context).loadBookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'کتاب‌های ذخیره شده',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: widget.isBack
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))
            : const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<BookmarkCubit>(context).loadBookmarks();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            tooltip: 'بروزرسانی',
          ),
        ],
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: customGradinet()),
        ),
      ),
      body: BlocBuilder<BookmarkCubit, BookMarkState>(
        builder: (context, state) {
          if (state.status == BookMarkStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BookMarkStatus.error) {
            return const Center(
              child: Text('خطا در بارگذاری کتاب‌ها'),
            );
          }

          if (state.bookmarks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'هیچ کتابی ذخیره نشده است!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await BlocProvider.of<BookmarkCubit>(context).loadBookmarks();
            },
            child: AnimatedList(
              initialItemCount: state.bookmarks.length,
              itemBuilder: (context, index, animation) {
                if (index >= state.bookmarks.length) return const SizedBox();
                final bookmark = state.bookmarks[index];
                return _buildAnimatedBookmarkItem(bookmark, animation, index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBookmarkItem(
      Map<String, dynamic> bookmark, Animation<double> animation, int index) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Colors.blue.shade50,
                  ],
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: customGradinet(),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  bookmark['book_name'] ?? 'بدون عنوان',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ذخیره شده',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade600,
                      ),
                      onPressed: () async {
                        await AppDialog.showConfirmDialog(
                          context: context,
                          title: 'الکتاب',
                          message: bookmark['book_name'] ?? 'بدون عنوان',
                          onConfirmed: () {
                            context
                                .read<BookmarkCubit>()
                                .removeBookmark(bookmark['book_id'].toString());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('کتاب با موفقیت حذف شد'),
                                backgroundColor: Colors.green.withOpacity(0.4),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
                onTap: () {
                  // Navigate to book content with hero animation
                  //    _navigateToBook(bookmark);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
