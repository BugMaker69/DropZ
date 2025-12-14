import 'package:flutter/material.dart';

void CustomSnakeBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
