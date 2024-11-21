import 'package:blog_app/constants/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/constants/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initdependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<BlogBloc>(),
      ),
    ],
    child: const ZohApp(),
  ));
}

class ZohApp extends StatefulWidget {
  const ZohApp({super.key});

  @override
  State<ZohApp> createState() => _ZohAppState();
}

class _ZohAppState extends State<ZohApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
