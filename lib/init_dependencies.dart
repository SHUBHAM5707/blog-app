import 'package:blog/Feature/auth/data/datasourse/auth_remote_data_source.dart';
import 'package:blog/Feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/Feature/auth/domain/repository/auth_repository.dart';
import 'package:blog/Feature/auth/domain/usecases/current_user.dart';
import 'package:blog/Feature/auth/domain/usecases/user_login.dart';
import 'package:blog/Feature/auth/domain/usecases/user_signup.dart';
import 'package:blog/Feature/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:blog/core/comman/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/secret/app_secret.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
      url: AppSecret.supabaseUrl, anonKey: AppSecret.supaAnonkey);
  serviceLocater.registerLazySingleton(() => supabase.client);
  serviceLocater.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthrRemoteDataSourceImpl(
        serviceLocater(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocater(),
      ),
    )
    ..registerFactory(() => UserSignUp(serviceLocater()))
    ..registerFactory(() => UserLogin(serviceLocater()))
    ..registerFactory(() => CurrentUser(serviceLocater()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocater(),
        userLogin: serviceLocater(),
        currentuser: serviceLocater(), 
        appUserCubit: serviceLocater(),
      ),
    );
}
