import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/auth/data/auth_service.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  AuthService authService;
  ApplicationCubit({required this.authService})
      : super(AuthenticationPending());

  checkAuthState() async {
    try {
      emit(AuthenticationLoading());
      var user = await authService.getCurrentUser();
      if (user.email.isNotEmpty) {
        emit(AuthenticationAuthenticated(user));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      log(e.toString());
      emit(AuthenticationUnauthenticated());
    }
  }

  yieldAuthenticatedUser(UserModel user) {
    emit(AuthenticationAuthenticated(user));
  }

  logout() async {
    try {
      await authService.logout();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      print(e);
    }
  }
}
