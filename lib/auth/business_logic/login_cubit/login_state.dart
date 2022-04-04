part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginPending extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}
