
class Doa {
  final int id;
  final String title;
  final String arab;
  final String latin;
  final String translation;

  Doa({
    required this.id,
    required this.title,
    required this.arab,
    required this.latin,
    required this.translation,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id'],
      title: json['title'],
      arab: json['arab'],
      latin: json['latin'],
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arab': arab,
      'latin': latin,
      'translation': translation,
    };
  }
}
