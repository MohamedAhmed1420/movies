import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @findYourNextFavoriteMovie.
  ///
  /// In en, this message translates to:
  /// **'Find Your Next\nFavorite Movie Here'**
  String get findYourNextFavoriteMovie;

  /// No description provided for @findYourNextFavoriteMovieDesc.
  ///
  /// In en, this message translates to:
  /// **'Get access to a huge library of movies to suit all tastes. You will surely like it.'**
  String get findYourNextFavoriteMovieDesc;

  /// No description provided for @discoverMovies.
  ///
  /// In en, this message translates to:
  /// **'Discover Movies'**
  String get discoverMovies;

  /// No description provided for @discoverMoviesDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.'**
  String get discoverMoviesDesc;

  /// No description provided for @exploreAllGenres.
  ///
  /// In en, this message translates to:
  /// **'Explore All Genres'**
  String get exploreAllGenres;

  /// No description provided for @exploreAllGenresDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.'**
  String get exploreAllGenresDesc;

  /// No description provided for @createWatchlists.
  ///
  /// In en, this message translates to:
  /// **'Create Watchlists'**
  String get createWatchlists;

  /// No description provided for @createWatchlistsDesc.
  ///
  /// In en, this message translates to:
  /// **'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.'**
  String get createWatchlistsDesc;

  /// No description provided for @rateReviewAndLearn.
  ///
  /// In en, this message translates to:
  /// **'Rate, Review, and Learn'**
  String get rateReviewAndLearn;

  /// No description provided for @rateReviewAndLearnDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.'**
  String get rateReviewAndLearnDesc;

  /// No description provided for @startWatchingNow.
  ///
  /// In en, this message translates to:
  /// **'Start Watching Now'**
  String get startWatchingNow;

  /// No description provided for @startWatchingNowDesc.
  ///
  /// In en, this message translates to:
  /// **'Everything is ready for you. Jump in and start enjoying your favorite movies anytime, anywhere.'**
  String get startWatchingNowDesc;

  /// No description provided for @exploreNow.
  ///
  /// In en, this message translates to:
  /// **'Explore Now'**
  String get exploreNow;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLength;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forgetPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have Account ? '**
  String get dontHaveAccount;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create One'**
  String get createOne;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login With Google'**
  String get loginWithGoogle;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPasswordTitle;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have Account ? '**
  String get alreadyHaveAccount;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully!'**
  String get loginSuccess;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google successfully!'**
  String get googleSignInSuccess;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to your email!'**
  String get passwordResetEmailSent;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @signedInAccount.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @movieCatalogPending.
  ///
  /// In en, this message translates to:
  /// **'Your movie catalog will appear here once it is connected.'**
  String get movieCatalogPending;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get authWeakPassword;

  /// No description provided for @authEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for that email.'**
  String get authEmailAlreadyInUse;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid.'**
  String get authInvalidEmail;

  /// No description provided for @authUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user was found for that email.'**
  String get authUserNotFound;

  /// No description provided for @authInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get authInvalidCredential;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authUserDisabled;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authTooManyRequests;

  /// No description provided for @authOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled.'**
  String get authOperationNotAllowed;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get authNetworkError;

  /// No description provided for @authUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authUnknownError;

  /// No description provided for @avatarLabel.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatarLabel;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @searchMovies.
  ///
  /// In en, this message translates to:
  /// **'Search movies, genres...'**
  String get searchMovies;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @allMovies.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allMovies;

  /// No description provided for @actionGenre.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get actionGenre;

  /// No description provided for @comedyGenre.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get comedyGenre;

  /// No description provided for @dramaGenre.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get dramaGenre;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get availableNow;

  /// No description provided for @watchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get watchNow;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @featuredMovies.
  ///
  /// In en, this message translates to:
  /// **'MOVIE NIGHT'**
  String get featuredMovies;

  /// No description provided for @trendingMovies.
  ///
  /// In en, this message translates to:
  /// **'Trending now'**
  String get trendingMovies;

  /// No description provided for @popularMovies.
  ///
  /// In en, this message translates to:
  /// **'Popular movies'**
  String get popularMovies;

  /// No description provided for @noMoviesYet.
  ///
  /// In en, this message translates to:
  /// **'No movies found.'**
  String get noMoviesYet;

  /// No description provided for @movieLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load movies. Check your connection and try again.'**
  String get movieLoadError;

  /// No description provided for @screenShots.
  ///
  /// In en, this message translates to:
  /// **'Screen Shots'**
  String get screenShots;

  /// No description provided for @similarMovies.
  ///
  /// In en, this message translates to:
  /// **'Similar'**
  String get similarMovies;

  /// No description provided for @movieSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get movieSummary;

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @watchMovie.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watchMovie;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @summaryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Summary is unavailable.'**
  String get summaryUnavailable;

  /// No description provided for @trailerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Trailer is unavailable.'**
  String get trailerUnavailable;

  /// No description provided for @emptyWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Your watchlist is empty for now.'**
  String get emptyWatchlist;

  /// No description provided for @discoverTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get discoverTab;

  /// No description provided for @searchTab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTab;

  /// No description provided for @watchlistTab.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlistTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
