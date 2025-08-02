class HomeModel {
  final List<SliderModel> sliders;
  final List<LastBookModel> lastBooks;

  HomeModel({required this.sliders, required this.lastBooks});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      sliders: (json['sliders'] as List<dynamic>)
          .map((item) => SliderModel.fromJson(item))
          .toList(),
      lastBooks: (json['last_books'] as List<dynamic>)
          .map((item) => LastBookModel.fromJson(item))
          .toList(),
    );
  }
}

class SliderModel {
  final int id;
  final String lang;
  final String title;
  final String? link;
  final String startDate;
  final String endDate;
  final String photoUrl;

  SliderModel({
    required this.id,
    required this.lang,
    required this.title,
    this.link,
    required this.startDate,
    required this.endDate,
    required this.photoUrl,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      lang: json['lang'],
      title: json['title'],
      link: json['link'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      photoUrl: json['photo_url'],
    );
  }
}

class LastBookModel {
  final int id;
  final String title;
  final String? writer;
  final String? pdf;
  final String photoUrl;

  LastBookModel({
    required this.id,
    required this.title,
    this.writer,
    this.pdf,
    required this.photoUrl,
  });

  factory LastBookModel.fromJson(Map<String, dynamic> json) {
    return LastBookModel(
      id: json['id'],
      title: json['title'],
      writer: json['writer'],
      pdf: json['pdf'],
      photoUrl: json['photo_url'],
    );
  }
}
