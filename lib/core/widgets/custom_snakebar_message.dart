import 'package:flutter/material.dart';

void customSnakeBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
