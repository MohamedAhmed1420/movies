import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';

class FeaturedMovieCarousel extends StatelessWidget {
  final PageController controller;
  final List<Movie> movies;
  final String availableNowLabel;
  final String watchNowLabel;
  final ValueChanged<Movie>? onMovieTap;
  final ValueChanged<Movie>? onPageChanged;

  const FeaturedMovieCarousel({
    super.key,
    required this.controller,
    required this.movies,
    required this.availableNowLabel,
    required this.watchNowLabel,
    this.onMovieTap,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final carouselMovies =
        movies.length == 1 ? [movies.single, movies.single] : movies;

    return SizedBox(
      height: 420,
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Text(
                availableNowLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'serif',
                  fontStyle: FontStyle.italic,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                ),
              ),
            ),
            Positioned(
              top: 72,
              left: 0,
              right: 0,
              height: 250,
              child: PageView.builder(
                controller: controller,
                itemCount: carouselMovies.length,
                onPageChanged: (index) =>
                    onPageChanged?.call(carouselMovies[index]),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: FeaturedPosterCard(
                    movie: carouselMovies[index],
                    onTap: onMovieTap == null
                        ? null
                        : () => onMovieTap!(carouselMovies[index]),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 4,
              child: Text(
                watchNowLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'serif',
                  fontStyle: FontStyle.italic,
                  fontSize: 43,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 10)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedPosterCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const FeaturedPosterCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: movie.title,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _PosterImage(imageUrl: movie.posterUrl),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent, Colors.black54],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            Positioned(
              top: 9,
              left: 8,
              child: RatingBadge(rating: movie.rating.toStringAsFixed(1)),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class SmallMoviePosterCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final ValueChanged<Movie>? onTap;

  const SmallMoviePosterCard({
    super.key,
    required this.movie,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: movie.title,
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: onTap == null ? null : () => onTap!(movie),
          child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PosterImage(imageUrl: movie.posterUrl),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black38,
                      Colors.transparent,
                      Colors.black26,
                    ],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 5,
                child: RatingBadge(
                  rating: movie.rating.toStringAsFixed(1),
                  compact: true,
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String imageUrl;

  const _PosterImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const ColoredBox(
        color: Color(0xFF353535),
        child: Center(
          child: Icon(Icons.movie_outlined, color: AppColors.yellow, size: 28),
        ),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final String rating;
  final bool compact;

  const RatingBadge({super.key, required this.rating, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 7,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xDD202020),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating,
            style: TextStyle(
              color: AppColors.white,
              fontSize: compact ? 9 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: compact ? 2 : 4),
          Icon(
            Icons.star_rounded,
            color: AppColors.yellow,
            size: compact ? 11 : 14,
          ),
        ],
      ),
    );
  }
}

class HomeLoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeLoadError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyMovieSection(message: message),
        IconButton(
          onPressed: onRetry,
          tooltip: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
          icon: const Icon(Icons.refresh_rounded, color: AppColors.yellow),
        ),
      ],
    );
  }
}

class EmptyMovieSection extends StatelessWidget {
  final String message;

  const EmptyMovieSection({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.gray.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_movies_outlined,
            color: AppColors.yellow,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final AppUser user;
  final double radius;

  const UserAvatar({super.key, required this.user, required this.radius});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.photoUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.gray,
      child: imageUrl == null
          ? Icon(Icons.person, color: AppColors.yellow, size: radius)
          : ClipOval(
              child: Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(Icons.person, color: AppColors.yellow, size: radius),
              ),
            ),
    );
  }
}
