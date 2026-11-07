import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/core/error/exceptions.dart';
import 'package:movies/modules/home/data/models/movie_details_model.dart';
import 'package:movies/modules/home/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies({
    required int page,
    String? queryTerm,
    String? genre,
  });

  Future<MovieDetailsModel> getMovieDetails(int movieId);

  Future<List<MovieModel>> getMovieSuggestions(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const _baseUrl = 'https://yts.gg/api/v2';
  static const _requestTimeout = Duration(seconds: 15);

  final http.Client client;

  const MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getMovies({
    required int page,
    String? queryTerm,
    String? genre,
  }) async {
    if (page < 1) {
      throw const ServerException('Page must be greater than zero.', code: 'invalid-page');
    }

    final queryParameters = <String, String>{
      'limit': '20',
      'page': page.toString(),
    };
    final normalizedQuery = queryTerm?.trim();
    final normalizedGenre = genre?.trim();
    if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
      queryParameters['query_term'] = normalizedQuery;
    }
    if (normalizedGenre != null && normalizedGenre.isNotEmpty) {
      queryParameters['genre'] = normalizedGenre;
    }

    final data = await _getData('list_movies.json', queryParameters);
    final rawMovies = data['movies'];
    if (rawMovies == null) return const [];
    if (rawMovies is! List) {
      throw const ServerException(
        'The movie service returned an invalid movie list.',
        code: 'invalid-response',
      );
    }
    return _parseMovies(rawMovies);
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final data = await _getData('movie_details.json', {
      'movie_id': movieId.toString(),
      'with_images': 'true',
      'with_cast': 'true',
    });
    final rawMovie = data['movie'];
    if (rawMovie is! Map) {
      throw const ServerException(
        'The movie service returned no movie details.',
        code: 'invalid-response',
      );
    }
    try {
      return MovieDetailsModel.fromJson(Map<String, dynamic>.from(rawMovie));
    } on FormatException catch (error) {
      throw ServerException(error.message, code: 'invalid-response');
    } on TypeError {
      throw const ServerException(
        'The movie service returned invalid movie details.',
        code: 'invalid-response',
      );
    }
  }

  @override
  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    final data = await _getData('movie_suggestions.json', {
      'movie_id': movieId.toString(),
    });
    final rawMovies = data['movies'];
    if (rawMovies == null) return const [];
    if (rawMovies is! List) {
      throw const ServerException(
        'The movie service returned an invalid suggestions list.',
        code: 'invalid-response',
      );
    }
    return _parseMovies(rawMovies);
  }

  Future<Map<String, dynamic>> _getData(
    String endpoint,
    Map<String, String> queryParameters,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint').replace(
      queryParameters: queryParameters,
    );
    late final http.Response response;
    try {
      response = await client.get(uri).timeout(_requestTimeout);
    } on TimeoutException {
      throw const ServerException(
        'The movie request timed out.',
        code: 'timeout',
      );
    } on http.ClientException catch (error) {
      throw ServerException(
        'Unable to connect to the movie service: ${error.message}',
        code: 'network-request-failed',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(
        'The movie service returned HTTP ${response.statusCode}.',
        code: 'http-error',
      );
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const ServerException(
        'The movie service returned invalid JSON.',
        code: 'invalid-response',
      );
    }
    if (decoded is! Map) {
      throw const ServerException(
        'The movie service returned an unexpected response.',
        code: 'invalid-response',
      );
    }

    final json = Map<String, dynamic>.from(decoded);
    if (json['status'] != 'ok') {
      final message = json['status_message'];
      throw ServerException(
        message is String && message.isNotEmpty
            ? message
            : 'The movie service could not complete the request.',
        code: 'api-error',
      );
    }
    final rawData = json['data'];
    if (rawData is! Map) {
      throw const ServerException(
        'The movie service response is missing data.',
        code: 'invalid-response',
      );
    }
    return Map<String, dynamic>.from(rawData);
  }

  List<MovieModel> _parseMovies(List<dynamic> rawMovies) {
    try {
      return rawMovies.map((rawMovie) {
        if (rawMovie is! Map) {
          throw const FormatException('A movie entry is not an object.');
        }
        return MovieModel.fromJson(Map<String, dynamic>.from(rawMovie));
      }).toList(growable: false);
    } on FormatException catch (error) {
      throw ServerException(error.message, code: 'invalid-response');
    } on TypeError {
      throw const ServerException(
        'The movie service returned an invalid movie entry.',
        code: 'invalid-response',
      );
    }
  }
}
