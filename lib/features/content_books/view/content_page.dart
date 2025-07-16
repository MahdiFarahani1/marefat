import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../repository/dataBase.dart';

class ContentPage extends StatefulWidget {
  final String bookId;
  final String bookName;
  const ContentPage({super.key, required this.bookId, required this.bookName});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final BookDatabaseHelper dbHelper = BookDatabaseHelper();
  List<Map<String, dynamic>> pages = [];
  bool loading = true;
  String? error;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    loadBook();
  }

  Future<void> loadBook() async {
    try {
      await dbHelper.openDatabaseForBook(widget.bookId);
      final bookPages = await dbHelper.getBookPages();
      setState(() {
        pages = bookPages;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    dbHelper.close();
    super.dispose();
  }

  String buildHtml() {
    // استایل ساده برای صفحات
    final style = '''
      <style>
        body { font-family: 'Vazirmatn', sans-serif; background: #fafafa; margin: 0; padding: 0; }
        .page { padding: 24px; margin-bottom: 32px; border-radius: 12px; background: #fff; box-shadow: 0 2px 8px #0001; }
      </style>
    ''';
    final content = pages
        .asMap()
        .entries
        .map((e) =>
            '<div class="page"><h3>صفحه ${e.key + 1}</h3><div>${e.value}</div></div>')
        .join('\n');
    return '<html><head>$style</head><body>$content</body></html>';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.bookName)),
        body: Center(
            child: Text(error!, style: const TextStyle(color: Colors.red))),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookName)),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: buildHtml(),
          mimeType: 'text/html',
          encoding: 'utf-8',
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
