import 'package:flutter/material.dart';

void CustomSnakeBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 600) ,content: Text(text)));
}
