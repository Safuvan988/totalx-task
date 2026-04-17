import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/send_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/users/data/datasources/user_local_datasource.dart';
import 'features/users/data/models/user_model.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/add_user_usecase.dart';
import 'features/users/domain/usecases/get_users_usecase.dart';
import 'features/users/domain/usecases/search_users_usecase.dart';
import 'features/users/domain/usecases/sort_users_usecase.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── Hive ──────────────────────────────────────────────────────────────────
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  final usersBox = await UserLocalDataSourceImpl.openBox();

  // ─── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(usersBox),
  );

  // ─── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // ─── Auth Use Cases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  // ─── User Use Cases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => AddUserUseCase(sl()));
  sl.registerLazySingleton(() => SearchUsersUseCase(sl()));
  sl.registerLazySingleton(() => SortUsersUseCase(sl()));

  // ─── BLoCs (factory so each widget tree gets a fresh instance) ────────────
  sl.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UserBloc(
      getUsers: sl(),
      addUser: sl(),
      searchUsers: sl(),
      sortUsers: sl(),
    ),
  );
}
