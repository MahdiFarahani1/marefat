class GalleryPhoto {
  final int id;
  final String title;
  final String img;
  final DateTime updatedAt;
  final int idShow;

  GalleryPhoto({
    required this.id,
    required this.title,
    required this.img,
    required this.updatedAt,
    required this.idShow,
  });

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) {
    return GalleryPhoto(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      updatedAt: DateTime.parse(json['updated_at']),
      idShow: json['id_show'],
    );
  }
}
