import 'package:equatable/equatable.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => const [];
}

class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

class MoviesLoading extends MoviesState {
  const MoviesLoading();
}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;

  MoviesLoaded(Iterable<Movie> movies)
      : movies = List<Movie>.unmodifiable(movies);

  @override
  List<Object?> get props => [movies];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
