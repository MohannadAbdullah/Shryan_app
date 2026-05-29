import 'package:flutter/material.dart';

/// A styled text input field used across the Sharyan app.
/// When [isPassword] is true, a show/hide toggle button appears automatically.
class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // tracks whether the text is currently hidden
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword; // only hide if it's a password field
  }

  @override
  Widget build(BuildContext context) {
    // ── Suffix icon logic ────────────────────────────────────────────────────
    // Password fields get a visibility toggle; other fields get the regular icon.
    Widget? suffixWidget;

    if (widget.isPassword) {
      suffixWidget = AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          key: ValueKey(_obscure),
          icon: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: _obscure
                ? Colors.grey
                : Theme.of(context).primaryColor,
            size: 22,
          ),
          splashRadius: 20,
          tooltip: _obscure ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      );
    } else if (widget.suffixIcon != null) {
      suffixWidget = Icon(widget.suffixIcon, color: Colors.grey);
    }

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: suffixWidget,
        prefixIcon: widget.prefixIcon,
      ),
    );
  }
}
