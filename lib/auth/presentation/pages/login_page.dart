import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/auth/business_logic/login_cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final LoaderController _loader = AppLoader.bounce();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        centerTitle: true,
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            _loader.open(context);
          } else if (state is LoginFailure) {
            _loader.close().then((value) {
              AppSnackbars.showError(context, message: state.message);
            });
          } else if (state is LoginSucess) {
            _loader.close().then((value) {});
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * .03,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: "Tchoko ",
                        style: TextStyle(
                          fontSize: 37,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .2,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Le  ",
                            style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              letterSpacing: .2,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "\nWay ",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 37,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .03,
                    ),
                    AppInput(
                      controller: _emailController,
                      label: "Email",
                      placeholder: "Entez votre addresse mail",
                      validator: (value) {
                        return Validators.required("Email", value);
                      },
                    ),
                    AppInput(
                      controller: _passwordController,
                      label: "Mot de passe",
                      placeholder: "Entez votre mot de passe",
                      validator: (value) {
                        return Validators.required("Mot de passe", value);
                      },
                      obscureText: true,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: screenHeight * .05,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          text: "Se Connecter",
                          bgColor: AppColors.primary,
                          textColor: Colors.white,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().attemptLogin(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                            }
                          },
                        ),
                        AppButton(
                          text: "Creer un compte",
                          bgColor: Colors.black,
                          textColor: Colors.white,
                          onTap: () async {
                            Navigator.of(context).pushNamed(RoutePath.register);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
