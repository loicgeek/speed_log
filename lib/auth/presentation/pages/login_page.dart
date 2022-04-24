import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
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
            _loader.close().then((value) {
              context
                  .read<ApplicationCubit>()
                  .yieldAuthenticatedUser(state.user);
            });
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
                    Image.asset(
                      "assets/images/speed_log_ver.png",
                      height: 150,
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
                      textInputType: TextInputType.emailAddress,
                    ),
                    AppInput(
                      controller: _passwordController,
                      label: "Mot de passe",
                      placeholder: "Entez votre mot de passe",
                      validator: (value) {
                        return Validators.required("Mot de passe", value);
                      },
                      maxLines: 1,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight * .05,
                    ),
                    if (state is LoginFailure) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
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
