import 'package:equatable/equatable.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/entities/movie_details.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => const [];
}

class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails details;
  final List<Movie> suggestions;

  MovieDetailsLoaded({
    required this.details,
    required Iterable<Movie> suggestions,
  }) : suggestions = List.unmodifiable(suggestions);

  @override
  List<Object?> get props => [details, suggestions];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
