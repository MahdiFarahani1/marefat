import 'package:html/parser.dart' as html_parser;

String extractPlainText(String htmlText) {
  final document = html_parser.parse(htmlText);
  return document.body?.text.trim() ?? '';
}
