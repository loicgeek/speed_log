import 'package:appwrite/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parcel_delivery/app/presentation/loaders/app_loader.dart';
import 'package:parcel_delivery/app/presentation/widgets/widgets.dart';
import 'package:parcel_delivery/auth/business_logic/login_cubit/login_cubit.dart';
import 'package:parcel_delivery/auth/data/auth_service.dart';
import 'package:parcel_delivery/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late LoginCubit loginCubit;
  late AuthService authService;
  late String email;
  late String password;

  setUp(() {
    authService = MockAuthService();
    loginCubit = MockLoginCubit();
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

  arrangeSuccessfulAuthentication() {
    when<Future<Session>>(
        () => authService.login(email: email, password: password)).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        return Session(
          $id: "id",
          userId: "userId",
          expire: 300,
          provider: 'provider',
          providerUid: "providerUid",
          providerAccessToken: "providerAccessToken",
          providerAccessTokenExpiry: 20,
          providerRefreshToken: "providerRefreshToken",
          ip: "ip",
          osCode: 'osCode',
          osName: "osName",
          osVersion: "osVersion",
          clientType: "clientType",
          clientCode: "clientCode",
          clientName: "clientName",
          clientVersion: "clientVersion",
          clientEngine: "clientEngine",
          clientEngineVersion: "clientEngineVersion",
          deviceName: "deviceName",
          deviceBrand: "deviceBrand",
          deviceModel: "deviceModel",
          countryCode: "countryCode",
          countryName: "countryName",
          current: false,
        );
      },
    );
  }

  group("Login Page", () {
    testWidgets("The email field is required", (tester) async {
      whenListen(loginCubit, Stream<LoginState>.fromIterable([LoginPending()]));
      when(() => loginCubit.state).thenReturn(LoginPending());
      await tester.pumpWidget(createWidgetUnderTest());
      Finder emailField = find.widgetWithText(TextFormField, "Email");
      expect(emailField, findsOneWidget);

      final Finder buttonConnexion =
          find.widgetWithText(AppButton, 'Se Connecter');
      expect(buttonConnexion, findsOneWidget);

      await tester.tap(buttonConnexion);
      await tester.pump();

      expect(find.text("Email est obligatoire"), findsOneWidget);
    });

    testWidgets("The password field is required", (tester) async {
      whenListen(loginCubit, Stream<LoginState>.fromIterable([LoginPending()]));
      when(() => loginCubit.state).thenReturn(LoginPending());
      await tester.pumpWidget(createWidgetUnderTest());

      Finder passwordField = find.widgetWithText(TextFormField, "Mot de passe");
      expect(passwordField, findsOneWidget);

      final Finder buttonConnexion =
          find.widgetWithText(AppButton, 'Se Connecter');
      expect(buttonConnexion, findsOneWidget);

      await tester.tap(buttonConnexion);
      await tester.pump();

      expect(find.text("Mot de passe est obligatoire"), findsOneWidget);
    });
    testWidgets("Loading indicator is displayed while authenticating user",
        (tester) async {
      arrangeSuccessfulAuthentication();
      whenListen(loginCubit,
          Stream<LoginState>.fromIterable([LoginLoading(), LoginSucess()]));
      when(() => loginCubit.state).thenReturn(LoginLoading());
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
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
      expect(find.byType(LoaderDialog), findsOneWidget);

      //  await tester.pumpAndSettle();
    });
  });
}
