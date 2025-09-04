import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Changed to nullable callback
  final double? width;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;
  final ButtonWidth buttonWidth;
  final String font;
  final IconData? icon;
  final String? svgIconPath;
  final bool disable;
  final Color? buttonDisableColor;
  final Color? color;
  final double fontSize;
  final double iconSize;
  final Color iconColor;
  final Color textColor;
  final EdgeInsetsGeometry margin;
  final Color? svgColor;
  final Color? svgBgColor;
  final bool isLoading;
  final bool isText;
  final TextOverflow overflow;
  final int maxLines;
  final bool isOverflow;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed, // This can now be null
    this.width,
    this.height,
    this.borderRadius = 5.0,
    this.textStyle,
    this.disable = false,
    this.buttonDisableColor = Colors.grey,
    this.color,
    this.fontSize = 16.0,
    this.font = 'Regular',
    this.buttonWidth = ButtonWidth.WRAP,
    this.icon,
    this.svgIconPath,
    this.iconSize = 22.0,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.svgColor,
    this.svgBgColor,
    this.isLoading = false,
    this.isText = true,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    this.isOverflow = false,
  });

  @override
  Widget build(BuildContext context) {
    Color apply = (color ?? Theme.of(context).primaryColor)
        .withOpacity(disable ? 0.5 : 1.0);

    return Container(
      margin: margin,
      width:
          width ?? (buttonWidth == ButtonWidth.WRAP ? null : double.infinity),
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(apply),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: disable ? null : onPressed, // onPressed can now be null
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            if (svgIconPath != null)
              Container(
                decoration: BoxDecoration(color: svgBgColor),
                child: SvgPicture.asset(
                  svgIconPath!,
                  height: iconSize,
                  width: iconSize,
                  color: svgColor,
                ),
              ),
            if (isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            if (isText)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        fontSize: fontSize,
                        fontFamily: font,
                        color: textColor,
                        overflow: isOverflow ? overflow : null,
                      ),
                  maxLines: isOverflow ? maxLines : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Enum to represent different button width types
enum ButtonWidth {
  WRAP,
  MACH,
}
