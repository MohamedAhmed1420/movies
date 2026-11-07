import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/presentation/manager/movie_cubit.dart';
import 'package:movies/modules/home/presentation/manager/movie_state.dart';
import 'package:movies/modules/home/presentation/widgets/home_widgets.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<Movie>? onMovieTap;

  const SearchScreen({super.key, this.onMovieTap});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _searchDebounce;
  String _query = '';

  void _search(String value) {
    _query = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      context.read<MoviesCubit>().fetchMovies(
            queryTerm: _query.isEmpty ? null : _query,
          );
    });
  }

  void _submitSearch(String value) {
    _query = value.trim();
    _searchDebounce?.cancel();
    context.read<MoviesCubit>().fetchMovies(
          queryTerm: _query.isEmpty ? null : _query,
        );
  }

  void _retry() {
    context.read<MoviesCubit>().fetchMovies(
          queryTerm: _query.isEmpty ? null : _query,
        );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

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
                localizations.searchTab,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              TextField(
                textInputAction: TextInputAction.search,
                onChanged: _search,
                onSubmitted: _submitSearch,
                decoration: InputDecoration(
                  hintText: localizations.searchMovies,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.gray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<MoviesCubit, MoviesState>(
                builder: (context, state) {
                  if (state is MoviesLoading || state is MoviesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MoviesError) {
                    return HomeLoadError(
                      message: localizations.movieLoadError,
                      onRetry: _retry,
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
