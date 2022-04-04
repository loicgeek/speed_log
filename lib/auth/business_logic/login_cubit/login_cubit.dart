import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_app_write/app/utils/utils.dart';
import 'package:test_app_write/auth/data/auth_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;
  LoginCubit({required this.authService}) : super(LoginPending());

  attemptLogin({
    required String email,
    required String password,
  }) async {
    try {
      emit(LoginLoading());

      await authService.login(email: email, password: password);
      emit(LoginSucess());
    } catch (e) {
      emit(LoginFailure(Helpers.extractErrorMessage(e)));
    }
  }
}
