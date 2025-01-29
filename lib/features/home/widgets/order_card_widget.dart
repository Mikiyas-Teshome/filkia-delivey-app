import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenbil_driver_app/common/blocs/theme_bloc/theme_bloc.dart';

class OrderCardWidget extends StatelessWidget {
  OrderCardWidget({
    super.key,
    required this.borderColor,
    this.isPending = false,
  });
  final Color borderColor;
  final bool isPending;
  final Color greenColor = Colors.green;
  final Color redColor = Colors.red;
  final Color greenishColor = Colors.green.shade900;
  final Color reddishColor = Colors.red.shade900;

  @override
  Widget build(BuildContext context) {
    var addressTextStyle = TextStyle(
        color: greenishColor, fontSize: 15, fontWeight: FontWeight.bold);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        bool isDarkTheme = themeState is DarkThemeState;
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDarkTheme ? Colors.grey.shade800 : Colors.white,
                borderColor,
              ],
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isDarkTheme ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 50,
                height: 50,
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vegetables',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w100)),
                  const Text('Order 1 details'),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.location_on_outlined, color: redColor),
                    title: Text('Pickup', style: TextStyle(color: redColor)),
                    subtitle: Text('123 Elm Street, Texas',
                        style: addressTextStyle.copyWith(color: reddishColor)),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.location_on_outlined, color: greenColor),
                    title: Text('Delivery', style: TextStyle(color: greenColor)),
                    subtitle: Text('200 Second St, Austin',
                        style: addressTextStyle.copyWith(color: greenishColor)),
                  ),
                ],
              ),
              subtitle: isPending
                  ? Row(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.green),
                          child: const Text('Accept'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.red),
                          onPressed: () {},
                          child: const Text('Decline'),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
      }
    );
  }
}
