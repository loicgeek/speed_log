part of 'application_cubit.dart';

@immutable
abstract class ApplicationState {}

class ApplicationInitial extends ApplicationState {}

class AuthenticationPending extends ApplicationState {}

class AuthenticationLoading extends ApplicationState {}

class AuthenticationAuthenticated extends ApplicationState {
  final User user;

  AuthenticationAuthenticated(this.user);
}

class AuthenticationUnauthenticated extends ApplicationState {}
