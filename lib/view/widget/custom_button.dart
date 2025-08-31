// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class CustomTextButton extends StatefulWidget {
  final String? icon;
  final String buttonText;
  final bool isLoading;
  final Function onPressed;
  final double elevation;

  const CustomTextButton({
    super.key,
    this.icon,
    required this.buttonText,
    this.isLoading = false,
    required this.onPressed,
    this.elevation = 2,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  double dW = 0.0;
  double tS = 0.0;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    final themeColor = context.resources.color.themeColor;

    return Container(
      width: dW,
      padding: EdgeInsets.only(top: dW * 0.02),
      child: TextButton(
        onPressed: () => widget.onPressed(),
        style: ElevatedButton.styleFrom(
          elevation: widget.elevation,
          padding: const EdgeInsets.all(0),
          fixedSize: Size(dW * 0.87, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Container(
          height: dW * 0.145,
          decoration: BoxDecoration(
            border: Border.all(color: themeColor, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: dW * 0.055,
                    width: dW * 0.055,
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(widget.icon!),
                        ),
                      Text(
                        widget.buttonText,
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: tS * 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
