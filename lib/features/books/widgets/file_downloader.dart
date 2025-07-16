import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

typedef ProgressCallback = void Function(double progress);
typedef CompleteCallback = void Function(String filePath);
typedef ErrorCallback = void Function(String error);

class FileDownloader {
  static Future<void> downloadFile({
    required String url,
    String? fileName,
    String? customDirectoryPath,
    ProgressCallback? onProgress,
    CompleteCallback? onComplete,
    ErrorCallback? onError,
  }) async {
    try {
      // مسیر ذخیره
      Directory baseDir = await getApplicationDocumentsDirectory();
      String dirPath = customDirectoryPath ?? baseDir.path;

      String fullPath = '$dirPath/${fileName ?? url.split('/').last}';

      // ساخت دایرکتوری اگر وجود نداشت
      await Directory(dirPath).create(recursive: true);

      Dio dio = Dio();
      await dio.download(
        url,
        fullPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            onProgress?.call(progress);
          } else {}
        },
      );
      print('fullPath: $fullPath');
      onComplete?.call(fullPath);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
