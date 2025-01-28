import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(),
          ),
        ],
      ),
      content: Text(
        message.replaceAll("Exception: ", ""),
        style: GoogleFonts.inter(),
      ),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: TextStyle(
                  color: Colors.amberAccent.shade700,
                  fontWeight: FontWeight.bold),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Dismiss',
            style: TextStyle(
              color: Colors.amberAccent.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
