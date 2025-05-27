part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthLoginInitial extends AuthState {}

final class AuthLoginLoading extends AuthState {}

final class AuthLoginFailure extends AuthState {
  final String message;
  AuthLoginFailure(this.message);
}

final class AuthLoginSuccess extends AuthState {}
