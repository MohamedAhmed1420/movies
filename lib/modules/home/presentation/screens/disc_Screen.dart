// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/presentation/widgets/home_widgets.dart';

class DiscScreen extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;

  const DiscScreen({
    super.key,
    required this.movies,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                localizations.discoverMovies,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 18),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (movies.isEmpty)
                EmptyMovieSection(message: localizations.noMoviesYet)
              else ...[
                Text(
                  localizations.featuredMovies,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SmallMoviePosterCard(
                      movie: movies[index],
                      width: 130,
                    ),
                  ),
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }
}
