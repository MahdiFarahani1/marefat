import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isAdvancedSearch = false;
  bool isTextSelected = true;
  bool isTitleSelected = true;
  String selectedCategory = 'اختيار';

  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = [
    'اختيار',
    'الفقه',
    'التفسير',
    'الحديث',
    'العقيدة',
    'السيرة',
    'التاريخ',
    'الأدب',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.read<SettingsCubit>().state.primry;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    _buildSearchBar(primaryColor),
                    const SizedBox(height: 20),
                    _buildSearchTypeToggle(primaryColor),
                    const SizedBox(height: 20),
                    if (isAdvancedSearch) ...[
                      _buildAdvancedOptions(primaryColor),
                      const SizedBox(height: 20),
                    ],
                    _buildSearchButton(primaryColor),
                    const SizedBox(height: 25),
                    _buildResultsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTypeToggle(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isAdvancedSearch = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isAdvancedSearch ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  'بحث متقدم',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isAdvancedSearch
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isAdvancedSearch = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !isAdvancedSearch ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  'بحث بسيط',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !isAdvancedSearch
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildSearchBar(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن كتاب أو مؤلف...',
          hintStyle: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: primaryColor,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: -0.2);
  }

  Widget _buildAdvancedOptions(Color primaryColor) {
    return Column(
      children: [
        // Info banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.blue, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'يتطلب البحث 3 أحرف أو أكثر',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.2),

        const SizedBox(height: 16),

        // Search options
        Row(
          children: [
            Expanded(
              child: _buildCheckboxOption(
                  'النص',
                  isTextSelected,
                  (value) => setState(() => isTextSelected = value!),
                  primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCheckboxOption(
                  'العنوان',
                  isTitleSelected,
                  (value) => setState(() => isTitleSelected = value!),
                  primaryColor),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.2),

        const SizedBox(height: 16),

        // Category dropdown
        _buildCategoryDropdown(primaryColor),
      ],
    );
  }

  Widget _buildCheckboxOption(
      String title, bool value, Function(bool?) onChanged, Color primaryColor) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value
              ? primaryColor.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? primaryColor
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.15),
            width: value ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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

  Widget _buildCategoryDropdown(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: primaryColor, size: 20),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.2);
  }

  Widget _buildSearchButton(Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _performSearch,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_rounded, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'بحث',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 600.ms)
        .scale(begin: Offset(0.9, 0.9));
  }

  Widget _buildResultsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.search_rounded,
              size: 32,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 700.ms)
              .scale(begin: Offset(0.8, 0.8)),
          const SizedBox(height: 12),
          Text(
            'عدد النتائج: 0',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
          const SizedBox(height: 6),
          Text(
            'ابدأ البحث للعثور على النتائج',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ).animate().fadeIn(duration: 700.ms, delay: 900.ms),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 700.ms).slideY(begin: 0.2);
  }

  void _performSearch() {
    // Add search logic here
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Perform search based on selected options
      print('Searching for: $query');
      print('Advanced search: $isAdvancedSearch');
      print('Search in text: $isTextSelected');
      print('Search in title: $isTitleSelected');
      print('Category: $selectedCategory');

      final primaryColor = context.read<SettingsCubit>().state.primry;

      // Show loading or results
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('البحث عن: $query'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
