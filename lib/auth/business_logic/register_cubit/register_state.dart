part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterPending extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSucess extends RegisterState {
  final UserModel user;

  RegisterSucess(this.user);
}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure(this.message);
}
