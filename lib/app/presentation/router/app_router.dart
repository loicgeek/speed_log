import 'package:flutter/material.dart';
import 'package:test_app_write/auth/presentation/pages/login_page.dart';
import 'package:test_app_write/auth/presentation/pages/register_page.dart';
import 'package:test_app_write/chat/presentation/users_list.dart';

import './route_path.dart';

class AppRouter {
  static MaterialPageRoute createRoute(
    Widget page, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return createRoute(const LoginPage());
      case RoutePath.register:
        return createRoute(const RegisterPage());
      case RoutePath.usersList:
        return createRoute(const UsersList());

      default:
        return null;
    }
  }
}
