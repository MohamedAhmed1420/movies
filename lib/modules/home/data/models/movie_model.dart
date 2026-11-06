import 'package:movies/modules/home/domain/entities/movie.dart';

class MovieModel extends Movie {
  static const _posterBaseUrl = 'https://image.tmdb.org/t/p/w500';

  const MovieModel({
    required super.id,
    required super.title,
    required super.posterUrl,
    required super.rating,
    super.overview,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;
    final rawTitle = json['title'] as String? ?? json['name'] as String? ?? '';

    return MovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: rawTitle,
      posterUrl: _posterUrl(posterPath),
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      overview: json['overview'] as String?,
    );
  }

  static String _posterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$_posterBaseUrl$path';
  }

  Map<String, dynamic> toJson() {
    final posterPath = posterUrl.startsWith(_posterBaseUrl)
        ? posterUrl.substring(_posterBaseUrl.length)
        : posterUrl;

    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'vote_average': rating,
      'overview': overview,
    };
  }
}
