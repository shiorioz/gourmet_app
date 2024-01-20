class Shop {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String image;
  final String stationName;
  final String access;
  final String genre;
  final String address;
  final String openTime;
  final String budget;

  Shop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.image,
    required this.stationName,
    required this.access,
    required this.genre,
    required this.address,
    required this.openTime,
    required this.budget,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
      image: json['photo']['mobile']['l'] ?? json['photo']['mobile']['m'],
      stationName: json['station_name'],
      access: json['mobile_access'],
      genre: json['genre']['name'],
      address: json['address'],
      openTime: json['open'],
      budget: json['budget']['name'],
    );
  }
}
