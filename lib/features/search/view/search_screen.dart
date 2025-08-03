import 'package:bookapp/shared/utils/without_tag_html.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookapp/features/search/bloc/search_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:path/path.dart' as path;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();

  bool searchText = true;
  bool searchTitle = false;
  String selectedBookId = 'all';
  String selectedBookPath = 'all';

  List<Map<String, String>> books = [
    {'id': 'all', 'name': 'همه کتاب‌ها', 'path': 'all'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBooksFromDirectory();
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
          {'id': 'all', 'name': 'همه کتاب‌ها', 'path': 'all'},
        ];

        for (Directory bookDir in bookDirectories) {
          final String bookId = path.basename(bookDir.path);
          final String sqlitePath = path.join(bookDir.path, 'b$bookId.sqlite');

          final File sqliteFile = File(sqlitePath);
          if (await sqliteFile.exists()) {
            foundBooks.add({
              'id': bookId,
              'name': bookId,
              'path': sqlitePath,
            });
          }
        }

        setState(() {
          books = foundBooks;
        });
      } else {
        print('Books directory does not exist: $baseDirPath');
      }
    } catch (e) {
      print('Error loading books from directory: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.read<SettingsCubit>().state.primry;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'البحث',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                  _buildBookDropdown(primaryColor)
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
        controller: _queryController,
        decoration: InputDecoration(
          hintText: 'ابحث عن كلمة أو عبارة...',
          hintStyle: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: primaryColor,
            size: 22,
          ),
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
                      .withValues(alpha: 0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBookId,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: primaryColor, size: 24),
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                items: books.map((book) {
                  return DropdownMenuItem<String>(
                    value: book['id'],
                    child: Text(
                      book['name']!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBookId = newValue!;
                    // Find the selected book and update the path
                    final selectedBook = books.firstWhere(
                      (book) => book['id'] == newValue,
                      orElse: () =>
                          {'id': 'all', 'name': 'همه کتاب‌ها', 'path': 'all'},
                    );
                    selectedBookPath = selectedBook['path']!;
                  });
                },
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
                  context
                      .read<SearchCubit>()
                      .quickSearch(_queryController.text);
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
                  context.read<SearchCubit>().advancedSearch(
                        query: _queryController.text,
                        searchText: searchText,
                        searchTitle: searchTitle,
                        selectedBookPath: selectedBookPath,
                      );
                },
                child: const Center(
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                color: context.read<SettingsCubit>().state.primry),
            const SizedBox(height: 16),
            Text(
              'جاري البحث...',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (state is SearchError) {
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
              state.message,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is SearchSuccess) {
      if (state.results.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
              ),
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
            ],
          ),
        );
      }

      return Column(
        children: [
          // Results header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: context.read<SettingsCubit>().state.primry,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'النتائج (${state.results.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Results list
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.results.length,
            separatorBuilder: (_, __) => Divider(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final item = state.results[index];
              return Container(
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
                        'من كتاب: ${item.bookName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.read<SettingsCubit>().state.primry,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    }

    // Default empty state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
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
      ),
    );
  }
}
