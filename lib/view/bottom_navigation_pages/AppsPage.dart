// ignore_for_file: unused_import

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppsPage extends StatefulWidget {
  @override
  _AppsPageState createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  @override
  void initState() {
    super.initState();
    //showAppListList();
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   showAppListList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () {
              //showAppListList();
            },
            child: Text("Apps")),
      ),
    );
  }
}
