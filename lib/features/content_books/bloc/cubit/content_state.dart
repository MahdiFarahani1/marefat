// // content_state.dart

// part of 'content_cubit.dart';

// class ContentState {
//   final bool showWebView;
//   final bool showAudio;
//   final Map<String, dynamic>? bookInfo;
//   final List<dynamic> pages;
//   final InAppWebViewController? webViewController;

//   const ContentState({
//     required this.showWebView,
//     required this.showAudio,
//     required this.bookInfo,
//     required this.pages,
//     required this.webViewController,
//   });

//   factory ContentState.initial() {
//     return const ContentState(
//       showWebView: true,
//       showAudio: false,
//       bookInfo: null,
//       pages: [],
//       webViewController: null,
//     );
//   }

//   ContentState copyWith({
//     bool? showWebView,
//     bool? showAudio,
//     Map<String, dynamic>? bookInfo,
//     List<dynamic>? pages,
//     InAppWebViewController? webViewController,
//   }) {
//     return ContentState(
//       showWebView: showWebView ?? this.showWebView,
//       showAudio: showAudio ?? this.showAudio,
//       bookInfo: bookInfo ?? this.bookInfo,
//       pages: pages ?? this.pages,
//       webViewController: webViewController ?? this.webViewController,
//     );
//   }
// }
