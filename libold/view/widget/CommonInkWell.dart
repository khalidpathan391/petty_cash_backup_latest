import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class CommonInkWell extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets? margin;

  const CommonInkWell({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadius = BorderRadius.zero,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: Colors.transparent,
      child: Container(
        margin: margin,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          splashColor: context.resources.color.themeColor.withOpacity(0.1),
          highlightColor: context.resources.color.themeColor.withOpacity(0.2),
          child: child,
        ),
      ),
    );
  }
}
