import 'dart:convert';

import 'package:bookapp/features/content_books/bloc/cubit/content_cubit.dart';
import 'package:bookapp/features/content_books/bloc/cubit/content_state.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  InAppWebViewController? webViewController;
  final bool vertical = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContentCubit(bookId: widget.bookId, repository: BookDatabaseHelper()),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.bookName)),
        body: SizedBox(
          // width: verticalScroll ? Get.width - 40 : Get.width,
          width: EsaySize.width(context),
          height: EsaySize.height(context),
          child: BlocBuilder<ContentCubit, ContentState>(
            builder: (context, state) {
              return InAppWebView(
                key: ValueKey(state.htmlContent),
                initialSettings: InAppWebViewSettings(
                  useShouldInterceptRequest: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  useShouldOverrideUrlLoading: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  supportZoom: false,
                  horizontalScrollBarEnabled: false,
                  verticalScrollBarEnabled: false,
                  pageZoom: 1,
                  maximumZoomScale: 1,
                  minimumZoomScale: 1,
                  useOnLoadResource: true,
                ),
                initialData: InAppWebViewInitialData(
                  data: state.htmlContent,
                  mimeType: "text/html",
                  encoding: "utf-8",
                ),
                onWebViewCreated: (controller) async {
                  webViewController = controller;

                  await controller.evaluateJavascript(
                      source:
                          "window.flutter_inappwebview.callHandler('onSearchPositionChanged', 3);");
                },
                shouldInterceptRequest: (controller, request) async {
                  String url = request.url.toString();
                  print("Intercepted URL: $url");

                  if (url.startsWith("asset://")) {
                    String assetFileName = url.replaceFirst("asset://", "");

                    try {
                      ByteData assetData =
                          await rootBundle.load("assets/$assetFileName");
                      Uint8List bytes = assetData.buffer.asUint8List();
                      String contentType = "text/plain";

                      if (assetFileName.endsWith(".css")) {
                        contentType = "text/css";
                      } else if (assetFileName.endsWith(".gif")) {
                        contentType = "image/gif";
                      }

                      return WebResourceResponse(
                        data: bytes,
                        statusCode: 200,
                        reasonPhrase: "OK",
                        contentType: contentType,
                        headers: {"Access-Control-Allow-Origin": "*"},
                      );
                    } catch (e) {
                      print("Error loading asset: $e");
                    }
                  }

                  return null;
                },
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(source: '''
                                                                document.documentElement.style.scrollbarWidth = 'none';
                                                                document.body.style.msOverflowStyle = 'none';
                                                                document.documentElement.style.overflow = 'auto';
                                                                document.body.style.overflow = 'auto';
                              
                                                                var style = document.createElement('style');
                                                                style.innerHTML = '::-webkit-scrollbar { display: none; }';
                                                                document.head.appendChild(style);
                                                              ''');

                  final bgColor = Theme.of(context).colorScheme.surface;
                  final hexColor =
                      '#${bgColor.value.toRadixString(16).substring(2)}';

                  await controller.evaluateJavascript(
                      source:
                          "document.body.style.backgroundColor = '$hexColor';");
                  final jsonData = jsonEncode(
                    state.pages.map((item) {
                      final originalText = item['_text'] ?? '';
                      //    var processedText = applyTextReplacements(originalText);

                      // Highlight the searchWord if it's not empty
                      // if (searchWord.isNotEmpty) {
                      //   final regex = RegExp(RegExp.escape(searchWord),
                      //       caseSensitive: false);
                      //   processedText =
                      //       processedText.replaceAllMapped(regex, (match) {
                      //     return '<span class="highlight">${match[0]}</span>';
                      //   });
                      // }

                      //   return processedText;
                    }).toList(),
                  );

                  await controller.evaluateJavascript(source: '''
                                                                (function() {
                                                                  var data = $jsonData;
                                                                  for (var i = 0; i < data.length; i++) {
                                                                    var el = document.getElementById("page___" + i);
                                                                    if (el) el.innerHTML = data[i];
                                                                  }
                                                                })();
                                                              ''');

                  controller.addJavaScriptHandler(
                    handlerName: 'CommentEvent',
                    callback: (args) async {
                      int pageNumber = args[0] + 1;

                      // ModalComment.show(
                      //   context,
                      //   updateMode: false,
                      //   id: pageNumber,
                      //   idPage: pageNumber,
                      //   idBook: bookId,
                      //   bookname: bookName,
                      // );
                    },
                  );

                  controller.addJavaScriptHandler(
                    handlerName: 'onSearchPositionChanged',
                    callback: (args) {
                      print("======2>>" + args.toString());
                      // if (args.length == 2) {
                      //   searchContentController.currentMatchIndex.value =
                      //       args[0];
                      //   searchContentController.totalMatchCount.value = args[1];
                      // }
                    },
                  );

                  controller.addJavaScriptHandler(
                    handlerName: 'bookmarkToggled',
                    callback: (args) async {
                      var pageNumber = args[0];
                      // var bookmarkData = {
                      //   'bookId': bookId,
                      //   'pageNumber': pageNumber,
                      //   'bookName': bookName,
                      // };

                      // String? savedBookmarks =
                      //     Constants.localStorage.read('bookmark');
                      List<dynamic> bookmarks = [];
                      // if (savedBookmarks != null) {
                      //   var decodedData = jsonDecode(savedBookmarks);

                      //   if (decodedData is List) {
                      //     bookmarks = decodedData;
                      //   } else if (decodedData is Map) {
                      //     bookmarks = [decodedData];
                      //   }
                      // }

                      var existingBookmarkIndex = bookmarks.indexWhere(
                          (bookmark) =>
                              bookmark['bookId'] == 5 &&
                              bookmark['pageNumber'] == pageNumber);

                      // if (existingBookmarkIndex != -1) {
                      //   bookmarks.removeAt(existingBookmarkIndex);
                      //   print('Bookmark removed');
                      // } else {
                      //   bookmarks.add(bookmarkData);
                      //   print('Bookmark saved: $bookmarkData');
                      // }

                      // Constants.localStorage
                      //     .write('bookmark', jsonEncode(bookmarks));
                    },
                  );

                  // Scroll SPY
                  if (vertical) {
                    await controller.evaluateJavascript(source: '''
                                                                    if (${state.scrollPosition} != 0) {
                                                                      var y = getOffset(document.getElementById('book-mark_${state.scrollPosition == 0 ? state.scrollPosition : state.scrollPosition.floor() - 1}')).top;
                                                                      window.scrollTo(0, y);
                                                                    };
                                                                    ''');
                    controller.evaluateJavascript(source: r"""
                                                                              $(window).on('scroll', function() {
                                                                          var currentTop = $(window).scrollTop();
                                                                          var elems = $('.BookPage-vertical');
                                                                          elems.each(function(index) {
                                                                              var elemTop = $(this).offset().top;
                                                                              var elemBottom = elemTop + $(this).height();
                                                                              if (currentTop >= elemTop && currentTop <= elemBottom) {
                                                                                  var page = $(this).attr('data-page');
                                                                                  window.flutter_inappwebview.callHandler('scrollSpy', page);
                                                                              }
                                                                          });
                                                                              });
                                                                            """);
                    await controller.evaluateJavascript(source: '''
                                                        var scrollPosition = ${state.scrollPosition == 0 ? 0 : state.scrollPosition.floor()};
                                                        var element = document.getElementById('book-mark_' + scrollPosition);
                                                        if (element != null) {
                                                          var y = getOffset(element).top;
                                                          window.scrollTo(0, y);
                                                        }
                                                      ''');
                  } else {
                    controller.evaluateJavascript(source: r"""
                                                                  $(document).ready(function () {
                                                                    var container = $('.book-container-horizontal');
                              
                                                                    container.on('scroll', function () {
                                                                      var containerScrollLeft = container.scrollLeft();
                                                                      var containerWidth = container.width();
                              
                                                                      $('.BookPage-horizontal').each(function () {
                                                                        var $page = $(this);
                                                                        var pageLeft = $page.position().left;
                                                                        var pageWidth = $page.outerWidth();
                                                                        var pageRight = pageLeft + pageWidth;
                              
                                                                        // Check if page is in view
                                                                        if (
                                                                          pageLeft < containerWidth &&
                                                                          pageRight > 0
                                                                        ) {
                                                                          var page = $page.attr('data-page');
                                                                          window.flutter_inappwebview.callHandler('scrollSpy', page);
                                                                          return false; // break after finding the first visible page
                                                                        }
                                                                      });
                                                                    });
                                                                  });
                                                                              """);
                    await controller.evaluateJavascript(source: '''
                                                                    var scrollPosition = ${state.scrollPosition == 0 ? 0 : state.scrollPosition.floor()};
                                                                    var element = document.getElementById('book-mark_' + scrollPosition);
                                                                    var container = document.querySelector('.book-container-horizontal');
                              
                                                                    if (element && container) {
                                                                      var elementRect = element.getBoundingClientRect();
                                                                      var containerRect = container.getBoundingClientRect();
                                                                      var scrollX = elementRect.left - containerRect.left + container.scrollLeft;
                                                                      container.scrollTo({ left: scrollX, behavior: 'smooth' });
                                                                    }
                                                                  ''');
                  }
                  controller.addJavaScriptHandler(
                    handlerName: 'scrollSpy',
                    callback: (arguments) {
                      if (arguments.isNotEmpty &&
                          double.tryParse(arguments[0]) != null) {
                        double page = double.parse(arguments[0]);
                        if (state.currentPage != page && page > 0) {
                          state.currentPage == double.parse(arguments[0]);
                        }
                        debugPrint("$arguments <<<<=======SPY");
                      } else {
                        debugPrint("Invalid arguments: $arguments");
                      }
                    },
                  );
                  controller.evaluateJavascript(source: r'''
                                                            $(function () {
                                                                $('[data-toggle="tooltip"]').tooltip({
                                                                  placement: 'bottom',
                                                                  html: true
                                                                });
                                                              });
                                                              ''');
                },
                onLoadStart: (controller, url) async {},
              );
            },
          ),
        ),
      ),
    );
  }
}
