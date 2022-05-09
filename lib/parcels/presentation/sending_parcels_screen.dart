import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';
import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';

class SendingParcelsScreen extends StatefulWidget {
  const SendingParcelsScreen({Key? key}) : super(key: key);

  @override
  State<SendingParcelsScreen> createState() => _SendingParcelsScreenState();
}

class _SendingParcelsScreenState extends State<SendingParcelsScreen> {
  late DeliveryRepository _deliveryRepository;
  late UserModel user;
  late Future<List<Parcel>> future;
  late Future<List<Parcel>> myParcelsfuture;
  @override
  void initState() {
    _deliveryRepository = locator.get<DeliveryRepository>();
    user = context.read<ProfileCubit>().state.user!;

    setFuture();
    setMyParcelsFuture();
    super.initState();
  }

  setFuture() {
    future =
        _deliveryRepository.find(notSenderId: user.id, status: ["waiting"]);
  }

  setMyParcelsFuture() {
    myParcelsfuture = _deliveryRepository
        .find(senderId: user.id, status: ["waiting", "started", 'ongoing']);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Parcels "),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              text: "Waiting",
            ),
            Tab(
              text: "My Parcels",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Parcel>>(
              future: future,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Parcel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppLoader.ballClipRotateMultiple());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () {
                      setFuture();
                      setState(() {});
                      return future;
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Parcel p = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                RoutePath.parcelDetails,
                                arguments: {"id": p.id},
                              );
                            },
                            trailing: Column(
                              children: [
                                Text("${p.weight} kg"),
                                Expanded(
                                  child: Chip(
                                    label: Text(
                                      p.status,
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                    labelPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(child: Text(p.title)),
                              ],
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${p.fromName} - ${p.toName}"),
                                Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                                    .format(p.createdAt))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
            FutureBuilder<List<Parcel>>(
              future: myParcelsfuture,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Parcel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppLoader.ballClipRotateMultiple());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () {
                      setMyParcelsFuture();
                      setState(() {});
                      return future;
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Parcel p = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                RoutePath.parcelDetails,
                                arguments: {"id": p.id},
                              );
                            },
                            trailing: Column(
                              children: [
                                Text("${p.weight} kg"),
                                Expanded(
                                  child: Chip(
                                    label: Text(
                                      p.status,
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                    labelPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(child: Text(p.title)),
                              ],
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${p.fromName} - ${p.toName}"),
                                Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                                    .format(p.createdAt))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
