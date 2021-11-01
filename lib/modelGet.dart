class Data {
  var col1;
  var col2;
  var col3;
  var col4;
  var col5;

  Data({
    this.col1,
    this.col2,
    this.col3,
    this.col4,
    this.col5,
  });
  void set column1(String colone) {
    col1 = colone;
  }

  void set column2(String coltwo) {
    col2 = coltwo;
  }

  void set column3(String colthree) {
    col3 = colthree;
  }

  void set column4(String colfour) {
    col4 = colfour;
  }

  void set column5(String colfive) {
    col5 = colfive;
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        col1: json['col1'],
        col2: json['col2'],
        col3: json['col3'],
        col4: json['col4'],
        col5: json['col5']);
  }
}
