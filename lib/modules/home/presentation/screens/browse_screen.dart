import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/presentation/widgets/home_widgets.dart';

class BrowseScreen extends StatefulWidget {
  final List<Movie> allMovies;
  final List<Movie> actionMovies;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  const BrowseScreen({
    super.key,
    required this.allMovies,
    required this.actionMovies,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  int _selectedGenre = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final genres = [
      localizations.allMovies,
      localizations.actionGenre,
      localizations.comedyGenre,
      localizations.dramaGenre,
    ];
    final moviesToShow = switch (_selectedGenre) {
      0 => widget.allMovies,
      1 => widget.actionMovies,
      _ => const <Movie>[],
    };

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                localizations.categories,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => ChoiceChip(
                    label: Text(genres[index]),
                    selected: _selectedGenre == index,
                    selectedColor: AppColors.yellow,
                    backgroundColor: AppColors.gray,
                    labelStyle: TextStyle(
                      color: _selectedGenre == index
                          ? AppColors.black
                          : AppColors.white,
                    ),
                    onSelected: (_) => setState(() => _selectedGenre = index),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (widget.errorMessage != null)
                HomeLoadError(
                  message: widget.errorMessage!,
                  onRetry: widget.onRetry,
                )
              else if (moviesToShow.isEmpty)
                EmptyMovieSection(message: localizations.noMoviesYet)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: moviesToShow.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.66,
                  ),
                  itemBuilder: (context, index) => SmallMoviePosterCard(
                    movie: moviesToShow[index],
                    width: double.infinity,
                  ),
                ),
            ]),
          ),
        ),
      ],
    );
  }
}
