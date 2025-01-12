import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kiosk_finder/features/authentication/domain/usecases/signin_usecase.dart';
import 'package:kiosk_finder/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:kiosk_finder/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:kiosk_finder/features/map&marker_display/data/datasources/kiosk_datasource.dart';
import 'package:kiosk_finder/features/map&marker_display/data/repositories/kiosk_repository_impl.dart';
import 'package:kiosk_finder/features/map&marker_display/domain/usecases/fetch_kiosks_usecase.dart';
import 'package:kiosk_finder/features/map&marker_display/domain/usecases/upload_kiosk_usecase.dart';
import 'core/network/network_info.dart';
import 'features/authentication/data/datasources/user_firebase_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/map&marker_display/domain/repositories/kiosk_repository.dart';
import 'features/map&marker_display/presentation/kiosk_bloc/kiosk_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///features- authentication

  //bloc
  sl.registerFactory(() => AuthBloc(signUpUseCase: sl(), signInUseCase: sl()));

  //useCases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  sl.registerLazySingleton(() => SignInUseCase(sl()));

  //repository
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(remoteFirebaseDataSource: sl(), networkInfo: sl()));
  //dataSources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(firebaseAuth: sl()));

  //core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //external
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  //kiosk feature
  //bloc
  sl.registerFactory(() => KioskBloc(fetchKiosksUseCase: sl(),uploadKiosksUseCase: sl()));
  //useCases
  sl.registerLazySingleton(() => UploadKiosksUseCase(sl()));
  //useCases
  sl.registerLazySingleton(() => FetchKiosksUseCase(sl()));
  //repository
  sl.registerLazySingleton<KioskRepository>(() => KioskRepositoryImpl(sl(), sl()));
  //dataSources

  sl.registerLazySingleton<KioskRemoteDataSource>(
      () => KioskRemoteDataSourceImpl(sl()));
  //external
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firebaseFireStore);
}
