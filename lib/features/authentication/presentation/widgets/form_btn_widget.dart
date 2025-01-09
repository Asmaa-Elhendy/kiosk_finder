import 'package:flutter/material.dart';

class FormBtnWidget extends StatelessWidget {
  final String title;
  void Function() onPressed;
  FormBtnWidget({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 3, left: 3),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            // backgroundColor: Colors.purple,
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}
