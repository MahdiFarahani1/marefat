
// // content_cubit.dart

// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';


// part 'content_state.dart';

// class ContentCubit extends Cubit<ContentState> {
//   final int bookId;
//   final ContentRepository repository;


//   ContentCubit({
//     required this.bookId,
//     required this.repository,

//   }) : super(ContentState.initial());

//   void toggleWebView(bool value) {
//     emit(state.copyWith(showWebView: value));
//   }

//   void toggleAudio(bool value) {
//     emit(state.copyWith(showAudio: value));
//   }

//   void setBookInfo(Map<String, dynamic> info) {
//     emit(state.copyWith(bookInfo: info));
//   }

//   void setPages(List<dynamic> pages) {
//     emit(state.copyWith(pages: pages));
//   }

//   void setCurrentWebViewController(InAppWebViewController? controller) {
//     emit(state.copyWith(webViewController: controller));
//   }

//   // Add more methods as needed to match controller logic
// }
