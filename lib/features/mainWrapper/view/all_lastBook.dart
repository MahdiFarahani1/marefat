import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/books/bloc/download/download_cubit.dart';
import 'package:bookapp/features/books/bloc/download/download_state.dart';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/features/mainWrapper/bloc/slider/slider_cubit.dart';
import 'package:bookapp/features/mainWrapper/model/slider_model.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/func/downloaded_book.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/utils/images_network.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AllLastBooks extends StatelessWidget {
  const AllLastBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Back.btn(context),
        title: Text("الكتب الأخيرة",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
        centerTitle: true,
        elevation: 1,
        flexibleSpace: Container(),
      ),
      body: BlocBuilder<SliderCubit, SliderState>(
        builder: (context, state) {
          final status = state.statusSlider;

          if (status is SliderLoading) {
            return Center(child: CustomLoading.fadingCircle(context));
          } else if (status is SliderLoaded) {
            final books = status.books;
            final downloadCubit = context.read<DownloadCubit>();
            for (var book in books) {
              downloadCubit.checkIfDownloaded(book.id.toString(), book.pdf!);
              downloadCubit.checkIfBookDownloaded(book.id.toString());
            }

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BlocBuilder<DownloadCubit, Map<String, DownloadState>>(
                  builder: (context, downloadStates) {
                    final book = books[index];
                    final downloadState =
                        downloadStates[book.id.toString()] ?? DownloadState();

                    return GestureDetector(
                      onTap: () {
                        if (downloadState.isDownloadedBook) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => ContentPage(
                                  bookId: book.id.toString(),
                                  bookName: book.title,
                                  scrollPosetion: 0.0),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
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
                                imageurl: book.photoUrl,
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
                                    book.writer!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Assets.newicons.filePdf.image(
                                          width: 22,
                                          height: 22,
                                          color: context
                                              .read<SettingsCubit>()
                                              .state
                                              .primry),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: downloadState.isDownloadingPdf
                                            ? null
                                            : () => handleDownloadOrOpen(
                                                    context,
                                                    downloadState,
                                                    ConstantApp.upload +
                                                        book.pdf!,
                                                    book.pdf!.split('/').last,
                                                    () {
                                                  context
                                                      .read<DownloadCubit>()
                                                      .startPdfDownload(
                                                          book.id.toString(),
                                                          ConstantApp.upload +
                                                              book.pdf!);
                                                }),
                                        child: Text(
                                          downloadState.isDownloadingPdf
                                              ? 'جاري التحميل..'
                                              : downloadState.isDownloadedPdf
                                                  ? 'تصفح ملف PDF'
                                                  : 'تحميل pdf',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                downloadState.isDownloadingPdf
                                                    ? Colors.grey
                                                    : const Color(0xFF2196F3),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      ZoomTapAnimation(
                                        onTap: () async {
                                          if (downloadState.isDownloadedBook ==
                                              false) {
                                            handleBookDownload(
                                              context,
                                              downloadState,
                                              ConstantApp.downloadBook +
                                                  book.id.toString(),
                                              'b${book.id.toString()}.zip',
                                              () async {
                                                await context
                                                    .read<DownloadCubit>()
                                                    .startBookDownload(
                                                      book.id.toString(),
                                                      '${ConstantApp.downloadBook}${book.id}',
                                                    );

                                                DatabaseStorageHelper
                                                    .insertBookNames(
                                                        book.title, book.id);
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color:
                                                downloadState.isDownloadedBook
                                                    ? Colors.transparent
                                                    : context
                                                        .read<SettingsCubit>()
                                                        .state
                                                        .primry
                                                        .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: downloadState.isDownloadingBook
                                              ? CustomLoading.fadingCircle(
                                                  context)
                                              : downloadState.isDownloadedBook
                                                  ? Assets
                                                      .newicons.mapMarkerCheck
                                                      .image(
                                                          color: Colors.green)
                                                      .animate()
                                                      .scale(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  400))
                                                  : Assets.newicons.inboxIn
                                                      .image(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
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
                      ),
                    );
                  },
                );
              },
            );
          } else if (status is SliderError) {
            return Center(child: Text('خطا در بارگذاری: ${status.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
