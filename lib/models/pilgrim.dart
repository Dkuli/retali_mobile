
class Pilgrim {
  final int id;
  final String name;
  final String phone;
  final String? avatarUrl;

  Pilgrim({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
  });

  factory Pilgrim.fromJson(Map<String, dynamic> json) {
    return Pilgrim(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
    );
  }
}
