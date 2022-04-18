import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parcel_delivery/app/data/api_client.dart';
import 'package:parcel_delivery/app/presentation/home_page.dart';
import 'package:parcel_delivery/app/presentation/loaders/app_loader.dart';
import 'package:parcel_delivery/app/presentation/router/router.dart';
import 'package:parcel_delivery/app/presentation/theme/app_colors.dart';
import 'package:parcel_delivery/app/utils/collection_ids.dart';
import 'package:parcel_delivery/auth/business_logic/login_cubit/login_cubit.dart';
import 'package:parcel_delivery/locator.dart';
import 'app/business_logic/cubit/application_cubit.dart';
import 'auth/data/auth_service.dart';
import 'auth/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    // final usersSubscription = ApiClient.realtime
    //     .subscribe(['collections.${CollectionIds.users}.documents']);

    // usersSubscription.stream.listen((data) {
    //   log(data.event);
    //   log(data.payload.toString());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ApplicationCubit(authService: locator.get<AuthService>())
            ..checkAuthState(),
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
        builder: (context, state) {
          Widget homePage = Center(child: AppLoader.ballClipRotateMultiple());
          if (state.runtimeType == AuthenticationAuthenticated) {
            homePage = const HomePage();
          } else if (state.runtimeType == AuthenticationUnauthenticated) {
            homePage = BlocProvider(
              create: (context) =>
                  LoginCubit(authService: locator.get<AuthService>()),
              child: const LoginPage(),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onGenerateRoute,
            theme: ThemeData(
              primarySwatch: AppColors.createMaterialColor(AppColors.primary),
              appBarTheme: const AppBarTheme(
                elevation: 0,
              ),
            ),
            home: homePage,
          );
        },
      ),
    );
  }
}
