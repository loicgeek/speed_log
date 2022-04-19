import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/presentation/home_page.dart';
import 'package:speedest_logistics/auth/presentation/pages/login_page.dart';
import 'package:speedest_logistics/auth/presentation/pages/register_page.dart';
import 'package:speedest_logistics/parcels/business_logic/cubit/send_parcel_cubit.dart';
import 'package:speedest_logistics/parcels/data/models/city.dart';
import 'package:speedest_logistics/parcels/data/models/quarter.dart';
import 'package:speedest_logistics/parcels/presentation/send_parcel_screen.dart';
import './route_path.dart';

class AppRouter {
  static PageRouteBuilder createRoute(Widget page,
      {RouteSettings? settings,
      bool maintainState = true,
      bool fullscreenDialog = false,
      Curve curved = Curves.easeInOut}) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curved);

        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                  .animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return createRoute(const LoginPage());
      case RoutePath.register:
        return createRoute(const RegisterPage());
      case RoutePath.home:
        return createRoute(const HomePage());
      case RoutePath.sendParcel:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        City city = arguments['city'] as City;
        Quarter from = arguments['from'] as Quarter;
        Quarter to = arguments['to'] as Quarter;

        return createRoute(
          BlocProvider(
            create: (context) =>
                SendParcelCubit()..startParcel(city: city, from: from, to: to),
            child: const SendParcelScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
