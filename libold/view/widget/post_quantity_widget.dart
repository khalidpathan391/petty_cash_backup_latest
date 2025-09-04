// quantity widget
import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class QuantityWidget extends StatelessWidget {
  final int quantity;
  final Function() onIncrement;
  final Function() onDecrement;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = context.resources.color.themeColor;

    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(color: themeColor),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 20, color: themeColor),
            onPressed: onDecrement,
          ),
          Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: context.resources.dimension.appMediumText - 3,
              color: Colors.black.withOpacity(.5),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: 20, color: themeColor),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
