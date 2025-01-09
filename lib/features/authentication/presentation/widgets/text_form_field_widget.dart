import 'package:flutter/material.dart';


class TextFormFieldWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPassword;
  const TextFormFieldWidget({required this.title,required this.icon,required this.isPassword,super.key});

  @override
  Widget build(BuildContext context) {
    return  TextField(
      decoration: InputDecoration(
          hintText: title,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          //   fillColor: Colors.purple.withOpacity(0.1),
          filled: true,
          prefixIcon:  Icon(icon)),
      obscureText: isPassword?true:false,
    );
  }
}
