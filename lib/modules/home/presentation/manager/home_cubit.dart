import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/home/domain/use_cases/get_featured_movies_use_case.dart';
import 'package:movies/modules/home/domain/use_cases/get_movies_by_genre_use_case.dart';
import 'package:movies/modules/home/presentation/manager/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetFeaturedMoviesUseCase getFeaturedMoviesUseCase;
  final GetMoviesByGenreUseCase getMoviesByGenreUseCase;

  HomeCubit({
    required this.getFeaturedMoviesUseCase,
    required this.getMoviesByGenreUseCase,
  }) : super(const HomeInitialState());

  Future<void> loadHome() async {
    emit(const HomeLoadingState());

    try {
      final results = await Future.wait([
        getFeaturedMoviesUseCase(const NoParams()),
        getMoviesByGenreUseCase(const GetMoviesByGenreParams('action')),
      ]);
      if (isClosed) return;

      results[0].fold(
        (failure) => emit(HomeErrorState(failure.message)),
        (featuredMovies) => results[1].fold(
          (failure) => emit(HomeErrorState(failure.message)),
          (actionMovies) => emit(
            HomeLoadedState(
              featuredMovies: featuredMovies,
              actionMovies: actionMovies,
            ),
          ),
        ),
      );
    } catch (error) {
      if (!isClosed) emit(HomeErrorState(error.toString()));
    }
  }
}
