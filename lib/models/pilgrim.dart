class Pilgrim {
  final int id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final String gender;
  final String healthNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pilgrim({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.gender,
    required this.healthNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pilgrim.fromJson(Map<String, dynamic> json) {
    return Pilgrim(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      avatarUrl: json['photo'],
      gender: json['gender'],
      healthNotes: json['health_notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
