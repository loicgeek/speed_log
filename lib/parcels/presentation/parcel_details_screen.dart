import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:intl/intl.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/route_path.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';
import 'package:speedest_logistics/parcels/presentation/track_parcel_map.dart';
import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';

import '../business_logic/parcel_details/parcel_details_cubit.dart';
import 'parcel_details_content.dart';

class ParcelDetailsScreen extends StatefulWidget {
  const ParcelDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ParcelDetailsScreen> createState() => _ParcelDetailsScreenState();
}

class _ParcelDetailsScreenState extends State<ParcelDetailsScreen> {
  late TextEditingController _offerController;
  late UserModel user;
  @override
  void initState() {
    _offerController = TextEditingController();
    user = context.read<ProfileCubit>().state.user!;
    super.initState();
  }

  Widget _buildSendOfferForm() {
    return BlocListener<ParcelDetailsCubit, ParcelDetailsState>(
      listener: (context, state) {
        if (state is LoadParcelDetailsSucess) {
          _offerController.clear();
        }
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppInput(
                  controller: _offerController,
                  label: "make offer",
                  textInputType: const TextInputType.numberWithOptions(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                text: "send",
                onTap: () {
                  context
                      .read<ParcelDetailsCubit>()
                      .sendOffer(
                        amount: int.parse(_offerController.text),
                        username: user.name,
                        userId: user.id,
                        phone: user.phone,
                      )
                      .then((value) {
                    if (value != null) {
                      context
                          .read<ParcelDetailsCubit>()
                          .sendOfferNotification(value);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildOffersList() {
    return BlocBuilder<ParcelDetailsCubit, ParcelDetailsState>(
      builder: (context, state) {
        if (state.offers == null) {
          return Center(child: AppLoader.ballClipRotateMultiple());
        }

        if (state.offers!.isEmpty) {
          return Center(
            child: Column(
              children: [
                _buildSendOfferForm(),
                const Text("No offers found"),
              ],
            ),
          );
        }
        var offers = [...state.offers!];
        offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return Column(
          children: [
            _buildSendOfferForm(),
            Expanded(
              child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  var offer = offers[index];
                  return Card(
                    child: ListTile(
                      trailing: Column(
                        children: [
                          Text(
                            "${offer.amount} XAF",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (state.parcel!.status == "waiting" &&
                              state.parcel!.senderId == user.id)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<ParcelDetailsCubit>()
                                      .acceptOffer(offer);
                                },
                                child: const Chip(
                                  backgroundColor: Colors.green,
                                  label: Text("Accept"),
                                ),
                              ),
                            )
                          else if (offer.status == "accepted")
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Chip(
                                  backgroundColor: Colors.lightGreenAccent,
                                  label: Text(offer.status),
                                ),
                              ),
                            )
                        ],
                      ),
                      subtitle: Text(offer.username),
                      title: Text(
                        DateFormat("y/MM/d h:mm a").format(offer.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParcelDetailsCubit, ParcelDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        print(state.parcel);
        if (state.parcel != null) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(state.parcel!.title),
                  bottom: const TabBar(tabs: [
                    Tab(
                      text: "Details",
                    ),
                    Tab(
                      text: "Offers",
                    ),
                  ]),
                ),
                body: TabBarView(
                  children: [
                    PackageDeliveryTrackingPage(),
                    _buildOffersList(),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: _buildFAB(state)),
          );
        }
        if (state is LoadParcelDetailsLoading && state.parcel == null) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Loading ...'),
              ),
              body: Center(child: AppLoader.ballClipRotateMultiple()));
        } else if (state is LoadParcelDetailsFailure) {
          return Scaffold(
            appBar: AppBar(
              title: Text('An error occured'),
            ),
            body: Column(
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ParcelDetailsCubit>().loadDetails();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget? _buildFAB(ParcelDetailsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (state.parcel!.status == "started")
          FloatingActionButton(
            key: const ValueKey("track parcel"),
            onPressed: () {
              Navigator.of(context).push(
                AppRouter.createRoute(
                  TrackParcelMap(
                    parcelId: state.parcel!.id,
                  ),
                ),
              );
            },
            tooltip: 'QrCode',
            child: const Icon(MaterialCommunityIcons.map),
          ),
        if (state.parcel!.senderId == user.id)
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutePath.showParcelQrCodeScreen,
                  arguments: {"id": state.parcel!.id});
            },
            tooltip: 'QrCode',
            child: const Icon(MaterialCommunityIcons.barcode),
          ),
        if (state.parcel!.deliveryManId == user.id)
          if (state.parcel!.status == 'started')
            FloatingActionButton.extended(
              label: const Text("Started"),
              onPressed: () async {},
              tooltip: 'Start ',
              icon: const Icon(MaterialCommunityIcons.car),
            )
          else
            FloatingActionButton.extended(
              label: const Text("Start"),
              onPressed: () async {
                await context
                    .read<ParcelDetailsCubit>()
                    .startDelivery(state.parcel!.id);
              },
              tooltip: 'Start ',
              icon: const Icon(MaterialCommunityIcons.car),
            )
      ],
    );
  }
}
