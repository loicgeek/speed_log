import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/app/utils/utils.dart';
import 'package:speedest_logistics/auth/data/auth_service.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService authService;
  RegisterCubit({required this.authService}) : super(RegisterPending());

  attemptRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      emit(RegisterLoading());

      var user = await authService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      emit(RegisterSucess(user));
    } catch (e) {
      print(e);
      emit(RegisterFailure(Helpers.extractErrorMessage(e)));
    }
  }
}
