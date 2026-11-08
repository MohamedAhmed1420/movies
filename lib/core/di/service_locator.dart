import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../modules/auth/data/data_sources/auth_remote_data_source.dart';
import '../../modules/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/auth/domain/repositories/auth_repository.dart';
import '../../modules/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../modules/auth/domain/use_cases/google_sign_in_use_case.dart';
import '../../modules/auth/domain/use_cases/register_use_case.dart';
import '../../modules/auth/domain/use_cases/send_password_reset_use_case.dart';
import '../../modules/auth/domain/use_cases/sign_in_use_case.dart';
import '../../modules/auth/domain/use_cases/sign_out_use_case.dart';
import '../../modules/auth/presentation/manager/auth_cubit.dart';
import '../../modules/home/data/data_sources/movie_remote_data_source.dart';
import '../../modules/home/data/repositories/movie_repository_impl.dart';
import '../../modules/home/domain/repositories/movie_repository.dart';
import '../../modules/home/domain/use_cases/get_movies_use_case.dart';
import '../../modules/home/domain/use_cases/get_movie_details_use_case.dart';
import '../../modules/home/domain/use_cases/get_movie_suggestions_use_case.dart';
import '../../modules/home/presentation/manager/movie_details_cubit.dart';
import '../../modules/home/presentation/manager/movie_cubit.dart';
import '../../modules/home/presentation/manager/home_categories_cubit.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  if (sl.isRegistered<AuthCubit>()) return;

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSource(
      auth: sl<FirebaseAuth>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => SendPasswordResetUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl<http.Client>()),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl<MovieRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetMoviesUseCase(sl<MovieRepository>()),
  );
  sl.registerLazySingleton(
    () => GetMovieDetailsUseCase(sl<MovieRepository>()),
  );
  sl.registerLazySingleton(
    () => GetMovieSuggestionsUseCase(sl<MovieRepository>()),
  );
  sl.registerFactory(
    () => MovieDetailsCubit(
      getMovieDetailsUseCase: sl<GetMovieDetailsUseCase>(),
      getMovieSuggestionsUseCase: sl<GetMovieSuggestionsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => MoviesCubit(getMoviesUseCase: sl<GetMoviesUseCase>()),
  );
  sl.registerFactory(
    () => HomeCategoriesCubit(getMoviesUseCase: sl<GetMoviesUseCase>()),
  );

  sl.registerFactory(
    () => AuthCubit(
      getCurrentUserUseCase: sl(),
      signInUseCase: sl(),
      registerUseCase: sl(),
      googleSignInUseCase: sl(),
      sendPasswordResetUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );
}
