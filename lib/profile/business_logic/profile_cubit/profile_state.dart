part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {
  final UserModel? user;
  const ProfileState({this.user});
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(UserModel user) : super(user: user);
}

class UpdateProfileLoading extends ProfileState {
  const UpdateProfileLoading(UserModel user) : super(user: user);
}

class UpdateProfileSuccess extends ProfileState {
  const UpdateProfileSuccess(UserModel user) : super(user: user);
}

class UpdateProfileFailure extends ProfileState {
  final String message;
  const UpdateProfileFailure(UserModel user, this.message) : super(user: user);
}
