import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';
import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';

class TrackParcel extends StatefulWidget {
  const TrackParcel({Key? key}) : super(key: key);

  @override
  State<TrackParcel> createState() => _TrackParcelState();
}

class _TrackParcelState extends State<TrackParcel> {
  late DeliveryRepository _deliveryRepository;
  late UserModel user;
  late Future<List<Parcel>> future;
  late TextEditingController _parcelCodeController;
  @override
  void initState() {
    _deliveryRepository = locator.get<DeliveryRepository>();
    user = context.read<ProfileCubit>().state.user!;
    _parcelCodeController = TextEditingController();
    setFuture();

    super.initState();
  }

  setFuture() {
    future =
        _deliveryRepository.find(status: ["waiting"], notSenderId: user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Offer"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AppInput(
            controller: _parcelCodeController,
            label: "Enter parcel code to track",
          ),
          SizedBox(height: 20),
          AppButton(text: "Track")
        ],
      ),
    );
  }
}
