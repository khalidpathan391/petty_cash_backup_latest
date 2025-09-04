import 'package:flutter/material.dart';

class CustomLoader {
  static showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
