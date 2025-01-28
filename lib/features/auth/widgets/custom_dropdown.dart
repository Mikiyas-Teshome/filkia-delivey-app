import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<T>(
      validator: validator,
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: Icon(
              prefixIcon,
              color: theme.iconTheme.color?.withOpacity(0.6),
            ),
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
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
            errorText: state.errorText,
          ),
          isEmpty: value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: (selectedValue) {
                state.didChange(selectedValue); // Update validation state
                onChanged(selectedValue); // Trigger parent onChanged callback
              },
              // style: Theme.of(context).textTheme.bodyText1,
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        );
      },
    );
  }
}
