class Shop {
  final String id;
  final String name;
  final String access;
  final String genre;
  final String address;
  final String openTime;

  Shop({
    required this.id,
    required this.name,
    required this.access,
    required this.genre,
    required this.address,
    required this.openTime,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      access: json['access'],
      genre: json['genre']['name'],
      address: json['address'],
      openTime: json['open'],
    );
  }
}
