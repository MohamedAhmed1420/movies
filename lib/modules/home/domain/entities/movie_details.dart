import 'package:equatable/equatable.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';

class MovieCastMember extends Equatable {
  final String name;
  final String characterName;
  final String imageUrl;

  const MovieCastMember({
    required this.name,
    required this.characterName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, characterName, imageUrl];
}

class MovieDetails extends Equatable {
  final Movie movie;
  final String backgroundImageUrl;
  final String trailerCode;
  final int year;
  final int runtime;
  final String language;
  final List<String> genres;
  final List<String> screenshots;
  final List<MovieCastMember> cast;

  MovieDetails({
    required this.movie,
    required this.backgroundImageUrl,
    required this.trailerCode,
    required this.year,
    required this.runtime,
    required this.language,
    required Iterable<String> genres,
    required Iterable<String> screenshots,
    required Iterable<MovieCastMember> cast,
  }) : genres = List.unmodifiable(genres),
       screenshots = List.unmodifiable(screenshots),
       cast = List.unmodifiable(cast);

  @override
  List<Object?> get props => [
    movie,
    backgroundImageUrl,
    trailerCode,
    year,
    runtime,
    language,
    genres,
    screenshots,
    cast,
  ];
}
