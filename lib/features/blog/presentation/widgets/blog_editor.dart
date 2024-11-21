import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const BlogEditor({super.key, required this.controller, required this.labelText, });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          labelText: (labelText),
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(15)))),
      maxLines: null,
      validator: (value) {
        if(value!.isEmpty) {
          return '$labelText is missing!';
        }
        return null;
      },
    );
  }
}
