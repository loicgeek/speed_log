import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:parcel_delivery/app/utils/utils.dart';
import 'package:parcel_delivery/auth/data/auth_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService authService;
  RegisterCubit({required this.authService}) : super(RegisterPending());

  attemptRegister({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(RegisterLoading());

      await authService.register(email: email, password: password, name: name);
      emit(RegisterSucess());
    } catch (e) {
      emit(RegisterFailure(Helpers.extractErrorMessage(e)));
    }
  }
}
