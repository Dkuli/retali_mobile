// lib/models/carousel.dart
class Carousel {
  final int id;
  final String title;
  final String? createdAt;
  final String? updatedAt;
  final List<CarouselMedia> media;

  Carousel({
    required this.id,
    required this.title,
    this.createdAt,
    this.updatedAt,
    required this.media,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'],
      title: json['title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      media: (json['media'] as List)
          .map((media) => CarouselMedia.fromJson(media))
          .toList(),
    );
  }
}

class CarouselMedia {
  final int id;
  final String originalUrl;
  final String previewUrl;

  CarouselMedia({
    required this.id,
    required this.originalUrl,
    required this.previewUrl,
  });

  factory CarouselMedia.fromJson(Map<String, dynamic> json) {
    return CarouselMedia(
      id: json['id'],
      originalUrl: json['original_url'],
      previewUrl: json['preview_url'],
    );
  }
}
