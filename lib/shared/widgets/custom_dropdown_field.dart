import 'package:flutter/material.dart';

/// A styled dropdown field used across the Sharyan app.
class CustomDropdownField<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final IconData? suffixIcon;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // تحقق من أن القيمة موجودة في القائمة — إن لم تكن، استخدم null لتجنب crash
    final safeValue = items.any((item) => item.value == value) ? value : null;

    return DropdownButtonFormField<T>(
      // ValueKey يجبر إعادة بناء الـ widget عند تغيير القيمة من الخارج
      key: ValueKey(safeValue),
      menuMaxHeight: 300,
      initialValue: safeValue,
      items: items,
      onChanged: onChanged,
      validator: validator,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon:
            suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
      ),
    );
  }
}
