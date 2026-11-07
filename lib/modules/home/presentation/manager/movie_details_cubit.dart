import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/use_cases/get_movie_details_use_case.dart';
import 'package:movies/modules/home/domain/use_cases/get_movie_suggestions_use_case.dart';
import 'package:movies/modules/home/presentation/manager/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;
  final GetMovieSuggestionsUseCase getMovieSuggestionsUseCase;

  MovieDetailsCubit({
    required this.getMovieDetailsUseCase,
    required this.getMovieSuggestionsUseCase,
  }) : super(const MovieDetailsLoading());

  Future<void> load(int movieId) async {
    if (isClosed) return;
    emit(const MovieDetailsLoading());

    final detailsResult = await getMovieDetailsUseCase(movieId);
    if (isClosed) return;

    await detailsResult.fold(
      (failure) async => emit(MovieDetailsError(failure.message)),
      (details) async {
        final suggestionsResult =
            await getMovieSuggestionsUseCase(movieId);
        if (isClosed) return;
        final List<Movie> suggestions = suggestionsResult.fold(
          (_) => const <Movie>[],
          (movies) => movies,
        );
        emit(MovieDetailsLoaded(details: details, suggestions: suggestions));
      },
    );
  }
}
