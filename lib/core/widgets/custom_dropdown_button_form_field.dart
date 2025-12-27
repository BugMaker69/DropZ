import 'package:flutter/material.dart';

Widget buildDropdown<T>({
  required BuildContext context,
  required String label,
  required T? value,
  required List<DropdownMenuItem<T>> items,
  required void Function(T?)? onChanged,
  String? Function(T?)? validator,
}) {
  return DropdownButtonFormField<T>(
    initialValue: value,
    isExpanded: true,
    items: items,
    onChanged: onChanged,
    validator: validator,
    // dropdownColor: kPrimaryColor,
    style: Theme.of(context).textTheme.bodyLarge,
    iconEnabledColor: Theme.of(context).colorScheme.onSurface,
    decoration: _inputDecoration(context, label),
  );
}

InputDecoration _inputDecoration(context, String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: Theme.of(context).textTheme.bodyLarge,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface,
        width: 2,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface,
        width: 2,
      ),
    ),
  );
}
