import 'dart:convert';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/content_books/repository/modal_comment.dart';
import 'package:bookapp/features/content_books/utils/reading_book_func.dart';
import 'package:bookapp/features/content_books/view/groups_page.dart';
import 'package:bookapp/features/content_books/widgets/settings_dialog.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_cubit.dart';
import 'package:bookapp/features/storage/bloc/bookmark/bookmark_state.dart';
import 'package:bookapp/features/content_books/bloc/content/content_cubit.dart';
import 'package:bookapp/features/content_books/bloc/content/content_state.dart';
import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_cubit.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../repository/dataBase.dart';

class ContentPage extends StatefulWidget {
  final String bookId;
  final String bookName;
  final double scrollPosetion;
  const ContentPage(
      {super.key,
      required this.bookId,
      required this.bookName,
      required this.scrollPosetion});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final BookDatabaseHelper dbHelper = BookDatabaseHelper();
  List<Map<String, dynamic>> pages = [];
  InAppWebViewController? webViewController;
  late BookmarkCubit bookmarkCubit;
  late PageBookmarkCubit pageBookmarkCubit;
  double scrollStramPos = 0.0;
  @override
  void initState() {
    super.initState();
    bookmarkCubit = BookmarkCubit.instance;
    pageBookmarkCubit = PageBookmarkCubit.instance;
    bookmarkCubit.loadInitialState(widget.bookId);
    pageBookmarkCubit.loadInitialState(
        widget.bookId, widget.scrollPosetion.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentCubit(
          context: context,
          settingsCubit: SettingsCubit(),
          bookId: widget.bookId,
          repository: BookDatabaseHelper()),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          readBookDialog(context, widget.bookName, widget.bookId);
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(),
            elevation: 4,
            title: const Text(
              'عنوان کتاب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              BlocBuilder<BookmarkCubit, BookMarkState>(
                bloc: bookmarkCubit,
                builder: (context, state) {
                  return Row(
                    children: [
                      ZoomTapAnimation(
                        onTap: () => bookmarkCubit.toggleBookmark(
                            widget.bookName, widget.bookId),
                        child: Assets.icons.bookstar.image(
                          color: state.isSaved ? Colors.yellow : Colors.white,
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  );
                },
              ),
              ZoomTapAnimation(
                onTap: () async => await TextSettingsDialog()
                    .show(context, webViewController!),
                child: Assets.icons.settingstow
                    .image(color: Colors.white, width: 28, height: 28)
                    .padAll(8),
              )
            ],
            leadingWidth: 100,
            leading: Builder(builder: (context) {
              return Row(
                children: [
                  IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        readBookDialog(context, widget.bookName, widget.bookId);
                      }),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookGroupsPage(
                            getBookGroup: dbHelper.getBookGroup,
                            bookId: widget.bookId,
                            bookName: widget.bookName,
                          ),
                        ),
                      );
                    },
                    child: Assets.icons.fiRrList
                        .image(width: 20, height: 20, color: Colors.white),
                  ),
                ],
              );
            }),
          ),
          body: SafeArea(
            child: BlocBuilder<ContentCubit, ContentState>(
              builder: (context, state) {
                if (state.status == ContentStatus.loading) {
                  return Center(
                    child: CustomLoading.fadingCircle(context),
                  );
                }
                if (state.status == ContentStatus.error) {
                  return Text('erroooooooooooor');
                }
                if (state.status == ContentStatus.success) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, stateSetting) {
                          return Flex(
                              direction: stateSetting.pageDirection ==
                                      PageDirection.vertical
                                  ? Axis.horizontal
                                  : Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.ltr,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    // width: verticalScroll ? Get.width - 40 : Get.width,
                                    width: EsaySize.width(context),

                                    child: InAppWebView(
                                      key: ValueKey(state.htmlContent),
                                      initialSettings: InAppWebViewSettings(
                                        useShouldInterceptRequest: true,
                                        javaScriptEnabled: true,
                                        domStorageEnabled: true,
                                        allowFileAccessFromFileURLs: true,
                                        allowUniversalAccessFromFileURLs: true,
                                        useShouldOverrideUrlLoading: true,
                                        javaScriptCanOpenWindowsAutomatically:
                                            true,
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
                                      shouldInterceptRequest:
                                          (controller, request) async {
                                        String url = request.url.toString();
                                        print("Intercepted URL: $url");

                                        if (url.startsWith("asset://")) {
                                          String assetFileName =
                                              url.replaceFirst("asset://", "");

                                          try {
                                            ByteData assetData =
                                                await rootBundle.load(
                                                    "assets/$assetFileName");
                                            Uint8List bytes =
                                                assetData.buffer.asUint8List();
                                            String contentType = "text/plain";

                                            if (assetFileName
                                                .endsWith(".css")) {
                                              contentType = "text/css";
                                            } else if (assetFileName
                                                .endsWith(".gif")) {
                                              contentType = "image/gif";
                                            }

                                            return WebResourceResponse(
                                              data: bytes,
                                              statusCode: 200,
                                              reasonPhrase: "OK",
                                              contentType: contentType,
                                              headers: {
                                                "Access-Control-Allow-Origin":
                                                    "*"
                                              },
                                            );
                                          } catch (e) {
                                            print("Error loading asset: $e");
                                          }
                                        }

                                        return null;
                                      },
                                      onLoadStop: (controller, url) async {
                                        await controller
                                            .evaluateJavascript(source: '''
                                                                                                          document.documentElement.style.scrollbarWidth = 'none';
                                                                                                          document.body.style.msOverflowStyle = 'none';
                                                                                                          document.documentElement.style.overflow = 'auto';
                                                                                                          document.body.style.overflow = 'auto';
                                                                        
                                                                                                          var style = document.createElement('style');
                                                                                                          style.innerHTML = '::-webkit-scrollbar { display: none; }';
                                                                                                          document.head.appendChild(style);
                                                                                                        ''');

                                        final bgColor = Theme.of(context)
                                            .colorScheme
                                            .surface;
                                        final hexColor =
                                            '#${bgColor.value.toRadixString(16).substring(2)}';

                                        await controller.evaluateJavascript(
                                            source:
                                                "document.body.style.backgroundColor = '$hexColor';");
                                        final jsonData = jsonEncode(
                                          state.pages.map((item) {
                                            final originalText =
                                                item['_text'] ?? '';
                                            var processedText =
                                                applyTextReplacements(
                                                    originalText);

                                            // Highlight the searchWord if it's not empty
                                            // if (searchWord.isNotEmpty) {
                                            //   final regex = RegExp(
                                            //       RegExp.escape(searchWord),
                                            //       caseSensitive: false);
                                            //   processedText = processedText
                                            //       .replaceAllMapped(regex, (match) {
                                            //     return '<span class="highlight">${match[0]}</span>';
                                            //   });
                                            // }

                                            return processedText;
                                          }).toList(),
                                        );

                                        await controller
                                            .evaluateJavascript(source: '''
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
                                            print(
                                                'CommentEvent======>$pageNumber');
                                            ModalComment.show(
                                              context,
                                              updateMode: false,
                                              id: pageNumber,
                                              idPage: pageNumber,
                                              idBook: int.parse(widget.bookId),
                                              bookname: widget.bookName,
                                            );
                                          },
                                        );

                                        controller.addJavaScriptHandler(
                                          handlerName:
                                              'onSearchPositionChanged',
                                          callback: (args) {
                                            print(
                                                "======2>>" + args.toString());
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
                                            var pageNumber = (args[0] + 1);
                                            pageBookmarkCubit
                                                .togglePageBookmark(
                                                    widget.bookName,
                                                    widget.bookId,
                                                    pageNumber);
                                            var bookmarkData = {
                                              'bookId': widget.bookId,
                                              'pageNumber': pageNumber,
                                              'bookName': widget.bookName,
                                            };

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

                                            // var existingBookmarkIndex =
                                            //     bookmarks.indexWhere((bookmark) =>
                                            //         bookmark['bookId'] == 5 &&
                                            //         bookmark['pageNumber'] ==
                                            //             pageNumber);

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
                                        if (stateSetting.pageDirection ==
                                            PageDirection.vertical) {
                                          await controller
                                              .evaluateJavascript(source: '''
                                                                if (${state.scrollPosition} != 0) {
                                                                  var y = getOffset(document.getElementById('book-mark_${state.scrollPosition == 0 ? state.scrollPosition : state.scrollPosition.floor() - 1}')).top;
                                                                  window.scrollTo(0, y);
                                                                };
                                                                ''');
                                          controller
                                              .evaluateJavascript(source: r"""
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
                                          await controller
                                              .evaluateJavascript(source: '''
                                                                                                  var scrollPosition = ${widget.scrollPosetion == 0 ? 0 : widget.scrollPosetion.floor()};
                                                                                                  var element = document.getElementById('book-mark_' + scrollPosition);
                                                                                                  if (element != null) {
                                                                                                    var y = getOffset(element).top;
                                                                                                    window.scrollTo(0, y);
                                                                                                  }
                                                                                                ''');
                                        } else {
                                          controller
                                              .evaluateJavascript(source: r"""
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
                                          await controller
                                              .evaluateJavascript(source: '''
                                                                                                              var scrollPosition = ${widget.scrollPosetion == 0 ? 0 : widget.scrollPosetion};
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
                                                double.tryParse(arguments[0]) !=
                                                    null) {
                                              double page =
                                                  double.parse(arguments[0]);
                                              if (state.currentPage != page &&
                                                  page > 0) {
                                                state.currentPage !=
                                                    double.parse(arguments[0]);
                                                context
                                                    .read<ContentCubit>()
                                                    .updateCurrentPage(page);
                                              }
                                              debugPrint(
                                                  "$arguments <<<<=======SPY");
                                            } else {
                                              debugPrint(
                                                  "Invalid arguments: $arguments");
                                            }
                                          },
                                        );
                                        controller
                                            .evaluateJavascript(source: r'''
                                                        $(function () {
                                                            $('[data-toggle="tooltip"]').tooltip({
                                                              placement: 'bottom',
                                                              html: true
                                                            });
                                                          });
                                                          ''');
                                      },
                                      onLoadStart: (controller, url) async {},
                                    ),
                                  ),
                                ),
                                EsaySize.gap(5),
                                SizedBox(
                                  width: stateSetting.pageDirection ==
                                          PageDirection.vertical
                                      ? 15
                                      : EsaySize.width(context),
                                  height: stateSetting.pageDirection ==
                                          PageDirection.vertical
                                      ? EsaySize.height(context)
                                      : 15,
                                  child: FlutterSlider(
                                    axis: stateSetting.pageDirection ==
                                            PageDirection.vertical
                                        ? Axis.vertical
                                        : Axis.horizontal,
                                    rtl: stateSetting.pageDirection ==
                                            PageDirection.vertical
                                        ? false
                                        : true,
                                    values: [state.currentPage],
                                    max: state.pages.length.toDouble(),
                                    min: 1,
                                    tooltip: FlutterSliderTooltip(
                                      disabled: false,
                                      direction: stateSetting.pageDirection ==
                                              PageDirection.vertical
                                          ? FlutterSliderTooltipDirection.left
                                          : FlutterSliderTooltipDirection.top,
                                      disableAnimation: false,
                                      custom: (value) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              value.toStringAsFixed(0),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    trackBar: FlutterSliderTrackBar(
                                        activeTrackBar: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                    handler: FlutterSliderHandler(
                                        child: const SizedBox()),
                                    onDragCompleted:
                                        (handlerIndex, lower, upper) async {
                                      final controller = webViewController;
                                      if (stateSetting.pageDirection ==
                                          PageDirection.vertical) {
                                        await controller!.evaluateJavascript(
                                          source: '''
                                                                                    window.scrollTo(0, 0);
                                                                                    var y = getOffset( document.querySelector('[data-page="${lower.floor() - 1}"]') ).top;
                                                                                      window.scrollTo(0, y);
                                                                                      ''',
                                        );
                                      } else {
                                        await controller!
                                            .evaluateJavascript(source: '''
                                                                              var x = getOffset(document.querySelector('[data-page="${lower.floor() - 1}"]')).left;
                                                                              horizontal_container.scrollLeft = x;
                                                                            ''');
                                      }
                                    },
                                  ),
                                ),
                                EsaySize.gap(5),
                              ]);
                        },
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  String applyTextReplacements(String text) {
    text = text.replaceAll("<p style='color: blue;font-size: 67%'",
        "<hr><p style='color: blue;font-size: 14px !important'");
    text = text.replaceAll("(عليهم السلام)", "<span class =AboThar></span>");
    text = text.replaceAll("(عليهم السّلام)", "<span class =AboThar></span>");
    text = text.replaceAll("(عليها السلام)", "<span class =AboThar></span>");
    text = text.replaceAll("(عليهالسلام)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عَلَيْهَا السَّلَامُ)", "<span class =AboThar></span>");
    text = text.replaceAll("(عليه السلام)", "<span class =AboThar></span>");
    text = text.replaceAll("(علیه السلام)", "<span class =AboThar></span>");
    text = text.replaceAll("(ع)", "<span class =AboThar></span>");

    text = text.replaceAll(
        "(صلّى الله عليه وآله)", "<span class =AboThar></span>");
    text =
        text.replaceAll("صلى اله عليه وسلم", "<span class =AboThar></span>");
    text =
        text.replaceAll("(صلى لله عليه وآله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صَلَّى اللَّهُ عَلَيْهِ وَ آلِهِ)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلي الله عليه وآله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلى الله عليه و اله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلي الله عليه و آله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلى الله عليه و آله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلى الله عليه وآله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلي الله عليه وسلم)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلی الله علیه و آله و سلم)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(صلى الله عليه وآله وسلم)", "<span class =AboThar></span>");
    text = text.replaceAll("(ص)", "<span class =AboThar></span>");

    text = text.replaceAll("(رحمه الله)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عجل الله تعالي و فرجه)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عجل الله فرجه الشريف)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عجل الله تعالى و فرجه)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عجل الله تعالى فرجه)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عجل الله تعالى فرجه الشريف)", "<span class =AboThar></span>");
    text = text.replaceAll("(عج)", "<span class =AboThar></span>");
    text = text.replaceAll(
        "(عجل الله تعالي فرجه)", "<span class =AboThar></span>");
    text = text.replaceAll("(عجل الله فرجه)", "<span class =AboThar></span>");

    text = text.replaceAll("(رضي الله عنه)", "<span class =AboThar></span>");
    text = text.replaceAll("(قدس سره)", "<span class =AboThar></span>");
    text = text.replaceAll("﴿", "<span class=AboThar></span>");
    text = text.replaceAll("﴾", "<span class=AboThar></span>");
    text = text.replaceAll("{", "<span class=AboThar></span>");
    text = text.replaceAll("}", "<span class=AboThar></span>");

    return text;
  }
}
