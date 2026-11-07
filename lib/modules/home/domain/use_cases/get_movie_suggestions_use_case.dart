import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/movie_repository.dart';

class GetMovieSuggestionsUseCase extends UseCase<List<Movie>, int> {
  final MovieRepository repository;

  GetMovieSuggestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(int movieId) {
    return repository.getMovieSuggestions(movieId);
  }
}
