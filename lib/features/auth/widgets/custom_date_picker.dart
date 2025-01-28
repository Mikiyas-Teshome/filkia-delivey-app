import 'package:flutter/material.dart';
import 'package:zenbil_driver_app/common/contants/constants.dart';

class CustomDatePicker extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController dateController;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateChanged;
  final String? Function(DateTime?)? validator;

  const CustomDatePicker({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.selectedDate,
    required this.onDateChanged,
    this.validator,
    required this.dateController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                    primary:
                        AppConstants.primaryColor, // Changes the header color
                    onPrimary: Colors.white, // Text color in header
                    onSurface: Colors.black, // Body text color
                    ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        AppConstants.primaryColor, // Button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          dateController.text = pickedDate
              .toString(); // Update text field.didChange(pickedDate); // Update validation state
          onDateChanged(pickedDate); // Trigger parent callback
        }
      },
      child: FormField<DateTime>(
        validator: validator,
        builder: (FormFieldState<DateTime> state) {
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
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.50,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
              errorText: state.errorText,
            ),
            isEmpty: selectedDate == null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    selectedDate != null
                        ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                        : '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selectedDate != null
                          ? theme.textTheme.bodyMedium?.color
                          : theme.hintColor,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
