import 'package:flutter/material.dart';


class TextFormFieldWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  const TextFormFieldWidget({required this.title,required this.icon,required this.controller,required this.isPassword,super.key});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,

      decoration: InputDecoration(
          hintText: title,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
               // color: Colors.red,
                width: 2.0,
              ),),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide:BorderSide(
                color: Color(0xffcc0808),
                width: 2.0,
              ),),
          //   fillColor: Colors.purple.withOpacity(0.1),
          filled: true,
          prefixIcon:  Icon(icon)),
      obscureText: isPassword?true:false,
      validator: (val){
        if(val!.isEmpty){
          return '$title is required';
        }
      },

    );
  }
}
