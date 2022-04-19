import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/parcels/business_logic/cubit/send_parcel_cubit.dart';

class SendParcelScreen extends StatefulWidget {
  const SendParcelScreen({Key? key}) : super(key: key);

  @override
  State<SendParcelScreen> createState() => _SendParcelScreenState();
}

class _SendParcelScreenState extends State<SendParcelScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocConsumer<SendParcelCubit, SendParcelState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    children: [
                      BackButton(),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/speed_log_ver.png",
                      height: 130,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text('Departure'),
                            Text(state.city!.name),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
