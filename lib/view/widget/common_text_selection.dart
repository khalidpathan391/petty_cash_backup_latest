import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class CommonTextSelection extends StatelessWidget {
  final String label;
  final Color? color;
  final double fontSize;
  final String fontFamily;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final Alignment? alignment;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final FontWeight? fontWeight;
  final double? height;
  final double? width;
  final TextOverflow overFlow;
  final int maxLine;
  final dynamic myDecoration;
  final bool isSelectable;
  final bool isToolTip;
  final TextDirection? textDirection;
  final double? iconSize;
  final bool isLeftIconShow;
  final bool isRightIconShow;
  final IconData leftIconData;
  final IconData rightIconData;
  final Color leftIconColor;
  final Color rightIconColor;
  final bool isUnderLineShow;
  final Color underLineColor;
  final double underLineHeight;
  final double underLineThickness;
  final bool isOutlineBorderShow;
  final Color borderColor;
  final double borderRadius;

  const CommonTextSelection({
    super.key,
    this.label = "",
    this.color = Colors.black,
    this.fontSize = 0,
    this.fontFamily = 'Regular',
    this.textAlign = TextAlign.start,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.onLongPress,
    this.fontWeight,
    this.height,
    this.width,
    this.overFlow = TextOverflow.ellipsis,
    this.maxLine = 1,
    this.alignment,
    this.myDecoration,
    this.isSelectable = false,
    this.isToolTip = true,
    this.textDirection,
    this.textStyle,
    this.iconSize = 20,
    this.isLeftIconShow = false,
    this.isRightIconShow = false,
    this.leftIconData = Icons.arrow_back_ios,
    this.rightIconData = Icons.arrow_forward_ios_rounded,
    this.leftIconColor = Colors.black,
    this.rightIconColor = Colors.black,
    this.isUnderLineShow = false,
    this.underLineColor = Colors.black,
    this.underLineHeight = 5.0,
    this.underLineThickness = 0.8,
    this.isOutlineBorderShow = false,
    this.borderColor = Colors.black,
    this.borderRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    double fSize = fontSize;
    String fFamily = fontFamily;
    if (fSize == 0) {
      fSize = context.resources.dimension.appBigText;
    }
    if (fFamily.isEmpty) {
      fFamily = "Regular";
    }

    TextStyle effectiveTextStyle = textStyle ??
        TextStyle(
          color: color,
          fontSize: fSize,
          fontFamily: fFamily,
          fontWeight: fontWeight,
        );

    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: isOutlineBorderShow
          ? BoxDecoration(
              border: Border.all(color: borderColor, width: 1.0),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : null, // Apply border conditionally
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
        child: Column(
          children: [
            Row(
              children: [
                if (isLeftIconShow)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      leftIconData,
                      size: iconSize,
                      color: leftIconColor,
                    ),
                  ),
                Expanded(
                  child: Container(
                    alignment: alignment,
                    child: Text(
                      label,
                      textAlign: textAlign,
                      style: effectiveTextStyle,
                      textDirection: textDirection,
                      maxLines: maxLine,
                      overflow: overFlow,
                    ),
                  ),
                ),
                if (isRightIconShow)
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Icon(
                      rightIconData,
                      size: iconSize,
                      color: rightIconColor,
                    ),
                  ),
              ],
            ),
            if (isUnderLineShow)
              Container(
                margin: const EdgeInsets.only(left: 0, right: 10),
                child: Divider(
                  color: underLineColor,
                  height: underLineHeight,
                  thickness: underLineThickness,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
