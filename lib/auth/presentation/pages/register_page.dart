import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';
import 'package:speedest_logistics/app/presentation/theme/theme.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/auth/business_logic/register_cubit/register_cubit.dart';
import 'package:speedest_logistics/auth/data/auth_service.dart';
import 'package:speedest_logistics/locator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController;
  late AuthService _accountService;
  String? error;

  bool isLoading = false;
  final LoaderController _loader = AppLoader.bounce();

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _accountService = locator.get<AuthService>();
    super.initState();
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Creer un Compte"),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              _loader.open(context);
            } else if (state is RegisterFailure) {
              _loader.close().then((value) {
                AppSnackbars.showError(context, message: state.message);
              });
            } else if (state is RegisterSucess) {
              _loader.close().then((value) {
                context
                    .read<ApplicationCubit>()
                    .yieldAuthenticatedUser(state.user);
              });
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     vertical: 20.0,
                    //     horizontal: 10,
                    //   ),
                    //   child: Text("Apprenons à mieux vous connaître"),
                    // ),
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
                      controller: _firstNameController,
                      label: "Nom",
                      placeholder: "Entez votre nom",
                    ),

                    AppInput(
                      controller: _emailController,
                      label: "Email",
                      placeholder: "Entez email address",
                      validator: (value) {
                        return Validators.required("Email", value);
                      },
                    ),
                    AppInput(
                      controller: _phoneController,
                      label: "Phone",
                      placeholder: "Enter phone",
                      validator: (value) {
                        return Validators.required("Phone", value);
                      },
                    ),
                    AppInput(
                      controller: _passwordController,
                      label: "Password",
                      placeholder: "Entrez votre mot de passe",
                      validator: (value) {
                        return Validators.required("Password", value);
                      },
                      obscureText: true,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: screenHeight * .05,
                    ),
                    if (isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppLoader.ballClipRotateMultiple(),
                        ),
                      ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          error!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    AppButton(
                      text: "Create Account",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          context.read<RegisterCubit>().attemptRegister(
                                name: _firstNameController.text,
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                phone: _phoneController.text.trim(),
                              );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: RichText(
                        text: const TextSpan(
                          text: "Vous avez deja un compte? ",
                          style: TextStyle(
                            color: AppColors.primaryGrayText,
                          ),
                          children: [
                            TextSpan(
                              text: "Se connecter ",
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
