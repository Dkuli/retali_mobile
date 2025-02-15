class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String? fcmToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.fcmToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatar'],
      fcmToken: json['fcm_token'],
    );
  }
}
