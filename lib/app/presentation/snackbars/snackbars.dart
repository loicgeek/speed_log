import 'package:flutter/material.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';

class AppSnackbars {
  static showError(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static showSucess(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        backgroundColor: AppColors.primary,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
