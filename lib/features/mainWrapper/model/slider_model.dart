class SliderItem {
  final int id;
  final String lang;
  final String title;
  final String? link;
  final String photoUrl;
  final DateTime startDate;
  final DateTime endDate;

  SliderItem({
    required this.id,
    required this.lang,
    required this.title,
    required this.link,
    required this.photoUrl,
    required this.startDate,
    required this.endDate,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['id'],
      lang: json['lang'],
      title: json['title'],
      link: json['link'],
      photoUrl: json['photo_url'],
      startDate: DateTime.parse(_fixDate(json['start_date'])),
      endDate: DateTime.parse(_fixDate(json['end_date'])),
    );
  }

  static String _fixDate(String dateStr) {
    final parts = dateStr.split('/');
    return '${parts[2]}-${parts[0]}-${parts[1]}';
  }
}
