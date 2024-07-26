part of 'init_dependencies.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supaAnonkey,
  );

  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;

  serviceLocater.registerLazySingleton(
    () => supabase.client,
  );

  serviceLocater.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocater.registerFactory(() => InternetConnection());

  //core
  serviceLocater.registerLazySingleton(() => AppUserCubit());
  serviceLocater.registerFactory(
    () => ConnectionCheakerImpl(
      serviceLocater(),
    ),
  );
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

void _initBlog() {
  //data
  serviceLocater
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocater(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocater(),
      ),
    )

    //repo
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocater(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocater(),
        getAllBlogs: serviceLocater(),
      ),
    );
}
