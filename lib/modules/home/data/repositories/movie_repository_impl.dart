import 'package:dartz/dartz.dart';
import 'package:movies/core/error/exceptions.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/modules/home/data/data_sources/movie_remote_data_source.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/entities/movie_details.dart';
import 'package:movies/modules/home/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  const MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getMovies({
    required int page,
    String? queryTerm,
    String? genre,
  }) async {
    try {
      final movies = await remoteDataSource.getMovies(
        page: page,
        queryTerm: queryTerm,
        genre: genre,
      );
      return Right(List<Movie>.unmodifiable(movies));
    } on ServerException catch (error) {
      return Left(_failureFor(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId) async {
    try {
      return Right(await remoteDataSource.getMovieDetails(movieId));
    } on ServerException catch (error) {
      return Left(_failureFor(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieSuggestions(int movieId) async {
    try {
      final movies = await remoteDataSource.getMovieSuggestions(movieId);
      return Right(List<Movie>.unmodifiable(movies));
    } on ServerException catch (error) {
      return Left(_failureFor(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  Failure _failureFor(ServerException error) {
    if (error.code == 'network-request-failed' || error.code == 'timeout') {
      return NetworkFailure(error.message);
    }
    return ServerFailure(error.message);
  }
}
