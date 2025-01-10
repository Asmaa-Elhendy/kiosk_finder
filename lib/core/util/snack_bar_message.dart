import 'package:flutter/material.dart';
import '../app_theme.dart';

class SnackBarMessage {
  void showSuccessSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          message,
          style: TextStyle(color: whiteColor),
        )));
  }

  void showErrorSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: TextStyle(
            color: whiteColor,
          ),
        )));
  }
}
