import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/presentation/manager/movie_cubit.dart';
import 'package:movies/modules/home/presentation/manager/movie_state.dart';
import 'package:movies/modules/home/presentation/widgets/home_widgets.dart';

class BrowseScreen extends StatefulWidget {
  final ValueChanged<Movie>? onMovieTap;

  const BrowseScreen({super.key, this.onMovieTap});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  static const _genreParameters = <String?>[
    null,
    'Action',
    'Comedy',
    'Drama',
  ];
  int _selectedGenre = 0;

  void _loadSelectedGenre() {
    context.read<MoviesCubit>().fetchMovies(
          genre: _genreParameters[_selectedGenre],
        );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final genres = [
      localizations.allMovies,
      localizations.actionGenre,
      localizations.comedyGenre,
      localizations.dramaGenre,
    ];

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
                    onSelected: (_) {
                      setState(() => _selectedGenre = index);
                      _loadSelectedGenre();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<MoviesCubit, MoviesState>(
                builder: (context, state) {
                  if (state is MoviesLoading || state is MoviesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MoviesError) {
                    return HomeLoadError(
                      message: localizations.movieLoadError,
                      onRetry: _loadSelectedGenre,
                    );
                  }
                  if (state is MoviesLoaded) {
                    if (state.movies.isEmpty) {
                      return EmptyMovieSection(
                        message: localizations.noMoviesYet,
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.66,
                      ),
                      itemBuilder: (context, index) => SmallMoviePosterCard(
                        movie: state.movies[index],
                        width: double.infinity,
                        onTap: widget.onMovieTap,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
