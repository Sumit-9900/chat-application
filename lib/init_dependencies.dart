import 'package:chat_app/features/auth/repository/auth_local_repository.dart';
import 'package:chat_app/features/auth/repository/auth_remote_repository.dart';
import 'package:chat_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/repository/chat_remote_repository.dart';
import 'package:chat_app/features/chat/viewmodel/bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/viewmodel/bloc/chat_group_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final client = http.Client();

  final prefs = await SharedPreferences.getInstance();

  // Repository
  getIt.registerFactory<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(client),
  );

  getIt.registerFactory<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(prefs),
  );

  getIt.registerFactory<ChatRemoteRepository>(
    () => ChatRemoteRepositoryImpl(client),
  );

  // Bloc
  getIt.registerLazySingleton(
    () => AuthBloc(authRemoteRepository: getIt(), authLocalRepository: getIt()),
  );

  getIt.registerLazySingleton(
    () => ChatGroupBloc(
      chatRemoteRepository: getIt(),
      authLocalRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => ChatBloc(chatRemoteRepository: getIt()));
}
