import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/modules/home/domain/use_cases/get_movies_use_case.dart';
import 'package:movies/modules/home/presentation/manager/movie_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetMoviesUseCase getMoviesUseCase;
  int _latestRequestId = 0;

  MoviesCubit({required this.getMoviesUseCase})
      : super(const MoviesInitial());

  Future<void> fetchMovies({
    int page = 1,
    String? queryTerm,
    String? genre,
  }) async {
    if (isClosed) return;

    final requestId = ++_latestRequestId;
    emit(const MoviesLoading());

    try {
      final result = await getMoviesUseCase(
        GetMoviesParams(
          page: page,
          queryTerm: queryTerm,
          genre: genre,
        ),
      );
      if (isClosed || requestId != _latestRequestId) return;

      result.fold(
        (failure) => emit(MoviesError(failure.message)),
        (movies) => emit(MoviesLoaded(movies)),
      );
    } catch (error) {
      if (!isClosed && requestId == _latestRequestId) {
        emit(MoviesError(error.toString()));
      }
    }
  }
}
