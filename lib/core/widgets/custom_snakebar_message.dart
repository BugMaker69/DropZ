import 'package:flutter/material.dart';

void CustomSnakeBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 00) ,content: Text(text)));
}
