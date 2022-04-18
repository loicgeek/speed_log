import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:parcel_delivery/app/presentation/router/router.dart';
import 'package:parcel_delivery/app/presentation/theme/theme.dart';
import 'package:parcel_delivery/app/presentation/widgets/widgets.dart';
import 'package:parcel_delivery/auth/data/auth_service.dart';
import 'package:parcel_delivery/locator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController;
  late AuthService _accountService;
  String? error;

  bool isLoading = false;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              children: [
                // const Padding(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 20.0,
                //     horizontal: 10,
                //   ),
                //   child: Text("Apprenons à mieux vous connaître"),
                // ),

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
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
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
                      try {
                        setState(() {
                          isLoading = true;
                          error = null;
                        });
                        var user = await _accountService.register(
                          name: _firstNameController.text,
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pushNamed(RoutePath.usersList);
                      } on AppwriteException catch (e) {
                        setState(() {
                          isLoading = false;
                          error = e.message;
                        });
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                          e.toString();
                        });
                      }
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
        ),
      ),
    );
  }
}
