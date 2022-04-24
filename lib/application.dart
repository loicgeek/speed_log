import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/presentation/home_page.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/app/utils/collection_ids.dart';
import 'package:speedest_logistics/auth/business_logic/login_cubit/login_cubit.dart';
import 'package:speedest_logistics/locator.dart';

import 'app/business_logic/cubit/application_cubit.dart';
import 'auth/data/auth_service.dart';
import 'auth/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile/business_logic/profile_cubit/profile_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ApplicationCubit(authService: locator.get<AuthService>())
                ..checkAuthState(),
        ),
        BlocProvider(
          create: (context) => locator.get<ProfileCubit>(),
        ),
      ],
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
        builder: (context, state) {
          Widget homePage = Center(child: AppLoader.ballClipRotateMultiple());

          if (state is AuthenticationAuthenticated) {
            homePage = const HomePage();
            context.read<ProfileCubit>().yieldUser(state.user!);
          } else if (state is AuthenticationUnauthenticated) {
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
              fontFamily: "Comfortaa",
              primarySwatch: AppColors.createMaterialColor(AppColors.primary),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: AppColors.primary,
                ),
              ),
            ),
            home: homePage,
          );
        },
      ),
    );
  }
}
