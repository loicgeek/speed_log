part of 'userslist_cubit.dart';

@immutable
abstract class UserslistState {}

class UserslistInitial extends UserslistState {}

class LoadUsersSuccess extends UserslistState {}

class LoadUsersLoading extends UserslistState {}

class LoadUsersFailure extends UserslistState {}
