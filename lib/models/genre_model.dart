class Genre {
  final String code;
  final String name;

  Genre({required this.code, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(code: json['code'], name: json['name']);
  }
}
