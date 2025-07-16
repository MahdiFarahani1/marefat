class BookModel {
  final int id;
  final int part;
  final int categoryId;
  final String title;
  final String img;
  final int? dateTime;
  final String writer;
  final String? scholar;
  final String? sound;
  final String? pdf;
  final String? epub;
  final String? pdfUrl;
  final String? epubUrl;
  final String? updatedAt;
  final int idShow;
  final int bookCode;
  final String? description;
  final int internationalNumber;
  final String? publisher;
  final int changedPages;
  final String? deletedAt;

  BookModel({
    required this.id,
    required this.part,
    required this.categoryId,
    required this.title,
    required this.img,
    required this.dateTime,
    required this.writer,
    required this.scholar,
    required this.sound,
    required this.pdf,
    required this.epub,
    required this.pdfUrl,
    required this.epubUrl,
    required this.updatedAt,
    required this.idShow,
    required this.bookCode,
    required this.description,
    required this.internationalNumber,
    required this.publisher,
    required this.changedPages,
    required this.deletedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      part: json['part'],
      categoryId: json['category_id'],
      title: json['title'] ?? '',
      img: json['img'] ?? '',
      dateTime:
          json['date_time'] != null ? (json['date_time'] as num).toInt() : null,
      writer: json['writer'] ?? '',
      scholar: json['scholar'],
      sound: json['sound'],
      pdf: json['pdf'],
      epub: json['epub'],
      pdfUrl: json['pdf_url'],
      epubUrl: json['epub_url'],
      updatedAt: json['updated_at'],
      idShow: json['id_show'],
      bookCode: json['book_code'],
      description: json['description'],
      internationalNumber: json['international_number'],
      publisher: json['publisher'],
      changedPages: json['changed_pages'],
      deletedAt: json['deleted_at'],
    );
  }
}
