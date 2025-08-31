import 'package:flutter/material.dart';

class ListOverWidget extends StatelessWidget {
  final Color themeColor;
  const ListOverWidget({Key? key, required this.themeColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: themeColor.withOpacity(0.7),
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'You have reached the end of the list!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No more items to display',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}