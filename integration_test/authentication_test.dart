import 'package:appwrite/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parcel_delivery/app/data/api_client.dart';
import 'package:parcel_delivery/app/presentation/loaders/app_loader.dart';
import 'package:parcel_delivery/app/presentation/widgets/widgets.dart';
import 'package:parcel_delivery/auth/business_logic/login_cubit/login_cubit.dart';
import 'package:parcel_delivery/auth/data/auth_service.dart';
import 'package:parcel_delivery/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late LoginCubit loginCubit;
  late AuthService authService;
  late ApiClient apiClient;
  late String email;
  late String password;

  setUp(() {
    apiClient = ApiClient();
    authService = AuthService(apiClient: apiClient);
    loginCubit = LoginCubit(authService: authService);
    email = "loic.ngou98@gmail.com";
    password = "test1234";
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => loginCubit,
        child: const LoginPage(),
      ),
    );
  }

  group("Authentication end to end test", () {
    testWidgets("Loading indicator is displayed while authenticating user",
        (tester) async {
      // arrangeSuccessfulAuthentication();
      // whenListen(loginCubit,
      //     Stream<LoginState>.fromIterable([LoginLoading(), LoginSucess()]));
      // when(() => loginCubit.state).thenReturn(LoginLoading());
      await tester.pumpWidget(createWidgetUnderTest());

      Finder emailField = find.widgetWithText(TextFormField, "Email");
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      Finder passwordField = find.widgetWithText(TextFormField, "Mot de passe");
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      final Finder buttonConnexion =
          find.widgetWithText(AppButton, 'Se Connecter');
      expect(buttonConnexion, findsOneWidget);

      expect(find.byType(LoaderDialog), findsNothing);
      await tester.tap(buttonConnexion);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(LoaderDialog), findsOneWidget);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
      expect(find.byType(LoaderDialog), findsNothing);

      //  await tester.pumpAndSettle();
    });
  });
}
