import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_state.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoragePageScreen extends StatefulWidget {
  final bool isBack;
  const StoragePageScreen({super.key, required this.isBack});

  @override
  State<StoragePageScreen> createState() => _StoragePageScreenState();
}

class _StoragePageScreenState extends State<StoragePageScreen> {
  @override
  void initState() {
    super.initState();
    PageBookmarkCubit.instance.loadPageBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: PageBookmarkCubit.instance,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'صفحات ذخیره شده',
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
                PageBookmarkCubit.instance.loadPageBookmarks();
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
        body: BlocBuilder<PageBookmarkCubit, PageBookmarkState>(
          builder: (context, state) {
            if (state.status == PageBookmarkStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == PageBookmarkStatus.error) {
              return const Center(
                child: Text('خطا در بارگذاری صفحات'),
              );
            }

            if (state.pageBookmarks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'هیچ صفحه‌ای ذخیره نشده است!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await PageBookmarkCubit.instance.loadPageBookmarks();
              },
              child: AnimatedList(
                initialItemCount: state.pageBookmarks.length,
                itemBuilder: (context, index, animation) {
                  if (index >= state.pageBookmarks.length)
                    return const SizedBox();
                  final pageBookmark = state.pageBookmarks[index];
                  return _buildAnimatedPageBookmarkItem(
                      pageBookmark, animation, index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedPageBookmarkItem(Map<String, dynamic> pageBookmark,
      Animation<double> animation, int index) {
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
                    Colors.green.shade50,
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
                    Icons.bookmark_added,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  pageBookmark['book_name'] ?? 'بدون عنوان',
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
                        Icons.pages,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'موقعیت: ${pageBookmark['scrollposition']?.toStringAsFixed(1) ?? '0.0'}',
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
                    onPressed: () => _showDeletePageDialog(
                      context,
                      pageBookmark['book_id']?.toString() ?? '',
                      pageBookmark['book_name'] ?? 'بدون عنوان',
                    ),
                    tooltip: 'حذف صفحه',
                  ),
                ),
                onTap: () {
                  // Navigate to book content with scroll position
                  _navigateToPage(pageBookmark);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(Map<String, dynamic> pageBookmark) {
    // Add navigation logic here to open book at specific scroll position
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'باز کردن کتاب: ${pageBookmark['book_name']} در موقعیت ${pageBookmark['scrollposition']?.toStringAsFixed(1)}',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeletePageDialog(
      BuildContext context, String bookId, String bookName) {
    if (bookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('خطا: شناسه کتاب معتبر نیست'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text('حذف صفحه'),
            ],
          ),
          content: Text(
            'آیا مطمئن هستید که می‌خواهید این صفحه از "$bookName" را از لیست ذخیره‌شده‌ها حذف کنید؟',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'لغو',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                PageBookmarkCubit.instance.removePageBookmark(
                    bookId, 0); // Note: page number needs to be extracted
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('صفحه با موفقیت حذف شد'),
                    backgroundColor: Colors.green.withOpacity(0.4),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'حذف',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
