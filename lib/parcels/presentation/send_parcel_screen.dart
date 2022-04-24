import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedest_logistics/app/business_logic/cubit/application_cubit.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/business_logic/cubit/send_parcel_cubit.dart';

class SendParcelScreen extends StatefulWidget {
  const SendParcelScreen({Key? key}) : super(key: key);

  @override
  State<SendParcelScreen> createState() => _SendParcelScreenState();
}

class _SendParcelScreenState extends State<SendParcelScreen> {
  late TextEditingController fromDetails;
  late TextEditingController toDetails;
  late TextEditingController description;
  late TextEditingController title;
  late TextEditingController weightController;
  late TextEditingController receiverName;
  late TextEditingController receiverPhone;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    fromDetails = TextEditingController();
    toDetails = TextEditingController();
    title = TextEditingController();
    description = TextEditingController();
    weightController = TextEditingController();
    receiverName = TextEditingController();
    receiverPhone = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocConsumer<SendParcelCubit, SendParcelState>(
        listener: (context, state) {
          if (state is SendParcelSucess) {
            Navigator.of(context).pop(true);
          } else if (state is SendParcelFailure) {
            AppSnackbars.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: state.city == null
                  ? Container()
                  : Form(
                      key: _formKey,
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Departure',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${state.city!.name} - ${state.from!.name}",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.location_searching,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 50,
                                      color: Colors.red,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Arrival',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${state.city!.name} - ${state.to!.name}",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.location_searching,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            constraints: const BoxConstraints(minHeight: 200),
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    AppInput(
                                      controller: fromDetails,
                                      label: "Picking location details",
                                    ),
                                    AppInput(
                                      controller: toDetails,
                                      label: "Shipping location details",
                                    ),
                                    AppInput(
                                      controller: title,
                                      label: "Title ",
                                    ),
                                    AppInput(
                                      controller: description,
                                      label: "Describe your parcel",
                                      minLines: 4,
                                    ),
                                    AppInput(
                                      controller: weightController,
                                      label: "Approximative weight(kg)",
                                      textInputType: const TextInputType
                                          .numberWithOptions(),
                                    ),
                                    AppInput(
                                      controller: receiverName,
                                      label: "Receiver name",
                                    ),
                                    AppInput(
                                      controller: receiverPhone,
                                      label: "Receiver phone",
                                      textInputType: const TextInputType
                                          .numberWithOptions(),
                                    ),
                                    const SizedBox(height: 30),
                                    if (state is SendParcelLoading) ...[
                                      Center(
                                          child: AppLoader
                                              .ballClipRotateMultiple()),
                                    ],
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          var sendParcelCuit =
                                              context.read<SendParcelCubit>();

                                          var user = context
                                              .read<ApplicationCubit>()
                                              .state
                                              .user!;

                                          sendParcelCuit.sendParcel(
                                            fromDetails: fromDetails.text,
                                            toDetails: toDetails.text,
                                            description: description.text,
                                            title: title.text,
                                            weight: num.parse(
                                                weightController.text),
                                            senderId: user.id,
                                            senderName: user.name,
                                            receiverName: receiverName.text,
                                            receiverPhone: receiverPhone.text,
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Center(
                                            child: Text(
                                              'Send',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.pinkAccent,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
