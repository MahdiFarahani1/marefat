import 'dart:convert';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:http/http.dart' as http;
import '../model/gallery_photo.dart';

class GalleryRepository {
  Future<List<GalleryPhoto>> fetchGallery() async {
    final response = await http.get(Uri.parse(ConstantApp.galleryApi));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> galleryList = data['gallery'];
      return galleryList.map((item) => GalleryPhoto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load gallery');
    }
  }
}
