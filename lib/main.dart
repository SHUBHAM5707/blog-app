import 'package:blog/Feature/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:blog/Feature/auth/presentation/pages/login_page.dart';
import 'package:blog/Feature/blog/presenation/pages/blog_page.dart';
import 'package:blog/core/comman/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/theme/theme.dart';
import 'package:blog/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocater<AppUserCubit>()
      ),
      BlocProvider(
        create: (_) => serviceLocater<AuthBloc>()
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }
  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if(isLoggedIn){
            return const BlogPage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}