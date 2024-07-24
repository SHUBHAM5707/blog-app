import 'package:flutter/material.dart';

class BlogEditer extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditer({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      maxLines: null,
    );
  }
}