import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String countryCode;
  final String? Function(String?)? validator;

  const CustomPhoneTextFormField({
    super.key,
    this.controller,
    this.labelText = 'Phone Number',
    this.countryCode = '+1', // Fixed country code for the USA
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [PhoneNumberFormatter()],
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: const Icon(Icons.phone),
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
      ),
      validator: (value) {
        final trimmedValue = value?.trim();

        // Check if the phone number is empty
        if (trimmedValue == null || trimmedValue.isEmpty) {
          return 'Phone number is required';
        }

        // Ensure phone number starts with the correct country code
        if (!trimmedValue.startsWith(countryCode)) {
          return 'Phone number must start with $countryCode';
        }

        // Extract the actual number part after the country code
        final phoneNumber = trimmedValue.substring(countryCode.length);

        // Ensure the number part is numeric and meets the length requirement
        if (phoneNumber.isEmpty || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
          return 'Phone number must contain only digits';
        }
        if (phoneNumber.length != 10) {
          return 'Phone number must be 10 digits long';
        }

        return null; // Validation passed
      },
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only digits and plus sign
    final newText = newValue.text.replaceAll(RegExp(r'[^\d+]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
