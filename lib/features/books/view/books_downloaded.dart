import 'dart:typed_data';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/books/bloc/downloaded_page/downloaded_page_cubit.dart';
import 'package:bookapp/features/books/bloc/downloaded_page/downloaded_page_state.dart';
import 'package:bookapp/features/books/model/book_item_model.dart';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/error_widget.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:bookapp/shared/utils/loading.dart';

class DownloadedBooksPage extends StatefulWidget {
  const DownloadedBooksPage({super.key});

  @override
  State<DownloadedBooksPage> createState() => _DownloadedBooksPageState();
}

class _DownloadedBooksPageState extends State<DownloadedBooksPage> {
  final TextEditingController _searchController = TextEditingController();
  List<BookItem> _allBooks = [];
  List<BookItem> _filteredBooks = [];
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  void _filterBooks(String query) {
    final filtered = _allBooks.where((book) {
      final title = book.title.toLowerCase();
      final author = book.author.toLowerCase();
      final searchLower = query.toLowerCase();
      return title.contains(searchLower) || author.contains(searchLower);
    }).toList();

    setState(() {
      _filteredBooks = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DownloadedBooksCubit()..loadDownloadedBooks(),
      child: Scaffold(
        appBar:
            CustomAppbar.littleAppBar(context, title: 'الكتب التي تم تنزيلها'),
        body: BlocBuilder<DownloadedBooksCubit, DownloadedBooksState>(
          builder: (context, state) {
            if (state is DownloadedBooksLoading) {
              return Center(child: CustomLoading.fadingCircle(context));
            }

            if (state is DownloadedBooksError) {
              return Center(
                child: ApiErrorWidget(
                  onRetry: () {
                    context.read<DownloadedBooksCubit>().loadDownloadedBooks();
                  },
                ),
              );
            }

            if (state is DownloadedBooksLoaded) {
              if (_allBooks.isEmpty) {
                _allBooks = state.books;
                _filteredBooks = _allBooks;
              }

              return Column(
                children: [
                  // 🔍 سرچ بار
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterBooks,
                      decoration: InputDecoration(
                        hintText: 'البحث في العنوان أو المؤلف...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Assets.newicons.search
                            .image(
                                width: 20,
                                height: 20,
                                color: Theme.of(context).primaryColor)
                            .padAll(12),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                  ),

                  // 📚 لیست کتاب‌ها
                  Expanded(
                    child: _filteredBooks.isEmpty
                        ? const Center(
                            child: Text(
                              'لم يتم العثور على كتاب بهذه المواصفات',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredBooks.length,
                            itemBuilder: (context, index) {
                              final book = _filteredBooks[index];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) => ContentPage(
                                          bookId: book.id,
                                          bookName: book.title,
                                          scrollPosetion: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        child: Image.memory(
                                          Uint8List.fromList(book.imageData),
                                          width: 100,
                                          height: 140,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                book.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Assets.newicons.userWriter
                                                      .image(
                                                          width: 20,
                                                          height: 20,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                  EsaySize.gap(6),
                                                  Text(
                                                    '${book.author}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Assets.newicons.angleSmallLeft
                                              .image(
                                                  width: 23,
                                                  height: 23,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
