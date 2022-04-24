import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';

import '../business_logic/profile_cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool isAvailable = false;
  bool isDriver = false;

  @override
  void initState() {
    var user = context.read<ProfileCubit>().state.user!;

    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    isAvailable = user.isAvailable;
    isDriver = user.isDriver;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            AppSnackbars.showSucess(context, message: "Profile updated");
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              AppInput(controller: _nameController, label: "Name"),
              AppInput(controller: _phoneController, label: "Phone"),
              const SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Become a driver ?"),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text(
                            "Yes",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: true,
                          groupValue: isDriver,
                          onChanged: (value) {
                            setState(() {
                              isDriver = true;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: const Text(
                            "No",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: false,
                          groupValue: isDriver,
                          onChanged: (value) {
                            setState(() {
                              isDriver = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isDriver == true) const SizedBox(height: 20),
              if (isDriver == true)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Are you available now ?"),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: const Text(
                              "Yes",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: true,
                            groupValue: isAvailable,
                            onChanged: (value) {
                              setState(() {
                                isAvailable = true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text(
                              "No",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: false,
                            groupValue: isAvailable,
                            onChanged: (value) {
                              setState(() {
                                isAvailable = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (state is UpdateProfileLoading)
                Center(child: AppLoader.ballClipRotateMultiple()),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
                  text: "Save",
                  onTap: () {
                    context.read<ProfileCubit>().updateInfos(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          isAvailable: isAvailable,
                          isDriver: isDriver,
                        );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
