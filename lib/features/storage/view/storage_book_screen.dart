import 'dart:async';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_state.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  .padAll(5.5),
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BookMarkStatus.error) {
            return const Center(
              child: Text('خطأ في تحميل الكتب'),
            );
          }

          if (state.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Assets.newicons.bookmark.image(
                      width: 64,
                      height: 64,
                    ),
                  )
                      .animate()
                      .fade(duration: 600.ms)
                      .slideY(begin: 0.2, duration: 600.ms),
                  const SizedBox(height: 20),
                  Text(
                    'لا يوجد كتاب محفوظ!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6),
                    ),
                  )
                      .animate()
                      .fade(duration: 800.ms)
                      .slideY(begin: 0.3, duration: 800.ms),
                ],
              ),
            );
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
                    return Container(
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Assets.newicons.bookmarkfull
                                    .image(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3))
                                    .padAll(4)),
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
                                  Assets.newicons.timeCheck
                                      .image(
                                          color: Theme.of(context).primaryColor,
                                          width: 14,
                                          height: 14)
                                      .padAll(4),
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
                                icon: Assets.newicons.trashXmark.image(
                                    color: Colors.red.shade600,
                                    width: 23,
                                    height: 23),
                                onPressed: () async {
                                  await AppDialog.showConfirmDialog(
                                    context,
                                    title: 'الکتاب',
                                    content:
                                        bookmark['book_name'] ?? 'بدون عنوان',
                                    onPress: () {
                                      BookmarkCubit.instance.removeBookmark(
                                          bookmark['book_id']?.toString() ??
                                              '');

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('تم حذف الكتاب بنجاح'),
                                          backgroundColor:
                                              Colors.green.withOpacity(0.4),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            onTap: () {
                              // می‌تونی نویگیشن بذاری اینجا
                            },
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
