import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/ui_helper/snackbar_common.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:bookapp/shared/utils/without_tag_html.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookapp/features/search/bloc/search_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:path/path.dart' as path;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();

  bool searchText = true;
  bool searchTitle = false;
  String selectedBookId = '0';
  String selectedBookPath = 'all';
  bool showDebugInfo = false; // Toggle for showing technical error details

  List<Map<String, String>> books = [
    {'book_id': '0', 'book_name': 'جميع الكتب', 'path': 'all'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBooksFromDirectory();
  }

  @override
  void dispose() {
    _queryController.dispose();
    // Close database connections when page is disposed
    context.read<SearchCubit>().closeDatabases();
    super.dispose();
  }

  // Clear search results
  void _clearSearch() {
    context.read<SearchCubit>().emit(SearchInitial());
  }

  // Show search results list
  Widget _buildSearchResultsList(List<SearchResultItem> results) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      itemBuilder: (context, index) {
        final item = results[index];

        return ZoomTapAnimation(
          onTap: () async {
            String bookName = await DatabaseStorageHelper.getBookNameWithId(
                int.parse(item.bookId));
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => ContentPage(
                  bookId: item.bookId,
                  bookName: bookName,
                  scrollPosetion: double.parse(item.pageNumber) - 1,
                  sw: _queryController.text,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  extractPlainText(item.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context
                            .read<SettingsCubit>()
                            .state
                            .primry
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FutureBuilder<String>(
                          future: DatabaseStorageHelper.getBookNameWithId(
                              int.parse(item.bookId)),
                          builder: (context, snapshot) {
                            return Text(
                              'من كتاب: ${snapshot.data}',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    context.read<SettingsCubit>().state.primry,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                    ),
                    EsaySize.gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context
                            .read<SettingsCubit>()
                            .state
                            .primry
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'الصفحة: ${item.pageNumber}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show search results header
  Widget _buildSearchResultsHeader(int resultCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Assets.newicons.search.image(
              color: Theme.of(context).primaryColor, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            'النتائج ($resultCount)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _clearSearch,
            icon: Icon(
              Icons.clear,
              size: 18,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
            label: Text(
              'مسح',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _resetSearch,
            icon: Icon(
              Icons.refresh,
              size: 18,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
            label: Text(
              'إعادة تعيين',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show no results found message
  Widget _buildNoResultsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب كلمات مختلفة أو تحقق من الإعدادات',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _resetSearch,
            icon: Icon(Icons.refresh),
            label: Text('إعادة تعيين البحث'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ).padAll(20),
    );
  }

  // Show search in progress message
  Widget _buildSearchInProgressMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoading.fadingCircle(context),
          const SizedBox(height: 16),
          Text(
            'جاري البحث...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى الانتظار حتى يكتمل البحث',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).padAll(20),
    );
  }

  // Show short query message
  Widget _buildShortQueryMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.blue.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'أدخل نص البحث',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اكتب 3 أحرف على الأقل للبدء في البحث',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).padAll(20),
    );
  }

  // Show no books found message
  Widget _buildNoBooksMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.orange.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لم يتم العثور على كتب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تأكد من وجود ملفات الكتب في المسار:\n/storage/emulated/0/Download/Books/tmp/',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              _loadBooksFromDirectory();
            },
            icon: Icon(Icons.refresh),
            label: Text('إعادة تحميل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ).padAll(20),
    );
  }

  // Check if books directory exists
  Future<bool> _checkBooksDirectory() async {
    const String baseDirPath = '/storage/emulated/0/Download/Books/tmp';
    final Directory baseDirectory = Directory(baseDirPath);
    return await baseDirectory.exists();
  }

  // Handle database connection issues
  void _handleDatabaseIssue() {
    AppSnackBar.showError(context,
        'مشكلة في الاتصال بقاعدة البيانات. يرجى إعادة تشغيل التطبيق أو التحقق من الأذونات.');
  }

  // Reset search form
  void _resetSearch() {
    _queryController.clear();
    setState(() {
      searchText = true;
      searchTitle = false;
      selectedBookId = '0';
      selectedBookPath = 'all';
    });
    _clearSearch();
  }

  Future<void> _loadBooksFromDirectory() async {
    try {
      const String baseDirPath = '/storage/emulated/0/Download/Books/tmp';
      final Directory baseDirectory = Directory(baseDirPath);

      if (await baseDirectory.exists()) {
        final List<FileSystemEntity> entities =
            await baseDirectory.list().toList();

        final List<Directory> bookDirectories =
            entities.whereType<Directory>().toList();

        List<Map<String, String>> foundBooks = [
          {'book_id': '0', 'book_name': 'جميع الكتب', 'path': 'all'},
        ];

        for (Directory bookDir in bookDirectories) {
          final String bookId = path.basename(bookDir.path);
          final String sqlitePath = path.join(bookDir.path, 'b$bookId.sqlite');

          final File sqliteFile = File(sqlitePath);
          if (await sqliteFile.exists()) {
            foundBooks.add({
              'book_id': bookId,
              'book_name': bookId,
              'path': sqlitePath,
            });
          }
        }

        setState(() {
          books = foundBooks;
        });

        if (foundBooks.length == 1) {
          // Only "جميع الكتب" option available
          print('No books found in directory: $baseDirPath');
        } else {
          print(
              'Found ${foundBooks.length - 1} books in directory: $baseDirPath');
        }
      } else {
        print('Books directory does not exist: $baseDirPath');
        setState(() {
          books = [
            {'book_id': '0', 'book_name': 'جميع الكتب', 'path': 'all'}
          ];
        });
      }
    } catch (e) {
      print('Error loading books from directory: $e');
      setState(() {
        books = [
          {'book_id': '0', 'book_name': 'جميع الكتب', 'path': 'all'}
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'البحث',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        flexibleSpace: Container(),
        elevation: 0,
        leading: Back.btn(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Form Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Input
                  _buildSearchInput(primaryColor)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.2),

                  const SizedBox(height: 20),

                  // Search Options
                  _buildSearchOptions(primaryColor)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.2),

                  const SizedBox(height: 20),

                  // Book Selection Dropdown
                  _buildBookDropdown(
                    primaryColor,
                  )
                      .animate()
                      .fadeIn(duration: 700.ms, delay: 400.ms)
                      .slideY(begin: 0.2),

                  const SizedBox(height: 20),

                  // Search Buttons
                  _buildSearchButtons(primaryColor)
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 600.ms)
                      .scale(begin: Offset(0.9, 0.9)),
                ],
              ),
            ),

            // Results Section
            Container(
              // نصف ارتفاع صفحه

              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return _buildSearchResults(state);
                },
              ),
            )
                .animate()
                .fadeIn(duration: 900.ms, delay: 800.ms)
                .slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {},
        controller: _queryController,
        decoration: InputDecoration(
          hintText: 'ابحث عن كلمة أو عبارة...',
          hintStyle: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 15,
          ),
          prefixIcon: Assets.newicons.search
              .image(color: primaryColor, width: 20, height: 20)
              .padAll(14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSearchOptions(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'البحث في:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCheckboxOption(
                  'النص',
                  searchText,
                  (value) => setState(() => searchText = value!),
                  primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCheckboxOption(
                  'العنوان',
                  searchTitle,
                  (value) => setState(() => searchTitle = value!),
                  primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(
      String title, bool value, Function(bool?) onChanged, Color primaryColor) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              value ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? primaryColor
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: value ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: value
                      ? primaryColor
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value
                    ? primaryColor
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookDropdown(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر الكتاب:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBookId,
                isExpanded: true,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedBookId = value;
                    final selected = books.firstWhere(
                      (b) => b['book_id'] == value,
                      orElse: () => {
                        'book_id': '0',
                        'book_name': 'جميع الكتب',
                        'path': 'all'
                      },
                    );
                    selectedBookPath = selected['path'] ?? 'all';
                  });
                },
                items: books.map((book) {
                  final idStr = book['book_id'] ?? '0';
                  if (idStr == '0') {
                    return const DropdownMenuItem<String>(
                      value: '0',
                      child: Text('جميع الكتب'),
                    );
                  }

                  final idInt = int.tryParse(idStr) ?? 0;
                  final futureName =
                      DatabaseStorageHelper.getBookNameWithId(idInt);
                  return DropdownMenuItem<String>(
                    value: idStr,
                    child: FutureBuilder<String>(
                      future: futureName,
                      builder: (context, snapshot) {
                        return Text(
                            snapshot.data ?? (book['book_name'] ?? '...'));
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButtons(Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (_queryController.text.length < 3) {
                    AppSnackBar.showError(
                        context, 'يرجى إدخال 3 أحرف على الأقل للبحث');
                  } else {
                    context
                        .read<SearchCubit>()
                        .quickSearch(_queryController.text);
                  }
                },
                child: Center(
                  child: Text(
                    'بحث سريع',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (_queryController.text.length < 3) {
                    AppSnackBar.showError(
                        context, 'يرجى إدخال 3 أحرف على الأقل للبحث');
                  } else {
                    context.read<SearchCubit>().advancedSearch(
                          query: _queryController.text,
                          searchText: searchText,
                          searchTitle: searchTitle,
                          selectedBookPath: selectedBookPath,
                        );
                  }
                },
                child: Center(
                  child: Text(
                    'بحث متقدم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(SearchState state) {
    if (state is SearchLoading) {
      return _buildSearchInProgressMessage();
    }

    if (state is SearchError) {
      String errorMessage = state.message;
      String userFriendlyMessage = 'حدث خطأ في البحث';

      // Provide more user-friendly error messages
      if (errorMessage.contains('database_closed')) {
        userFriendlyMessage =
            'مشكلة في الاتصال بقاعدة البيانات. يرجى المحاولة مرة أخرى.';
      } else if (errorMessage.contains('Permission denied')) {
        userFriendlyMessage =
            'لا يمكن الوصول إلى الملفات. يرجى التحقق من الأذونات.';
      } else if (errorMessage.contains('No such file or directory')) {
        userFriendlyMessage =
            'لم يتم العثور على ملفات الكتب. يرجى التحقق من المسار.';
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userFriendlyMessage,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Retry the last search
                if (_queryController.text.length >= 3) {
                  if (searchText || searchTitle) {
                    context.read<SearchCubit>().advancedSearch(
                          query: _queryController.text,
                          searchText: searchText,
                          searchTitle: searchTitle,
                          selectedBookPath: selectedBookPath,
                        );
                  } else {
                    context
                        .read<SearchCubit>()
                        .quickSearch(_queryController.text);
                  }
                }
              },
              icon: Icon(Icons.refresh),
              label: Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  showDebugInfo = !showDebugInfo;
                });
              },
              child: Text(
                showDebugInfo
                    ? 'إخفاء التفاصيل التقنية'
                    : 'عرض التفاصيل التقنية',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
            if (showDebugInfo) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل تقنية:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (state is SearchSuccess) {
      if (state.results.isEmpty) {
        return _buildNoResultsMessage();
      }

      return Column(
        children: [
          // Results header
          _buildSearchResultsHeader(state.results.length),
          // Results list
          _buildSearchResultsList(state.results),
        ],
      );
    }

    // Default empty state
    if (books.length == 1) {
      // No books found
      return _buildNoBooksMessage();
    }

    if (_queryController.text.isEmpty || _queryController.text.length < 3) {
      // Query is too short
      return _buildShortQueryMessage();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EsaySize.gap(8),
          Assets.newicons.search
              .image(color: Colors.grey, width: 60, height: 60),
          const SizedBox(height: 16),
          Text(
            'ابدأ البحث',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اكتب كلمة أو عبارة للبحث عنها',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ).padAll(20),
    );
  }
}
