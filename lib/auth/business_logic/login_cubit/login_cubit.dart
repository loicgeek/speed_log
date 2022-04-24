import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/utils/utils.dart';
import 'package:speedest_logistics/auth/data/auth_service.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;
  LoginCubit({
    required this.authService,
  }) : super(LoginPending());

  attemptLogin({
    required String email,
    required String password,
  }) async {
    try {
      emit(LoginLoading());

      var user = await authService.login(email: email, password: password);
      emit(LoginSucess(user));
    } catch (e) {
      print(e);
      emit(LoginFailure(Helpers.extractErrorMessage(e)));
    }
  }
}
