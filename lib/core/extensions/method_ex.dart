extension MethodEx on String {
  String fixTitle() {
    if (length > 10) {
      String sub = this..substring(10);
      String newValue = "$sub ...";
      return newValue;
    }
    return this;
  }
}

extension BookTitleExtension on Map<String, dynamic> {
  String getFormattedTitle() {
    bool havePart = this['joz'] != 0;
    return havePart ? '${this['title']} الجزء ${this['joz']}' : this['title'];
  }
}

extension CutString on String {
  String cutString(int length) {
    if (this.length > length) {
      String cut = substring(0, length);
      String updateString = '$cut..';
      return updateString;
    } else {
      return this;
    }
  }
}
