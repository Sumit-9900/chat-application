import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/features/auth/repository/auth_local_repository.dart';
import 'package:chat_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/view/pages/chat_group_page.dart';
import 'package:chat_app/features/chat/viewmodel/bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/viewmodel/bloc/chat_group_bloc.dart';
import 'package:chat_app/features/splash/view/pages/splash_page.dart';
import 'package:chat_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<ChatGroupBloc>()),
        BlocProvider(create: (_) => getIt<ChatBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authToken = getIt<AuthLocalRepository>().getPrefsData();
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authToken != null ? const ChatGroupPage() : const SplashPage(),
    );
  }
}
