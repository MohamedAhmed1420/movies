import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/presentation/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  final List<Movie> featuredMovies;
  final List<Movie> actionMovies;
  final List<Movie> comedyMovies;
  final List<Movie> dramaMovies;
  final bool isLoading;
  final bool categoriesLoading;
  final String? errorMessage;
  final String? categoriesErrorMessage;
  final VoidCallback onRetry;
  final VoidCallback onRetryCategories;
  final VoidCallback onSearchTap;
  final VoidCallback onBrowseTap;
  final ValueChanged<Movie>? onMovieTap;
  final ValueChanged<Movie>? onFeaturedMovieChanged;

  const HomeScreen({
    super.key,
    required this.featuredMovies,
    required this.actionMovies,
    required this.comedyMovies,
    required this.dramaMovies,
    required this.isLoading,
    required this.categoriesLoading,
    required this.errorMessage,
    required this.categoriesErrorMessage,
    required this.onRetry,
    required this.onRetryCategories,
    required this.onSearchTap,
    required this.onBrowseTap,
    this.onMovieTap,
    this.onFeaturedMovieChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(
      viewportFraction: 0.56,
      initialPage: 1,
    );
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  void _onFeaturedPageChanged(Movie movie) {
    widget.onFeaturedMovieChanged?.call(movie);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (widget.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: HomeLoadError(
            message: widget.errorMessage!,
            onRetry: widget.onRetry,
          ),
        ),
      );
    }

    final featuredSection = widget.isLoading
        ? const SizedBox(
            height: 420,
            child: Center(child: CircularProgressIndicator()),
          )
        : widget.featuredMovies.isEmpty
            ? SizedBox(
                height: 420,
                child: Center(
                  child: EmptyMovieSection(
                    message: localizations.noMoviesYet,
                  ),
                ),
              )
            : FeaturedMovieCarousel(
                controller: _carouselController,
                movies: widget.featuredMovies,
                availableNowLabel: localizations.availableNow,
                watchNowLabel: localizations.watchNow,
                onMovieTap: widget.onMovieTap,
                onPageChanged: _onFeaturedPageChanged,
              );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              featuredSection,
              const SizedBox(height: 14),
              _categorySection(
                title: localizations.actionGenre,
                movies: widget.actionMovies,
                localizations: localizations,
              ),
              const SizedBox(height: 20),
              _categorySection(
                title: localizations.comedyGenre,
                movies: widget.comedyMovies,
                localizations: localizations,
              ),
              const SizedBox(height: 20),
              _categorySection(
                title: localizations.dramaGenre,
                movies: widget.dramaMovies,
                localizations: localizations,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: widget.onSearchTap,
                  child: Text(localizations.searchTab),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _categorySection({
    required String title,
    required List<Movie> movies,
    required AppLocalizations localizations,
  }) {
    final message = widget.categoriesErrorMessage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: widget.onBrowseTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 2),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 15),
              label: Text(
                localizations.seeMore,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        if (widget.categoriesLoading)
          const SizedBox(
            height: 128,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (message != null)
          SizedBox(
            height: 128,
            child: HomeLoadError(
              message: message,
              onRetry: widget.onRetryCategories,
            ),
          )
        else if (movies.isEmpty)
          SizedBox(
            height: 128,
            child: Center(
              child: Text(
                localizations.noMoviesYet,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) => SmallMoviePosterCard(
                movie: movies[index],
                width: 98,
                onTap: widget.onMovieTap,
              ),
            ),
          ),
      ],
    );
  }
}
