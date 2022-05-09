import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';
import 'package:speedest_logistics/app/presentation/widgets/widgets.dart';
import 'package:speedest_logistics/app/utils/helpers.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';
import 'package:speedest_logistics/background_location_handler.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';
import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';

class ScanParcelQrCodeScreen extends StatefulWidget {
  const ScanParcelQrCodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanParcelQrCodeScreen> createState() => _ScanParcelQrCodeScreenState();
}

class _ScanParcelQrCodeScreenState extends State<ScanParcelQrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  late TextEditingController _codeController;
  late DeliveryRepository _deliveryRepository;
  late UserModel user;
  Parcel? parcel;
  bool _isLoading = false;
  bool _isManual = false;
  @override
  void initState() {
    _deliveryRepository = locator.get<DeliveryRepository>();
    user = context.read<ProfileCubit>().state.user!;
    _codeController = TextEditingController();
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      completeDelivery(scanData.code);
    });
  }

  completeDelivery(String code) async {
    if (_isLoading == false) {
      setState(() {
        _isLoading = true;
      });
      try {
        parcel = await _deliveryRepository.findOne(code);

        if (parcel!.deliveryManId != user.id) {
          AppSnackbars.showError(context,
              message: 'You are not authorized to scan this code');
          return;
        }

        await _deliveryRepository.update(
            parcelId: parcel!.id, status: "completed");
        BackgroundLocationHandler.stopLocationService();
        setState(() {
          _isLoading = false;
        });
        AppSnackbars.showSucess(context, message: "Code scanned");
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        AppSnackbars.showError(context,
            message: Helpers.extractErrorMessage(e));
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Parcel QrCode"),
        centerTitle: true,
      ),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    var scanArea = MediaQuery.of(context).size.width * .7;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isManual = !_isManual;
            });
          },
          child: Text(_isManual ? "Sccan Qr code" : "Enter code manually"),
        ),
        if (_isManual == false)
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
              //   onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppInput(
                      controller: _codeController,
                      label: "Enter code",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                    text: "Sumit",
                    onTap: () {
                      completeDelivery(_codeController.text);
                    },
                  ),
                )
              ],
            ),
          )
        ]
      ],
    );
  }
}
