import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class CommonAnnotatedRegion extends StatelessWidget {
  final Widget child;

  const CommonAnnotatedRegion({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.resources.color.themeColor,
        // Default color fallback
        systemNavigationBarColor: context.resources.color.themeColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: child,
    );
  }

/*@override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: context.resources.color.themeColor,
          // Default color fallback
          systemNavigationBarColor: context.resources.color.themeColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: child,
      ),
    );
  }*/
}
