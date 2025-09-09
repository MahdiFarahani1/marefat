String removeHtmlTags(String htmlText) {
  // این الگو همه‌ی تگ‌های <...> رو حذف می‌کنه
  final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(exp, '');
}
