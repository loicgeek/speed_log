import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parcel_delivery/app/data/api_client.dart';
import 'package:parcel_delivery/auth/business_logic/register_cubit/register_cubit.dart';
import 'package:parcel_delivery/auth/data/auth_service.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('RegisterCubit', () {
    late RegisterCubit registerCubit;
    late String email;
    late String password;
    late String name;
    late AuthService authService;

    setUp(() {
      authService = MockAuthService();
      registerCubit = RegisterCubit(authService: authService);
      email = "loic.ngou98@gmail.com";
      password = "test1234";
      name = "NGOU";
    });

    test('initial state is LoginPending', () {
      expect(registerCubit.state, isA<RegisterPending>());
    });

    blocTest<RegisterCubit, RegisterState>(
      'emits [LoginLoading,LoginSuccess] when user input corrects creds.',
      build: () => registerCubit,
      setUp: () {
        when<Future<User>>(() => authService.register(
              email: email,
              password: password,
              name: name,
            )).thenAnswer((_) {
          return Future.value(User(
            $id: "id",
            name: name,
            registration: 34,
            status: true,
            email: email,
            prefs: Preferences(data: {}),
            emailVerification: false,
            passwordUpdate: 3,
          ));
        });
      },
      act: (bloc) => bloc.attemptRegister(
        email: email,
        password: password,
        name: name,
      ),
      expect: () => [isA<RegisterLoading>(), isA<RegisterSucess>()],
    );
    blocTest<RegisterCubit, RegisterState>(
      'emits [LoginLoading,LoginFailure] when user input incorrect creds.',
      build: () => registerCubit,
      setUp: () {
        when<Future<User>>(() => authService.register(
              email: email,
              password: password,
              name: name,
            )).thenThrow(AppwriteException());
      },
      act: (bloc) =>
          bloc.attemptRegister(email: email, password: password, name: name),
      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],
      // errors: () => [AppwriteException()],
    );
  });
}
