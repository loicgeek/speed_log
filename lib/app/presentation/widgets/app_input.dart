import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../theme/app_colors.dart';

class AppInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final String label;
  final String? placeholder;
  final bool obscureText;
  final TextInputType? textInputType;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;

  AppInput({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.placeholder,
    this.obscureText = false,
    this.textInputType,
    this.minLines,
    this.maxLines,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 7.0),
          //   child: Text(
          //     label,
          //     style: const TextStyle(
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.primaryGrayText,
          //     ),
          //   ),
          // ),
          TextFormField(
            readOnly: widget.readOnly,
            controller: widget.controller,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.primaryText,
            ),
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            decoration: getInputDecoration(),
            validator: widget.validator,
            obscureText: !isVisible,
            keyboardType: widget.textInputType,
          ),
        ],
      ),
    );
  }

  InputDecoration getInputDecoration() {
    return InputDecoration(
      filled: true,
      suffixIcon: widget.textInputType == TextInputType.visiblePassword
          ? (IconButton(
              onPressed: () {
                isVisible = !isVisible;
                setState(() {});
              },
              icon: Icon(isVisible ? FontAwesome.eye_slash : FontAwesome.eye),
            ))
          : null,
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.primaryGrayText,
            fontSize: 14,
          ),
        ),
      ),
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        color: AppColors.primaryGrayText,
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      hintText: widget.placeholder,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w300,
        color: AppColors.grayScale,
      ),
      fillColor: const Color.fromRGBO(249, 249, 249, 0.5),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.hexToColor("#DDDDDD")),
        borderRadius: BorderRadius.circular(6),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.hexToColor("#DDDDDD")),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
