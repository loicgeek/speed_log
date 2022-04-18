import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parcel_delivery/app/data/api_client.dart';
import 'package:parcel_delivery/auth/business_logic/login_cubit/login_cubit.dart';
import 'package:parcel_delivery/auth/data/auth_service.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;
    late String email;
    late String password;
    late AuthService authService;

    setUp(() {
      authService = MockAuthService();
      loginCubit = LoginCubit(authService: authService);
      email = "loic.ngou98@gmail.com";
      password = "test1234";
    });

    test('initial state is LoginPending', () {
      expect(loginCubit.state, isA<LoginPending>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading,LoginSuccess] when user input corrects creds.',
      build: () => loginCubit,
      setUp: () {
        when<Future<Session>>(
                () => authService.login(email: email, password: password))
            .thenAnswer((_) {
          return Future.value(Session(
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
          ));
        });
      },
      act: (bloc) => bloc.attemptLogin(email: email, password: password),
      expect: () => [isA<LoginLoading>(), isA<LoginSucess>()],
    );
    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading,LoginFailure] when user input incorrect creds.',
      build: () => loginCubit,
      setUp: () {
        when<Future<Session>>(
                () => authService.login(email: email, password: password))
            .thenThrow(AppwriteException());
      },
      act: (bloc) => bloc.attemptLogin(email: email, password: password),
      expect: () => [isA<LoginLoading>(), isA<LoginFailure>()],
      // errors: () => [AppwriteException()],
    );
  });
}
