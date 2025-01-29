import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenbil_driver_app/common/blocs/theme_bloc/theme_bloc.dart';

class DeliveryStatusCardWidget extends StatelessWidget {
  const DeliveryStatusCardWidget({
    super.key,
    required this.color,
    required this.text,
    required this.amount,
  });
  final Color color;
  final String text;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        bool isDarkTheme = themeState is DarkThemeState;
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
          child: Center(
            child: ListTile(
              // contentPadding:
              titleTextStyle: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 13,
                  // fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade),
              leading: Image.asset(
                'assets/icons/${text.toLowerCase()}_icon.png',
                width: 30,
                fit: BoxFit.contain,
              ),
              title: Text(
                "$text Deliveries",

              ),
              subtitle: Text(amount.toString()),
            ),
          ),
        );
      }
    );
  }
}
