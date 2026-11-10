import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/service_locator.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/movie_collection_repository.dart';
import 'package:movies/modules/home/domain/entities/movie_details.dart';
import 'package:movies/modules/home/presentation/manager/movie_details_cubit.dart';
import 'package:movies/modules/home/presentation/manager/movie_details_state.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieDetailsCubit>()..load(movie.id),
      child: _MovieDetailsView(movie: movie),
    );
  }
}

class _MovieDetailsView extends StatelessWidget {
  final Movie movie;

  const _MovieDetailsView({required this.movie});

  Future<void> _openTrailer(
    BuildContext context,
    String trailerCode,
    Movie movie,
  ) async {
    final localizations = AppLocalizations.of(context)!;
    if (trailerCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.trailerUnavailable)),
      );
      return;
    }
    final uri = Uri.https('www.youtube.com', '/watch', {'v': trailerCode});
    final launched =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launched) {
      await sl<MovieCollectionRepository>().markMovieAsWatched(movie);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.trailerUnavailable)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          final details = state is MovieDetailsLoaded ? state.details : null;
          final activeMovie = details?.movie ?? movie;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _DetailsHero(
                  imageUrl: details?.backgroundImageUrl ?? movie.posterUrl,
                  movie: activeMovie,
                  onBack: () => Navigator.of(context).maybePop(),
                  onPlay: details == null
                      ? null
                      : () => _openTrailer(
                          context,
                          details.trailerCode,
                          activeMovie,
                        ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      activeMovie.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (details != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (details.year > 0) '${details.year}',
                          if (details.runtime > 0)
                            '${details.runtime} ${l10n.minutesShort}',
                        ].join('  •  '),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    _RatingStrip(rating: activeMovie.rating),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: details == null
                            ? null
                            : () => _openTrailer(
                                context,
                                details.trailerCode,
                                activeMovie,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE9292D),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF5A2929),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Text(
                          l10n.watchMovie,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (state is MovieDetailsLoading)
                      const Padding(
                        padding: EdgeInsets.all(18),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        ),
                      )
                    else if (state is MovieDetailsError)
                      _DetailsError(
                        message: l10n.movieLoadError,
                        onRetry: () =>
                            context.read<MovieDetailsCubit>().load(movie.id),
                      )
                    else if (details != null) ...[
                      _SectionTitle(l10n.screenShots),
                      const SizedBox(height: 7),
                      _Screenshots(images: details.screenshots),
                      const SizedBox(height: 13),
                      _SectionTitle(l10n.similarMovies),
                      const SizedBox(height: 7),
                      _SimilarMovies(
                        movies: (state as MovieDetailsLoaded).suggestions,
                        onTap: (item) => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => MovieDetailsScreen(movie: item),
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      _SectionTitle(l10n.movieSummary),
                      const SizedBox(height: 5),
                      Text(
                        activeMovie.summary.isEmpty
                            ? l10n.summaryUnavailable
                            : activeMovie.summary,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          height: 1.42,
                        ),
                      ),
                      const SizedBox(height: 13),
                      _SectionTitle(l10n.cast),
                      const SizedBox(height: 6),
                      _CastList(cast: details.cast),
                      const SizedBox(height: 13),
                      _SectionTitle(l10n.genres),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: details.genres
                            .map((genre) => _GenreChip(label: genre))
                            .toList(growable: false),
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailsHero extends StatefulWidget {
  final String imageUrl;
  final Movie movie;
  final VoidCallback onBack;
  final VoidCallback? onPlay;

  const _DetailsHero({
    required this.imageUrl,
    required this.movie,
    required this.onBack,
    required this.onPlay,
  });

  @override
  State<_DetailsHero> createState() => _DetailsHeroState();
}

class _DetailsHeroState extends State<_DetailsHero> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  @override
  void didUpdateWidget(covariant _DetailsHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie.id != widget.movie.id) _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final isSaved = await sl<MovieCollectionRepository>().isSaved(widget.movie.id);
    if (mounted) setState(() => _isSaved = isSaved);
  }

  Future<void> _toggleSaved() async {
    final isSaved = await sl<MovieCollectionRepository>().toggleSavedMovie(widget.movie);
    if (mounted) setState(() => _isSaved = isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFF292929)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent, Color(0xEE111111)],
                stops: [0, 0.42, 1],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 3,
            left: 7,
            child: IconButton(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 3,
            right: 7,
            child: IconButton(
              onPressed: _toggleSaved,
              icon: Icon(
                _isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
          Center(
            child: Material(
              color: const Color(0xCCF1C40F),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onPlay,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingStrip extends StatelessWidget {
  final double rating;

  const _RatingStrip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 11, color: Color(0xFFFFD400)),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
}

class _Screenshots extends StatelessWidget {
  final List<String> images;

  const _Screenshots({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox(
        height: 62,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.white38),
        ),
      );
    }
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFF292929)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimilarMovies extends StatelessWidget {
  final List<Movie> movies;
  final ValueChanged<Movie> onTap;

  const _SimilarMovies({required this.movies, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 50,
        child: Center(
          child: Icon(Icons.movie_outlined, color: Colors.white38),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length > 4 ? 4 : movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = movies[index];
        return GestureDetector(
          onTap: () => onTap(item),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFF292929)),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '★ ${item.rating.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CastList extends StatelessWidget {
  final List<MovieCastMember> cast;

  const _CastList({required this.cast});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();
    return Column(
      children: cast.take(4).map((person) {
        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF202020),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: const Color(0xFF383838),
                backgroundImage:
                    person.imageUrl.isEmpty ? null : NetworkImage(person.imageUrl),
                child: person.imageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white54, size: 15)
                    : null,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  '${person.name}  •  ${person.characterName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ),
            ],
          ),
        );
      }).toList(growable: false),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;

  const _GenreChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF292929),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
    );
  }
}

class _DetailsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DetailsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          TextButton(onPressed: onRetry, child: const Icon(Icons.refresh, color: AppColors.yellow)),
        ],
      );
}
