import 'package:flutter/material.dart';

class CustomTextArea extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool isRequired; // Parameter to mark the field as required
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines; // Default is 3 for a text area
  final FocusNode? focusNode;
  final String? initialValue; // Added for initial value logic

  const CustomTextArea({
    super.key,
    this.controller,
    required this.labelText,
    this.isRequired = false, // Default to false for optional fields
    this.validator,
    this.onChanged,
    this.maxLines = 3, // Default maxLines for a text area
    this.focusNode,
    this.initialValue, // Added initial value parameter
  });

  @override
  _CustomTextAreaState createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  late TextEditingController _internalController; // Internal controller

  @override
  void initState() {
    super.initState();

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
      keyboardType: TextInputType.multiline,
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
          borderSide: const BorderSide(
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
