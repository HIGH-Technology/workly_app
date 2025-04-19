import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workly_flutter/core/di/injection.dart';
import 'package:workly_flutter/core/theme/app_theme.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:workly_flutter/features/auth/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>())],
      child: MaterialApp(
        title: 'Workly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginPage(),
        routes: {'/login': (context) => const LoginPage()},
      ),
    );
  }
}
