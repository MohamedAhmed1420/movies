import 'package:dartz/dartz.dart';
import 'package:movies/core/error/exceptions.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/modules/home/data/data_sources/home_data_source.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  const HomeRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Movie>>> getFeaturedMovies() =>
      _guard(dataSource.getFeaturedMovies);

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(String genre) =>
      _guard(() => dataSource.getMoviesByGenre(genre));

  Future<Either<Failure, List<Movie>>> _guard(
    Future<List<Movie>> Function() operation,
  ) async {
    try {
      return Right(await operation());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
