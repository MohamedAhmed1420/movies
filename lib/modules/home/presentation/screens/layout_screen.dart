import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/service_locator.dart';
import 'package:movies/core/routes/app_routes.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/app_toast.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/manager/auth_state.dart';
import 'package:movies/modules/auth/presentation/utils/auth_error_localizer.dart';
import 'package:movies/modules/home/presentation/manager/home_categories_cubit.dart';
import 'package:movies/modules/home/presentation/manager/movie_cubit.dart';
import 'package:movies/modules/home/presentation/manager/movie_state.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/presentation/screens/browse_screen.dart';
import 'package:movies/modules/home/presentation/screens/home_screen.dart';
import 'package:movies/modules/home/presentation/screens/movie_details_screen.dart';
import 'package:movies/modules/home/presentation/screens/profile_screen.dart';
import 'package:movies/modules/home/presentation/screens/search_screen.dart';

const _screenBackground = AppColors.black;

class LayoutScreen extends StatefulWidget {
  final AppUser user;

  const LayoutScreen({super.key, required this.user});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  final ValueNotifier<String?> _homeBackgroundUrl = ValueNotifier(null);

  void _selectTab(int index) => setState(() => _selectedIndex = index);

  @override
  void dispose() {
    _homeBackgroundUrl.dispose();
    super.dispose();
  }

  void _openMovieDetails(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<MoviesCubit>()..fetchMovies()),
        BlocProvider(
          create: (_) => sl<HomeCategoriesCubit>()..fetchHomeCategories(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignOutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          } else if (state is SignOutErrorState) {
            AppToast.show(
              title: authErrorMessage(context, state.code),
              context: context,
              type: AppToastType.error,
            );
          }
        },
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            final loaded = state is MoviesLoaded ? state : null;
            final errorMessage = state is MoviesError
                ? AppLocalizations.of(context)!.movieLoadError
                : null;
            final isLoading = state is MoviesLoading;
            final homeMovies = loaded?.movies ?? const [];
            final initialBackgroundUrl = homeMovies.isEmpty
                ? null
                : homeMovies[homeMovies.length > 1 ? 1 : 0].posterUrl;
            final homeCubit = context.read<MoviesCubit>();
            final pages = [
              BlocBuilder<HomeCategoriesCubit, MoviesState>(
                  builder: (context, categoriesState) {
                    final categories = categoriesState is MovieCategoriesLoaded
                        ? categoriesState
                        : null;
                    final categoriesErrorMessage =
                        categoriesState is MoviesError
                            ? AppLocalizations.of(context)!.movieLoadError
                            : null;
                    final categoriesCubit = context.read<HomeCategoriesCubit>();

                    return HomeScreen(
                      featuredMovies: homeMovies,
                      actionMovies: categories?.actionMovies ?? const <Movie>[],
                      comedyMovies: categories?.comedyMovies ?? const <Movie>[],
                      dramaMovies: categories?.dramaMovies ?? const <Movie>[],
                      isLoading: isLoading,
                      categoriesLoading:
                          categoriesState is MoviesLoading ||
                          categoriesState is MoviesInitial,
                      errorMessage: errorMessage,
                      categoriesErrorMessage: categoriesErrorMessage,
                      onRetry: homeCubit.fetchMovies,
                      onRetryCategories: categoriesCubit.fetchHomeCategories,
                      onSearchTap: () => _selectTab(1),
                      onBrowseTap: () => _selectTab(2),
                      onMovieTap: (movie) => _openMovieDetails(context, movie),
                      onFeaturedMovieChanged: (movie) {
                        _homeBackgroundUrl.value = movie.posterUrl;
                      },
                    );
                  },
                ),
              BlocProvider(
                create: (_) => sl<MoviesCubit>()..fetchMovies(),
                child: SearchScreen(
                  onMovieTap: (movie) => _openMovieDetails(context, movie),
                ),
              ),
              BlocProvider(
                create: (_) => sl<MoviesCubit>()..fetchMovies(),
                child: BrowseScreen(
                  onMovieTap: (movie) => _openMovieDetails(context, movie),
                ),
              ),
              ProfileScreen(
                user: widget.user,
                onMovieTap: (movie) => _openMovieDetails(context, movie),
              ),
            ];

            return ValueListenableBuilder<String?>(
              valueListenable: _homeBackgroundUrl,
              child: SafeArea(
                child: IndexedStack(index: _selectedIndex, children: pages),
              ),
              builder: (context, selectedBackgroundUrl, child) {
                final backgroundUrl = _selectedIndex == 0
                    ? selectedBackgroundUrl ?? initialBackgroundUrl
                    : null;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (backgroundUrl != null)
                      Positioned.fill(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 450),
                          child: Image.network(
                            key: ValueKey(backgroundUrl),
                            backgroundUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const ColoredBox(color: _screenBackground),
                          ),
                        ),
                      ),
                    if (backgroundUrl != null)
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xB8000000),
                                Color(0xD9000000),
                                Color(0xF2111111),
                              ],
                              stops: [0, 0.48, 1],
                            ),
                          ),
                        ),
                      ),
                    Scaffold(
                      extendBody: true,
                      backgroundColor: Colors.transparent,
                      body: child,
                      bottomNavigationBar: _LayoutNavigationBar(
                        selectedIndex: _selectedIndex,
                        onSelected: _selectTab,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LayoutNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _LayoutNavigationBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final labels = [
      localizations.homeTitle,
      localizations.searchTab,
      localizations.categories,
      localizations.profileTab,
    ];
    const icons = [
      Icons.home_rounded,
      Icons.search_rounded,
      Icons.grid_view_rounded,
      Icons.person_outline_rounded,
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF292929),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final selected = selectedIndex == index;
              return IconButton(
                tooltip: labels[index],
                onPressed: () => onSelected(index),
                icon: Icon(
                  icons[index],
                  size: 22,
                  color: selected ? AppColors.yellow : AppColors.white,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
