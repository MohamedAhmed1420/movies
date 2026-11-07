import 'package:movies/modules/home/data/models/movie_model.dart';
import 'package:movies/modules/home/domain/entities/movie_details.dart';

class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required super.movie,
    required super.backgroundImageUrl,
    required super.trailerCode,
    required super.year,
    required super.runtime,
    required super.language,
    required super.genres,
    required super.screenshots,
    required super.cast,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final movie = MovieModel.fromJson(json);
    final rawGenres = json['genres'];
    final rawCast = json['cast'];
    final screenshots = <String>[
      json['medium_screenshot_image1'],
      json['medium_screenshot_image2'],
      json['medium_screenshot_image3'],
    ].whereType<String>().where((url) => url.isNotEmpty);

    return MovieDetailsModel(
      movie: movie,
      backgroundImageUrl: json['background_image'] as String? ??
          json['background_image_original'] as String? ??
          movie.posterUrl,
      trailerCode: json['yt_trailer_code'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? '',
      genres: rawGenres is List ? rawGenres.whereType<String>() : const [],
      screenshots: screenshots,
      cast: rawCast is List
          ? rawCast.whereType<Map>().map((entry) {
              final member = Map<String, dynamic>.from(entry);
              return MovieCastMember(
                name: member['name'] as String? ?? '',
                characterName: member['character_name'] as String? ?? '',
                imageUrl: member['url_small_image'] as String? ?? '',
              );
            })
          : const [],
    );
  }
}
