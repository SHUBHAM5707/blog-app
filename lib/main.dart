import 'package:blog/Feature/auth/data/datasourse/auth_remote_data_source.dart';
import 'package:blog/Feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/Feature/auth/domain/usecases/user_signup.dart';
import 'package:blog/Feature/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:blog/Feature/auth/presentation/pages/login_page.dart';
import 'package:blog/core/secret/app_secret.dart';
import 'package:blog/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl, 
    anonKey: AppSecret.supaAnonkey
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthBloc(userSignUp: UserSignUp(
        AuthRepositoryImpl(
          AuthrRemoteDataSourceImpl(supabase.client)))))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}