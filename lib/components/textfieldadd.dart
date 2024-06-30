import 'package:flutter/material.dart';

class CustomTextFromAdd extends StatelessWidget {
 
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
   const CustomTextFromAdd({super.key, required this.hinttext, required this.mycontroller,required this.validator});
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: mycontroller,
      validator:validator ,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    hintText: hinttext,
              
              hintStyle: const TextStyle(fontSize: 17, color: Colors.grey),
              fillColor: Colors.grey[200],
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30))));
  }
}