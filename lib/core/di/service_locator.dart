import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
import '../../modules/home/data/data_sources/home_data_source.dart';
import '../../modules/home/data/data_sources/home_preview_data_source.dart';
import '../../modules/home/data/repositories/home_repository_impl.dart';
import '../../modules/home/domain/repositories/home_repository.dart';
import '../../modules/home/domain/use_cases/get_featured_movies_use_case.dart';
import '../../modules/home/domain/use_cases/get_movies_by_genre_use_case.dart';
import '../../modules/home/presentation/manager/home_cubit.dart';

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
  sl.registerLazySingleton<HomeDataSource>(HomePreviewDataSource.new);
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeDataSource>()),
  );
  sl.registerLazySingleton(
    () => GetFeaturedMoviesUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton(
    () => GetMoviesByGenreUseCase(sl<HomeRepository>()),
  );
  sl.registerFactory(
    () => HomeCubit(
      getFeaturedMoviesUseCase: sl(),
      getMoviesByGenreUseCase: sl(),
    ),
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
