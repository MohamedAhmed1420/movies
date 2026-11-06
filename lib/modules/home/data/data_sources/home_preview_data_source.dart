import 'package:movies/modules/home/data/data_sources/home_data_source.dart';
import 'package:movies/modules/home/data/models/movie_model.dart';

const _civilWar = MovieModel(
  id: 271110,
  title: 'Captain America: Civil War',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/rAGiXaUfPzY7CDEyNKUofk3Kw2e.jpg',
  rating: 7.7,
);

const _movie1917 = MovieModel(
  id: 530915,
  title: '1917',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/vNgsdsqpmi1iONoCZg6A7TSrEns.jpg',
  rating: 7.7,
);

const _infinityWar = MovieModel(
  id: 299536,
  title: 'Avengers: Infinity War',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
  rating: 7.7,
);

const _blackWidow = MovieModel(
  id: 497698,
  title: 'Black Widow',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg',
  rating: 7.3,
);

class HomePreviewDataSource implements HomeDataSource {
  static const _featuredMovies = [_civilWar, _movie1917, _infinityWar];
  static const _actionMovies = [_civilWar, _infinityWar, _blackWidow];

  @override
  Future<List<MovieModel>> getFeaturedMovies() async => _featuredMovies;

  @override
  Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    if (genre.toLowerCase() == 'action') return _actionMovies;
    return const [];
  }
}
