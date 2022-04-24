import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/parcels/business_logic/parcel_details/parcel_details_cubit.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class PackageDeliveryTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = _data(1);

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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('On-time!'),
                            ),
                          );
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
            ],
          ),
        );
      },
    );
  }
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({
    Key? key,
    required this.orderInfo,
  }) : super(key: key);

  final _OrderInfo orderInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Delivery #${orderInfo.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          '${orderInfo.date.day}/${orderInfo.date.month}/${orderInfo.date.year}',
          style: TextStyle(
            color: Color(0xffb6b2b2),
          ),
        ),
      ],
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

_OrderInfo _data(int id) => _OrderInfo(
      id: id,
      date: DateTime.now(),
      driverInfo: _DriverInfo(
        name: 'Philipe',
        thumbnailUrl:
            'https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg',
      ),
      deliveryProcesses: [
        _DeliveryProcess(
          'Package Process',
          messages: [
            _DeliveryMessage('8:30am', 'Package received by driver'),
            _DeliveryMessage('11:30am', 'Reached halfway mark'),
          ],
        ),
        _DeliveryProcess(
          'In Transit',
          messages: [
            _DeliveryMessage('13:00pm', 'Driver arrived at destination'),
            _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
          ],
        ),
        _DeliveryProcess.complete(),
      ],
    );

class _OrderInfo {
  const _OrderInfo({
    required this.id,
    required this.date,
    required this.driverInfo,
    required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  final _DriverInfo driverInfo;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DriverInfo {
  const _DriverInfo({
    required this.name,
    required this.thumbnailUrl,
  });

  final String name;
  final String thumbnailUrl;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}
