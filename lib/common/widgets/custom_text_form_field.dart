import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool isRequired; // New parameter to mark the field as required
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? initialValue; // Added for initial value logic

  const CustomTextField({
    Key? key,
    this.controller,
    required this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.isRequired = false, // Default to false for optional fields
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.focusNode,
    this.initialValue, // Added initial value parameter
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _internalController; // Internal controller
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    // Initialize the internal controller with the initial value if no controller is provided
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    // Dispose of the internal controller if it was created internally
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller ?? _internalController,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      validator: widget.validator ??
          (value) {
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return '${widget.labelText} is required';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon,
                color: theme.iconTheme.color?.withOpacity(0.6))
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.amber,
            width: 1.50,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      ),
    );
  }
}
