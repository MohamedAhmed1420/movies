import 'package:flutter/material.dart';
import 'package:movies/core/routes/app_routes.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/onboarding/presentation/screens/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onNext(int pageCount) {
    if (_currentIndex < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // قائمة الصفحات مع دمج الترجمات الحية ديناميكياً
    final List<OnboardingItem> pages = [
      OnboardingItem(
        title: localizations.findYourNextFavoriteMovie,
        description: localizations.findYourNextFavoriteMovieDesc,
        imageUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1000",
      ),
      OnboardingItem(
        title: localizations.discoverMovies,
        description: localizations.discoverMoviesDesc,
        imageUrl: "https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=1000",
      ),
      OnboardingItem(
        title: localizations.exploreAllGenres,
        description: localizations.exploreAllGenresDesc,
        imageUrl: "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?q=80&w=1000",
      ),
      OnboardingItem(
        title: localizations.createWatchlists,
        description: localizations.createWatchlistsDesc,
        imageUrl: "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1000",
      ),
      OnboardingItem(
        title: localizations.rateReviewAndLearn,
        description: localizations.rateReviewAndLearnDesc,
        imageUrl: "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=1000",
      ),
      OnboardingItem(
        title: localizations.startWatchingNow,
        description: localizations.startWatchingNowDesc,
        imageUrl: "https://images.unsplash.com/photo-1574267432553-4b4628081c31?q=80&w=1000",
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background PageView with Poster & Gradient Overlay
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final page = pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(page.imageUrl, fit: BoxFit.cover),
                  // Dark Gradient Overlay at the bottom
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Bottom Content Card & Action Buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: _currentIndex == 0
                    ? LinearGradient(
                  colors: [
                    AppColors.black,
                    AppColors.black.withValues(alpha: .5),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
                    : null,
                color: AppColors.black,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pages[_currentIndex].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pages[_currentIndex].description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Primary Button ("Explore Now" / "Next" / "Finish")
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _onNext(pages.length),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentIndex == 0
                            ? localizations.exploreNow
                            : (_currentIndex == pages.length - 1
                            ? localizations.finish
                            : localizations.next),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Secondary Button ("Back") - visible on pages > 0
                  if (_currentIndex > 0) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _onBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFFFC107)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localizations.back,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFC107),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}