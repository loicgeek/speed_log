import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/app/utils/helpers.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';
import 'package:speedest_logistics/profile/data/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  yieldUser(UserModel user) {
    emit(ProfileLoaded(user));
  }

  updateAvailabity() {}

  updateInfos({
    String? name,
    String? phone,
    bool? isAvailable,
    bool? isDriver,
    bool? online,
  }) async {
    try {
      emit(UpdateProfileLoading(state.user!));
      var user = await profileRepository.updateProfile(
        userId: state.user!.id,
        name: name,
        availability: isAvailable,
        online: online,
      );
      emit(UpdateProfileSuccess(user));
    } catch (e) {
      emit(UpdateProfileFailure(state.user!, Helpers.extractErrorMessage(e)));
    }
  }
}
