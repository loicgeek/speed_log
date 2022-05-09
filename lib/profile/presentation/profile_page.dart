import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/locator.dart';
import '../business_logic/profile_cubit/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      minRadius: 35,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.user!.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(RoutePath.editProfile);
                  },
                  title: const Text("Edit Profile"),
                  trailing: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(RoutePath.parcelsSent);
                  },
                  title: const Text("Parcels Sent"),
                  trailing: Transform.rotate(
                    angle: -pi / 4,
                    child: const Icon(
                      Icons.send,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(RoutePath.parcelsDelivered);
                  },
                  title: const Text("Parcels Delivered"),
                  trailing: Transform.rotate(
                    angle: -pi / 4,
                    child: const Icon(
                      Icons.send,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () async {
                    await context.read<ApplicationCubit>().logout();
                  },
                  title: const Text("Logout"),
                  trailing: const Icon(
                    Icons.logout,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
