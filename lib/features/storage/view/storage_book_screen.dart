import 'dart:async';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_state.dart';
import 'package:bookapp/features/storage/widgets/empty_list.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:bookapp/shared/ui_helper/snackbar_common.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';

class StorageBookScreen extends StatefulWidget {
  final bool isBack;
  const StorageBookScreen({super.key, required this.isBack});

  @override
  State<StorageBookScreen> createState() => _StorageBookScreenState();
}

class _StorageBookScreenState extends State<StorageBookScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    BookmarkCubit.instance.loadBookmarks();

    // Auto-refresh every 2 seconds for real-time updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        BookmarkCubit.instance.loadBookmarks();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BookmarkCubit.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "الكتب المحفوظة",
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          leading: widget.isBack ? Back.btn(context) : const SizedBox.shrink(),
          actions: [
            IconButton(
              onPressed: () {
                BookmarkCubit.instance.loadBookmarks();
              },
              icon: Assets.newicons.messageCircleRefresh
                  .image(
                    color: Theme.of(context).primaryColor,
                  )
                  .padAll(8),
              tooltip: 'بروزرسانی',
            ),
          ],
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(),
        ),
        body: BlocBuilder<BookmarkCubit, BookMarkState>(
            builder: (context, state) {
          if (state.status == BookMarkStatus.loading) {
            return Center(child: CustomLoading.fadingCircle(context));
          }

          if (state.status == BookMarkStatus.error) {
            return const Center(
              child: Text('خطأ في تحميل الكتب'),
            );
          }

          if (state.bookmarks.isEmpty) {
            return EmptyList.show(context,
                imagePath: Assets.newicons.bookmark.path,
                message: 'لَم يتم حفظ أي كتاب');
          }

          if (state.status == BookMarkStatus.success) {
            return RefreshIndicator(
                onRefresh: () async {
                  await BookmarkCubit.instance.loadBookmarks();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = state.bookmarks[index];
                    return ZoomTapAnimation(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => ContentPage(
                              bookId: bookmark['book_id'].toString(),
                              bookName: bookmark['book_name'],
                              scrollPosetion: 0.0,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.25),
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.01),
                                ],
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Assets.newicons.circleBookmark.image(
                                      width: 25,
                                      height: 25,
                                      color: Theme.of(context).primaryColor)),
                              title: Text(
                                bookmark['book_name'] ?? 'بدون عنوان',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Assets.newicons.trashXmark.image(
                                      color: Colors.red.shade600,
                                      width: 23,
                                      height: 23),
                                  onPressed: () async {
                                    await AppDialog.showConfirmDialog(
                                      context,
                                      title: 'تأكيد الحذف',
                                      content:
                                          'هل أنت متأكد من رغبتك في حذف الكتاب «${bookmark['book_name']}»؟' ??
                                              'بدون عنوان',
                                      onPress: () async {
                                        await BookmarkCubit.instance
                                            .removeBookmark(bookmark['book_id']
                                                    ?.toString() ??
                                                '');
                                        AppSnackBar.showSuccess(
                                            context, 'تم الحذف بنجاح');
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ));
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
