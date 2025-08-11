import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_state.dart';
import 'package:bookapp/features/storage/widgets/empty_list.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/ui_helper/snackbar_common.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoragePageScreen extends StatelessWidget {
  final bool isBack;
  const StoragePageScreen({super.key, required this.isBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الصفحات المحفوظة",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: isBack ? Back.btn(context) : const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () => context.read<PageBookmarkCubit>().loadBookmarks(),
            icon: Assets.newicons.messageCircleRefresh
                .image(color: Theme.of(context).colorScheme.tertiary)
                .padAll(8),
            tooltip: 'بروزرسانی',
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<PageBookmarkCubit, PageBookmarkState>(
        builder: (context, state) {
          if (state.status == PageBookmarkStatus.loading) {
            return Center(child: CustomLoading.fadingCircle(context));
          }

          if (state.status == PageBookmarkStatus.error) {
            return const Center(child: Text('خطا در بارگذاری صفحات'));
          }

          if (state.pageBookmarks.isEmpty) {
            return EmptyList.show(
              context,
              imagePath: Assets.newicons.page.path,
              message: 'لَم يتم حفظ أي صفحة',
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<PageBookmarkCubit>().loadBookmarks(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.pageBookmarks.length,
              itemBuilder: (context, index) {
                final pageBookmark = state.pageBookmarks[index];
                return _PageBookmarkItem(pageBookmark: pageBookmark);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PageBookmarkItem extends StatelessWidget {
  final Map<String, dynamic> pageBookmark;
  const _PageBookmarkItem({required this.pageBookmark});

  @override
  Widget build(BuildContext context) {
    final pageNumber = (pageBookmark['pageNumber'] as num?)?.toInt() ?? 0;
    final bookId = pageBookmark['bookId']?.toString() ?? '';
    final bookName = pageBookmark['bookName'] ?? 'بدون عنوان';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.02),
                Theme.of(context).primaryColor.withOpacity(0.15),
              ],
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Assets.newicons.circleBookmark.image(
                width: 25,
                height: 25,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              bookName,
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
                  Assets.newicons.marker.image(
                    width: 15,
                    height: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'الصفحة: ${pageNumber + 1}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: Assets.newicons.trashXmark
                  .image(width: 20, height: 20, color: Colors.red.shade600),
              onPressed: () =>
                  _confirmDelete(context, bookId, bookName, pageNumber),
              tooltip: 'حذف الصفحة',
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => ContentPage(
                    bookId: bookId,
                    bookName: bookName,
                    scrollPosetion: pageNumber.toDouble(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, String bookId, String bookName, int pageNumber) {
    if (bookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('خطأ: معرف الكتاب غير صالح'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            const Text('حذف الصفحة'),
          ],
        ),
        content: Text('هل أنت متأكد أنك تريد حذف هذه الصفحة من "$bookName"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<PageBookmarkCubit>()
                  .removeBookmark(bookId, pageNumber);
              Navigator.pop(ctx);
              AppSnackBar.showSuccess(context, 'تم حذف الصفحة بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
