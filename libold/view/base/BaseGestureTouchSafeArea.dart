// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class BaseGestureTouchSafeArea extends StatefulWidget {
  final Widget child;

  const BaseGestureTouchSafeArea({
    super.key,
    required this.child,
  });

  @override
  _BaseGestureTouchSafeAreaState createState() =>
      _BaseGestureTouchSafeAreaState();
}

class _BaseGestureTouchSafeAreaState extends State<BaseGestureTouchSafeArea> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: widget.child,
    );
  }
}
