import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../theme/app_colors.dart';
import 'bounce_loader.dart';

/// App loaders
/// final _loaderDialogController = IndeterminateProgress.bounceLargeColorLoaderController();
/// _loaderDialogController.open(context);
/// _loaderDialogController.close();
//
///
class AppLoader {
  static Widget circular(
      {Color? color, double scale = .7, double strokeWidth = 6}) {
    color ??= AppColors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
            scale: scale,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ))
      ],
    );
  }

  static Widget ballClipRotateMultiple({
    double size = 50,
    Color? color,
    List<Color>? colors,
  }) {
    return Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LoadingIndicator(
              colors: colors,
              indicatorType: Indicator.ballClipRotateMultiple,
              backgroundColor: color,
            ),
          ],
        ));
  }

  static Widget ballRotateChase({
    double size = 50,
    Color color = AppColors.primary,
    List<Color>? colors,
  }) {
    return SizedBox(
      height: size,
      width: size,
      child: LoadingIndicator(
        indicatorType: Indicator.ballRotateChase,
        colors: colors,
      ),
    );
  }

  static Widget bounceLargeColorLoader({double radius = 30.0}) =>
      BounceLargeColorLoader(
        radius: radius,
      );

  static LoaderController bounce() =>
      LoaderController(loader: BounceLargeColorLoader());
}

class LoaderDialog extends StatefulWidget {
  final Widget loader;
  final StreamController<String> controller;
  BuildContext? context;

  /// Create a loader dialog that cannot be
  /// dismissed by pressing the back button.
  LoaderDialog({
    required this.loader,
    required this.controller,
    this.context,
  });

  @override
  _LoaderDialogState createState() => _LoaderDialogState();

  /// Show the dialog loader.
  void open(BuildContext context) {
    this.context = context;
    showDialog(
        context: context, barrierDismissible: false, builder: (ctx) => this);
  }

  void close() {
    if (context != null) {
      if (Navigator.of(context!).canPop()) {
        Navigator.of(context!).pop();
        context = null;
      }
    }
  }
}

class _LoaderDialogState extends State<LoaderDialog> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    widget.controller.stream.listen((event) {
      if (mounted) {
        if (event == 'close' && loading) {
          print("close loader required");
          setState(() {
            loading = false;
          });
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    widget.controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !loading,
      child: Center(
        child: widget.loader,
      ),
    );
  }
}

class LoaderController {
  Widget loader;

  LoaderDialog? _dialog;

  StreamController<String> _streamController = StreamController<String>();
  Completer _completer = Completer();

  LoaderController({required this.loader});

  /// Show the dialog
  void open(BuildContext context) {
    _completer = Completer();
    _streamController = StreamController<String>();
    _dialog = LoaderDialog(loader: loader, controller: _streamController);
    _dialog!.open(context);
  }

  /// Close the dialog
  Future close() async {
    // if (_streamController.isClosed) {
    //   _streamController = StreamController<String>();
    // }
    if (_dialog != null) {
      _dialog!.close();
      _dialog = null;
      _completer.complete();
    }
    return _completer.future;
    //return _streamController..add('close');
  }
}
