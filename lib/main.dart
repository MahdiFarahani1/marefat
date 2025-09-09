import 'package:bookapp/config/firebase/firebase_setup_android.dart';
import 'package:bookapp/config/splash/splash.dart';
import 'package:bookapp/features/articles/bloc/cubit/article_cubit_cubit.dart';
import 'package:bookapp/features/articles/bloc/fontsize/cubit/article_cubit.dart';
import 'package:bookapp/features/books/bloc/book/book_cubit.dart';
import 'package:bookapp/features/books/bloc/download/download_cubit.dart';
import 'package:bookapp/features/books/repositoreis/book_repository.dart';
import 'package:bookapp/features/content_books/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/mainWrapper/bloc/navbar/navigation_cubit.dart';
import 'package:bookapp/features/mainWrapper/bloc/slider/slider_cubit.dart';
import 'package:bookapp/features/onbording/onbording_view.dart';
import 'package:bookapp/features/photo_gallery/bloc/gallery_cubit.dart';
import 'package:bookapp/features/questions/bloc/questionItems/question_cubit.dart';
import 'package:bookapp/features/questions/bloc/questionSearch/question_search_cubit.dart';
import 'package:bookapp/features/reading_progress/bloc/cubit/readingbook_cubit.dart';
import 'package:bookapp/features/search/bloc/search_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_cubit.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    await firebaseSetupAndroid();
  }

  await GetStorage.init();

  // Initialize SQLite FFI on desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else {
    databaseFactory = sqflite.databaseFactory;
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const MyApp(),
  );
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
          create: (context) => ReadingbookCubit(),
        ),
        BlocProvider(
          create: (_) => SearchCubit(),
        ),
        BlocProvider(
          create: (context) => SliderCubit(),
        ),
        BlocProvider(
          create: (context) => BookmarkCubit(),
        ),
        BlocProvider(
          create: (_) => PageBookmarkCubit(GetStorage())..loadBookmarks(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
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
        BlocProvider(create: (context) => ArticleFontSizeCubit()),
        BlocProvider(
          create: (context) => BookCubit(BookRepository()),
        ),
        RepositoryProvider<BookRepository>(
          create: (_) => BookRepository(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          GetStorage box = GetStorage();
          final onBordingShow = box.read('onbording') ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale('ar'),
            supportedLocales: const [
              Locale('ar'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: settingsState.theme,
            //darkTheme: AppTheme.darkTheme,
            home: onBordingShow ? SplashScreen() : const OnboardingPage(),
          );
        },
      ),
    );
  }
}
