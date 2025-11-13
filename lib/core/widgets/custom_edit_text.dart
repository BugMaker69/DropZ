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
    this.maxLines = 1,
    this.isEditing = true,
  });

  final String labelText;
  bool isPassword;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  final TextEditingController textController;
  TextInputType keyboardType;
  bool showText;
  int? maxLines;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEditing,
      readOnly: !isEditing,
      obscureText: !showText,
      validator: validator,
      controller: textController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: Styles.textStyle18Regular.copyWith(
        color: Colors.white,
        fontWeight: isEditing ? FontWeight.normal : FontWeight.w500,
      ),
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
        labelStyle: Styles.textStyle18Regular.copyWith(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isEditing
                ? Colors.white
                : Colors.transparent, // 🟡 بدون إطار وقت العرض
            width: isEditing ? 1.5 : 0,
          ),
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
        errorStyle: const TextStyle(height: 0.8),
        fillColor: isEditing
            ? Colors.transparent
            : Colors.white.withOpacity(0.1),
        filled: true,
      ),
    );
  }
}
