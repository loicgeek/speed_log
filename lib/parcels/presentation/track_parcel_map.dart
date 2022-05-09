import 'dart:async';
import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/app/utils/collection_ids.dart';
import 'package:speedest_logistics/app/utils/database_events.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';
import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';
import 'package:speedest_logistics/profile/data/profile_repository.dart';

class TrackParcelMap extends StatefulWidget {
  String? parcelId;
  TrackParcelMap({
    Key? key,
    this.parcelId,
  }) : super(key: key);

  @override
  _TrackParcelMapState createState() => _TrackParcelMapState();
}

class _TrackParcelMapState extends State<TrackParcelMap> {
  late MapController _controller;
  late TextEditingController _codeController;

  late DeliveryRepository _deliveryRepository;
  late UserModel user;
  Parcel? parcel;
  bool _isLoading = false;
  bool _isManual = false;
  List<Marker> _markers = [];
  LatLng? _center;

  RealtimeSubscription? deliverymanStream;
  UserModel? deliveryMan;

  @override
  void initState() {
    _controller = MapController();
    _deliveryRepository = locator.get<DeliveryRepository>();
    user = context.read<ProfileCubit>().state.user!;
    _codeController = TextEditingController();
    if (widget.parcelId != null) {
      _codeController.text = widget.parcelId!;
      _onTrack(widget.parcelId!);
    }
    super.initState();
  }

  watchParcelLocation(String userId) async {
    try {
      var profileRepository = locator.get<ProfileRepository>();
      var user = await profileRepository.getUser(userId);
      setState(() {
        _controller.move(LatLng(user.latitude!, user.longitude!), 5);
        _markers = [
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(user.latitude!, user.longitude!),
            builder: (ctx) => Icon(FontAwesome5.user),
          ),
        ];
      });
    } catch (e) {}
    deliverymanStream = _deliveryRepository.apiClient.realtime
        .subscribe(["collections.${CollectionIds.users}.documents"]);
    deliverymanStream!.stream.listen((event) {
      if (event.event == DatabaseEvents.documentUpdated) {
        var result = UserModel.fromJson(event.payload);
        print(result);

        if (result.id == userId) {
          deliveryMan = result;
          if (mounted) {
            setState(() {
              _center = LatLng(deliveryMan!.latitude!, deliveryMan!.longitude!);
              _controller.move(_center!, 25);
              _markers = [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point:
                      LatLng(deliveryMan!.latitude!, deliveryMan!.longitude!),
                  builder: (ctx) => Icon(FontAwesome5.user),
                ),
              ];
            });
          }
        } else {
          print("not the correct user");
        }
      }
    });
  }

  cancelWatch() {
    deliverymanStream?.close();
  }

  _onTrack(String parcelId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var p = await _deliveryRepository.findOne(parcelId);

      print(p);
      if (p.deliveryManId != null) {
        watchParcelLocation(p.deliveryManId!);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (deliveryMan != null) {
      _center = LatLng(deliveryMan!.latitude!, deliveryMan!.longitude!);
      _markers = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(deliveryMan!.latitude!, deliveryMan!.longitude!),
          builder: (ctx) => Icon(FontAwesome5.user),
        ),
      ];
    }
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: _center,
              zoom: 13.0,
              plugins: [],
            ),
            mapController: _controller,
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return const Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: _markers,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        controller: _codeController,
                        label: "Enter code to track",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                        text: "GO",
                        onTap: () async {
                          _onTrack(_codeController.text.trim());
                        },
                      ),
                    ),
                  ],
                ),
                if (_isLoading) AppLoader.ballClipRotateMultiple(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
