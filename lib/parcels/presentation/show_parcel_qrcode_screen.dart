import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';

class ShowParcelQrCodeScreen extends StatefulWidget {
  final String id;
  const ShowParcelQrCodeScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowParcelQrCodeScreen> createState() => _ShowParcelQrCodeScreenState();
}

class _ShowParcelQrCodeScreenState extends State<ShowParcelQrCodeScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcel Code"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Copy this code or share this image with your receiver",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text(widget.id)),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: widget.id));
                      AppSnackbars.showSucess(context,
                          message: "Text copied to clipboard");
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: QrImage(
                data: widget.id,
                version: QrVersions.auto,
                size: MediaQuery.of(context).size.width * .7,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          screenshotController.capture().then((Uint8List? image) async {
            await Share.file(
                'share Parcel Coled', '${widget.id}.jpg', image!, 'image/jpg');
            //Capture Done
          }).catchError((error) {
            print(error);
          });
        },
        label: Text("Share"),
        icon: const Icon(
          FontAwesome.share,
        ),
      ),
    );
  }
}
