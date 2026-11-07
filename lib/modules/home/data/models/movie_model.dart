import 'package:movies/modules/home/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.posterUrl,
    required super.rating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    if (rawId is! num) {
      throw const FormatException('Movie response is missing a numeric id.');
    }

    final rawRating = json['rating'];
    final rawSummary = json['summary'] ?? json['synopsis'];

    return MovieModel(
      id: rawId.toInt(),
      title: json['title'] as String? ?? '',
      summary: rawSummary is String ? rawSummary : '',
      posterUrl: json['medium_cover_image'] as String? ??
          json['large_cover_image'] as String? ??
          '',
      rating: rawRating is num ? rawRating.toDouble() : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'medium_cover_image': posterUrl,
        'rating': rating,
      };
}
