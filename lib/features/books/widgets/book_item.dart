import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/books/bloc/download/download_cubit.dart';
import 'package:bookapp/features/books/bloc/download/download_state.dart';
import 'package:bookapp/features/books/model/model_books.dart';
import 'package:bookapp/features/books/repositoreis/book_repository.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/func/downloaded_book.dart';
import 'package:bookapp/shared/utils/images_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BookItemTile extends StatelessWidget {
  final BookModel book;
  final BookRepository repo;

  const BookItemTile({
    required this.book,
    required this.repo,
    super.key,
  });

  // Future<bool> _requestStoragePermission() async {
  //   final status = await Permission.storage.status;
  //   if (status.isGranted) return true;

  //   final result = await Permission.storage.request();
  //   return result.isGranted;
  // }

  @override
  Widget build(BuildContext context) {
    final imageUrl = repo.imageUrl(book.img);

    return BlocBuilder<DownloadCubit, Map<String, DownloadState>>(
      builder: (context, downloadStates) {
        final downloadState =
            downloadStates[book.id.toString()] ?? DownloadState();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ImageNetworkCommon(
                  imageurl: imageUrl,
                  width: 75,
                  height: 105,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.writer,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (book.dateTime != null)
                      Text(
                        'التاریخ: ${DateFormat('yyyy/MM/dd').format(DateTime.fromMillisecondsSinceEpoch(book.dateTime! * 1000))}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Assets.images.document.image(width: 22, height: 22),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: downloadState.isDownloadingPdf
                              ? null
                              : () => handleDownloadOrOpen(
                                      context,
                                      downloadState,
                                      ConstantApp.upload + book.pdf!,
                                      book.pdf!.split('/').last, () {
                                    context
                                        .read<DownloadCubit>()
                                        .startPdfDownload(book.id.toString(),
                                            ConstantApp.upload + book.pdf!);
                                  }),
                          child: Text(
                            downloadState.isDownloadingPdf
                                ? 'جاري التحميل..'
                                : downloadState.isDownloadedPdf
                                    ? 'تصفح ملف PDF'
                                    : 'تحميل pdf',
                            style: TextStyle(
                              fontSize: 13,
                              color: downloadState.isDownloadingPdf
                                  ? Colors.grey
                                  : const Color(0xFF2196F3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        ZoomTapAnimation(
                          onTap: () async {
                            if (downloadState.isDownloadedBook == false) {
                              handleBookDownload(
                                context,
                                downloadState,
                                ConstantApp.downloadBook + book.id.toString(),
                                'b${book.id.toString()}.zip',
                                () async {
                                  await context
                                      .read<DownloadCubit>()
                                      .startBookDownload(
                                        book.id.toString(),
                                        '${ConstantApp.downloadBook}${book.id}',
                                      );
                                },
                              );
                            }
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: downloadState.isDownloadedBook
                                  ? Colors.transparent
                                  : context
                                      .read<SettingsCubit>()
                                      .state
                                      .primry
                                      .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(8),
                            child: downloadState.isDownloadingBook
                                ? CircularProgressIndicator(
                                    color: Colors.blue,
                                    backgroundColor: Colors.grey[300],
                                    strokeWidth: 2,
                                  )
                                : downloadState.isDownloadedBook
                                    ? Assets.icons.check
                                        .image(color: Colors.green)
                                        .animate()
                                        .scale(
                                            duration:
                                                Duration(milliseconds: 400))
                                    : Assets.icons.downBook
                                        .image(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    if (downloadState.isDownloadingPdf)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(
                          value: downloadState.progressPdf,
                          minHeight: 6,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class BookDownloadList extends StatelessWidget {
  final List<BookModel> books;
  const BookDownloadList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<BookRepository>();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookItemTile(
          key: ValueKey(book.pdf),
          book: book,
          repo: repo,
        );
      },
    );
  }
}
