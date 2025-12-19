import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextEdit extends StatefulWidget {
  const CustomTextEdit({
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isEditing = true,
  });

  final String labelText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final int? maxLines;
  final bool isEditing;

  @override
  State<CustomTextEdit> createState() => _CustomTextEditState();
}

class _CustomTextEditState extends State<CustomTextEdit> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    // 👇 لو Password يبدأ مخفي
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEditing,
      readOnly: !widget.isEditing,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      controller: widget.textController,
      keyboardType: widget.keyboardType,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      style: Theme.of(context).textTheme.bodyLarge,
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        contentPadding: const EdgeInsets.all(16),

        // 👁️ Eye icon
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : null,
      ),
    );
  }
}
