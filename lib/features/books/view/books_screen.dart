// books_screen.dart (clean version)

import 'package:bookapp/features/books/bloc/book/book_cubit.dart';
import 'package:bookapp/features/books/bloc/book/book_state.dart';
import 'package:bookapp/features/books/bloc/download/download_cubit.dart';
import 'package:bookapp/features/books/repositoreis/book_repository.dart';
import 'package:bookapp/features/books/widgets/book_item.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:bookapp/shared/utils/error_widget.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookCubit(context.read<BookRepository>())..loadBooks(),
      child: Scaffold(
        appBar: CustomAppbar.littleAppBar(
          context,
          title: 'الكتب',
          actions: const _DownloadAllButton(),
        ),
        body: BlocBuilder<BookCubit, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CustomLoading.fadingCircle(context));
            } else if (state is BookError) {
              return Center(
                child: ApiErrorWidget(
                  onRetry: () => context.read<BookCubit>().loadBooks(),
                ),
              );
            } else if (state is BookLoaded) {
              final downloadCubit = context.read<DownloadCubit>();
              for (var book in state.books) {
                downloadCubit.checkIfDownloaded(book.id.toString(), book.pdf!);
                downloadCubit.checkIfBookDownloaded(book.id.toString());
              }
              return BookDownloadList(books: state.books);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DownloadAllButton extends StatelessWidget {
  const _DownloadAllButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ZoomTapAnimation(
        onTap: () {
          final state = context.read<BookCubit>().state;
          if (state is BookLoaded && state.books.isNotEmpty) {
            AppDialog.showConfirmDialog(
              context,
              title: 'تحميل جميع الكتب',
              content: 'هل أنت متأكد أنك تريد تحميل جميع الكتب؟',
              onPress: () async {
                context.read<DownloadCubit>().downloadAll(state.books);
              },
            );
          }
        },
        child: Assets.icons.downloadAll.image(
          width: 30,
          height: 30,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
