import 'package:equatable/equatable.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => const [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<Movie> featuredMovies;
  final List<Movie> actionMovies;

  const HomeLoadedState({
    required this.featuredMovies,
    required this.actionMovies,
  });

  @override
  List<Object?> get props => [featuredMovies, actionMovies];
}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
