import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookGroupsPage extends StatefulWidget {
  final String bookId;
  final String bookName;
  final Future<List<Map<String, dynamic>>> Function() getBookGroup;

  const BookGroupsPage(
      {super.key,
      required this.getBookGroup,
      required this.bookId,
      required this.bookName});

  @override
  State<BookGroupsPage> createState() => _BookGroupsPageState();
}

class _BookGroupsPageState extends State<BookGroupsPage> {
  List<Map<String, dynamic>> _allGroups = [];
  List<Map<String, dynamic>> _filteredGroups = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGroups(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGroups = _allGroups;
      } else {
        _filteredGroups = _allGroups
            .where((group) =>
                (group['title'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                group['page']?.toString().contains(query) == true)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'گروه‌های کتاب',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: customGradinet(context)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredGroups = _allGroups;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          if (_isSearching)
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterGroups,
                decoration: InputDecoration(
                  hintText: 'جستجو در گروه‌ها...',
                  prefixIcon: Icon(Icons.search,
                      color: context.read<SettingsCubit>().state.primry),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterGroups('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

          // Groups List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: widget.getBookGroup(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('خطا در بارگذاری گروه‌ها'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('تلاش مجدد'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.library_books_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('هیچ گروهی یافت نشد',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                _allGroups = snapshot.data!;
                if (_filteredGroups.isEmpty && _searchController.text.isEmpty) {
                  _filteredGroups = _allGroups;
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredGroups.length,
                  itemBuilder: (context, index) {
                    final group = _filteredGroups[index];
                    return _buildGroupItem(group, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem(Map<String, dynamic> group, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: context.read<SettingsCubit>().state.primry.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: context.read<SettingsCubit>().state.primry,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          group['title'] ?? 'عنوان ندارد',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'صفحه ${group['page'] ?? index + 1}',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.read<SettingsCubit>().state.primry.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: context.read<SettingsCubit>().state.primry,
            size: 16,
          ),
        ),
        onTap: () {
          double pos = double.parse(group['page']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ContentPage(
                    bookId: widget.bookId,
                    bookName: widget.bookName,
                    scrollPosetion: pos - 1.0),
              ));
        },
      ),
    );
  }
}
