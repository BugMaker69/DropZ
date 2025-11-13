import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xffE0FE17),
  });

  final String text;
  final Function() onPressed;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          textStyle: Styles.textStyle16SemiBold,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
