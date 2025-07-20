import 'package:bookapp/config/theme/theme.dart';
import 'package:bookapp/features/articles/bloc/cubit/article_cubit_cubit.dart';
import 'package:bookapp/features/books/bloc/book/book_cubit.dart';
import 'package:bookapp/features/books/bloc/download/download_cubit.dart';
import 'package:bookapp/features/books/repositoreis/book_repository.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/mainWrapper/bloc/navigation_cubit.dart';
import 'package:bookapp/features/onbording/onbording_view.dart';
import 'package:bookapp/features/photo_gallery/bloc/gallery_cubit.dart';
import 'package:bookapp/features/questions/bloc/questionItems/question_cubit.dart';
import 'package:bookapp/features/questions/bloc/questionSearch/question_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DownloadCubit(),
        ),
        BlocProvider(
          create: (context) => BookmarkCubit(),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => GalleryCubit(),
        ),
        BlocProvider(
          create: (context) => ArticleCubit(),
        ),
        BlocProvider(
          create: (context) => QuestionCubit(),
        ),
        BlocProvider(
          create: (_) => QuestionSearchCubit(),
        ),
        BlocProvider(
          create: (context) => BookCubit(BookRepository()),
        ),
        RepositoryProvider<BookRepository>(
          create: (_) => BookRepository(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('fa'),
        supportedLocales: const [
          Locale('fa'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: OnboardingPage(),
      ),
    );
  }
}
