import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/parcels/business_logic/parcel_details/parcel_details_cubit.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

const kTileHeight = 50.0;

class PackageDeliveryTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.read<ProfileCubit>().state.user!;

    return BlocBuilder<ParcelDetailsCubit, ParcelDetailsState>(
      builder: (context, state) {
        Parcel p = state.parcel!;
        return Card(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      p.cityName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      DateFormat.yMEd().format(p.createdAt),
                      style: const TextStyle(
                        color: Color(0xffb6b2b2),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FixedTimeline(
                  theme: TimelineThemeData(
                    nodePosition: 0,
                    color: Color(0xff989898),
                    indicatorTheme: IndicatorThemeData(
                      position: 0,
                      size: 20.0,
                      color: AppColors.primary,
                    ),
                    connectorTheme: ConnectorThemeData(
                      thickness: 1.5,
                      color: AppColors.black,
                    ),
                  ),
                  children: [
                    TimelineTile(
                      contents: Card(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.senderName),
                              Text(p.fromName),
                              Text(p.fromDescription),
                              Text(p.description),
                            ],
                          ),
                        ),
                      ),
                      node: const TimelineNode(
                        indicator: OutlinedDotIndicator(),
                        startConnector: SolidLineConnector(),
                        endConnector: SolidLineConnector(),
                      ),
                    ),
                    TimelineTile(
                      nodeAlign: TimelineNodeAlign.basic,
                      contents: Card(
                        color: AppColors.primary,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            p.status,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      node: const TimelineNode(
                        indicator: OutlinedDotIndicator(
                          color: AppColors.primary,
                        ),
                        startConnector: SolidLineConnector(),
                        endConnector: SolidLineConnector(),
                      ),
                    ),
                    TimelineTile(
                      nodeAlign: TimelineNodeAlign.basic,
                      contents: Card(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.receiverName),
                              Text(p.receiverPhone),
                              Text(p.toName),
                              Text(p.toDescription),
                            ],
                          ),
                        ),
                      ),
                      node: const TimelineNode(
                        indicator: OutlinedDotIndicator(),
                        startConnector: SolidLineConnector(),
                        endConnector: SolidLineConnector(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0),
              if (p.deliveryManId != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          launchUrl(Uri.parse("tel:${p.deliveryManPhone}"));
                        },
                        elevation: 0,
                        shape: StadiumBorder(),
                        color: Color(0xff66c97f),
                        textColor: Colors.white,
                        child: Text('Call'),
                      ),
                      Spacer(),
                      Text(
                        'Driver\n${p.deliveryManName}',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 12.0),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              if (p.deliveryManId == user.id)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          launchUrl(Uri.parse("tel:${p.receiverPhone}"));
                        },
                        elevation: 0,
                        shape: StadiumBorder(),
                        color: Color(0xff66c97f),
                        textColor: Colors.white,
                        child: Text('Call'),
                      ),
                      Spacer(),
                      Text(
                        'Receiver \n${p.receiverName}',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 12.0),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
