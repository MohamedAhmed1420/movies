import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final String? overview;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    this.overview,
  });

  @override
  List<Object?> get props => [id, title, posterUrl, rating, overview];
}
