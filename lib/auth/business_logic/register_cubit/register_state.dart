part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterPending extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSucess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure(this.message);
}
