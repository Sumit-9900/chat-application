part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String phoneNumber;
  AuthLogin(this.phoneNumber);
}

final class AuthRegister extends AuthEvent {
  final String firstName;
  final String lastName;
  AuthRegister({required this.firstName, required this.lastName});
}
