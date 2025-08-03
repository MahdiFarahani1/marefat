import 'dart:async';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_state.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:flutter/material.dart';
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
                BookmarkCubit.instance.loadBookmarks();
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
          flexibleSpace: Container(),
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
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: context
                                        .read<SettingsCubit>()
                                        .state
                                        .primry
                                        .withOpacity(0.3),
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
                                    onDiss: () {},
                                    context: context,
                                    title: 'الکتاب',
                                    message:
                                        bookmark['book_name'] ?? 'بدون عنوان',
                                    onConfirmed: () {
                                      BookmarkCubit.instance.removeBookmark(
                                          bookmark['book_id']?.toString() ??
                                              '');

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'کتاب با موفقیت حذف شد'),
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
