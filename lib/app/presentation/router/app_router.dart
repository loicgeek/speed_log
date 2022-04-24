import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/presentation/home_page.dart';
import 'package:speedest_logistics/auth/business_logic/login_cubit/login_cubit.dart';
import 'package:speedest_logistics/auth/business_logic/register_cubit/register_cubit.dart';
import 'package:speedest_logistics/auth/data/auth_service.dart';
import 'package:speedest_logistics/auth/presentation/pages/login_page.dart';
import 'package:speedest_logistics/auth/presentation/pages/register_page.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/business_logic/cubit/send_parcel_cubit.dart';
import 'package:speedest_logistics/parcels/business_logic/parcel_details/parcel_details_cubit.dart';
import 'package:speedest_logistics/parcels/data/models/city.dart';
import 'package:speedest_logistics/parcels/data/models/quarter.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';
import 'package:speedest_logistics/parcels/presentation/parcel_details_screen.dart';
import 'package:speedest_logistics/parcels/presentation/scan_parcel_qrcode_screen.dart';
import 'package:speedest_logistics/parcels/presentation/send_parcel_screen.dart';
import 'package:speedest_logistics/parcels/presentation/show_parcel_qrcode_screen.dart';
import 'package:speedest_logistics/profile/presentation/edit_profile_screen.dart';
import 'package:speedest_logistics/profile/presentation/parcels_sent_screen.dart';
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
        return createRoute(
          BlocProvider(
            create: (context) =>
                LoginCubit(authService: locator.get<AuthService>()),
            child: const LoginPage(),
          ),
        );
      case RoutePath.register:
        return createRoute(
          BlocProvider(
            create: (context) =>
                RegisterCubit(authService: locator.get<AuthService>()),
            child: const RegisterPage(),
          ),
        );
      case RoutePath.home:
        return createRoute(const HomePage());
      case RoutePath.scanParcelQrCodeScreen:
        return createRoute(const ScanParcelQrCodeScreen());
      case RoutePath.sendParcel:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        City city = arguments['city'] as City;
        Quarter from = arguments['from'] as Quarter;
        Quarter to = arguments['to'] as Quarter;

        return createRoute(
          BlocProvider(
            create: (context) =>
                SendParcelCubit(locator.get<DeliveryRepository>())
                  ..startParcel(city: city, from: from, to: to),
            child: const SendParcelScreen(),
          ),
        );

      case RoutePath.editProfile:
        return createRoute(const EditProfileScreen());
      case RoutePath.parcelsSent:
        return createRoute(const ParcelsSentScreen());
      case RoutePath.parcelDetails:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        String id = arguments['id'] as String;

        return createRoute(
          BlocProvider(
            create: (context) => ParcelDetailsCubit(
                repository: locator.get<DeliveryRepository>(), parcelId: id)
              ..loadDetails(),
            child: const ParcelDetailsScreen(),
          ),
        );

      case RoutePath.showParcelQrCodeScreen:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        String id = arguments['id'] as String;

        return createRoute(
          BlocProvider(
            create: (context) => ParcelDetailsCubit(
                repository: locator.get<DeliveryRepository>(), parcelId: id),
            child: ShowParcelQrCodeScreen(id: id),
          ),
        );

      default:
        return null;
    }
  }
}
