// import 'package:chat_app/core/failure/app_failure.dart';
import 'package:chat_app/features/auth/repository/auth_local_repository.dart';
import 'package:chat_app/features/auth/repository/auth_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository _authRemoteRepository;
  final AuthLocalRepository _authLocalRepository;
  AuthBloc({
    required AuthRemoteRepository authRemoteRepository,
    required AuthLocalRepository authLocalRepository,
  }) : _authRemoteRepository = authRemoteRepository,
       _authLocalRepository = authLocalRepository,
       super(AuthLoginInitial()) {
    on(_onLogin);
    on(_onRegister);
  }

  void _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoginLoading());

    final res = await _authRemoteRepository.login(
      phoneNumber: event.phoneNumber,
    );

    res.fold((l) => emit(AuthLoginFailure(l.message)), (r) {
      emit(AuthLoginSuccess());
      _authLocalRepository.setPrefsData(r);
    });
  }

  void _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoginLoading());

    final token = _authLocalRepository.getPrefsData();

    final res = await _authRemoteRepository.register(
      firstName: event.firstName,
      lastName: event.lastName,
      authToken: token!,
    );

    res.fold(
      (l) => emit(AuthLoginFailure(l.message)),
      (r) => emit(AuthLoginSuccess()),
    );
  }
}
