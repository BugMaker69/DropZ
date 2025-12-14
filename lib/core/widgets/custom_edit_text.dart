import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextEdit extends StatefulWidget {
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
  State<CustomTextEdit> createState() => _CustomTextEditState();
}

class _CustomTextEditState extends State<CustomTextEdit> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEditing,
      readOnly: !widget.isEditing,
      obscureText: !widget.showText,
      validator: widget.validator,
      controller: widget.textController,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: Theme.of(context).textTheme.bodyLarge,
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.onSurface,

      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  widget.showText = !widget.showText;
                  setState(() {});
                },
                icon: Icon(
                  widget.showText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.all(16),
        alignLabelWithHint: false,
        labelText: widget.labelText,
        // floatingLabelStyle: TextStyle(
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: isEditing
        //         ? Colors.white
        //         : Colors.transparent, // 🟡 بدون إطار وقت العرض
        //     width: isEditing ? 1.5 : 0,
        //   ),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(
        //     color: Colors.white,
        //     // width: 50,
        //   ),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // border: OutlineInputBorder(
        //   borderSide: const BorderSide(color: Colors.white),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // errorStyle: const TextStyle(height: 0.8),
        // fillColor: isEditing
        //     ? Colors.transparent
        //     : Colors.white.withOpacity(0.1),
        // filled: true,
      ),
    );
  }
}
