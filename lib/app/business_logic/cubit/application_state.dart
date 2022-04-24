part of 'application_cubit.dart';

@immutable
abstract class ApplicationState {
  final UserModel? user;

  const ApplicationState({this.user});
}

class ApplicationInitial extends ApplicationState {}

class AuthenticationPending extends ApplicationState {}

class AuthenticationLoading extends ApplicationState {}

class AuthenticationAuthenticated extends ApplicationState {
  const AuthenticationAuthenticated(user) : super(user: user);
}

class AuthenticationUnauthenticated extends ApplicationState {}
