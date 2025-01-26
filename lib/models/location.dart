
class Location {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double lat;
  final double lng;
  final String category;

  const Location({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.lat,
    required this.lng,
    required this.category,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'imageUrl': imageUrl,
      'lat': lat,
      'lng': lng,
      'category': category,
    };
  }
}
