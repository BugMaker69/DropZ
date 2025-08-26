import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextEdit extends StatelessWidget {
  CustomTextEdit({
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.showText = true,
  });

  final String labelText;
  bool isPassword;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  final TextEditingController textController;
  TextInputType keyboardType;
  bool showText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !showText,
      validator: validator,
      controller: textController,
      keyboardType: keyboardType,
      maxLines: 1,
      style: Styles.textStyle18Regular,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  showText = !showText;
                },
                icon: Icon(
                  showText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.all(16),
        alignLabelWithHint: false,
        labelText: labelText,
        floatingLabelStyle: const TextStyle(color: Colors.white),
        labelStyle: Styles.textStyle18Regular,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            // width: 50,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
