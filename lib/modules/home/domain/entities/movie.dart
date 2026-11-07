import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String summary;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.id,
    required this.title,
    required this.summary,
    required this.posterUrl,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, title, summary, posterUrl, rating];
}
