import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xffE0FE17),
    this.isDisable = false,
    this.isLoading = false,
  });

  final String text;
  final Function() onPressed;
  Color backgroundColor;
  bool isDisable;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isDisable ? Colors.grey : backgroundColor,
          textStyle: Styles.textStyle16SemiBold,
        ),
        onPressed: isLoading ? null : onPressed,
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 40,
                  child: FittedBox(child: CustomLoadingIndicator()),
                )
              : Text(text),
        ),
      ),
    );
  }
}
