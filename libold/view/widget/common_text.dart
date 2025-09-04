import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class CommonTextView extends StatelessWidget {
  final String label;
  final Color? color;
  final double fontSize;
  final String fontFamily;
  final TextAlign textAlign;
  final Alignment? alignment;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final FontWeight? fontWeight;
  final double? height;
  final double? width;
  final TextOverflow? overFlow;
  final int? maxLine;
  final dynamic myDecoration;
  final bool isSelectable;
  final bool isToolTip;
  final TextDirection? textDirection;

  const CommonTextView({
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
    this.overFlow,
    this.maxLine,
    this.alignment,
    this.myDecoration,
    this.isSelectable = false,
    this.isToolTip = true,
    this.textDirection,
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
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        alignment: alignment,
        decoration: myDecoration,
        child: isSelectable
            ? SelectableText(
                label,
                textAlign: textAlign,
                style: TextStyle(
                  color: color,
                  fontSize: fSize,
                  fontFamily: fFamily,
                  fontWeight: fontWeight,
                ),
                textDirection: textDirection,
                // overflow: overFlow,//automatically Selected text handel this function no need for overflow
                maxLines: maxLine,
              )
            : isToolTip
                ? Tooltip(
                    message: label,
                    preferBelow: false,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: fSize,
                      fontFamily: fFamily,
                      fontWeight: fontWeight,
                    ),
                    child: Text(
                      label,
                      textAlign: textAlign,
                      style: TextStyle(
                        color: color,
                        fontSize: fSize,
                        fontFamily: fFamily,
                        fontWeight: fontWeight,
                      ),
                      overflow: overFlow,
                      maxLines: maxLine,
                      textDirection: textDirection,
                    ),
                  )
                : Text(
                    label,
                    textAlign: textAlign,
                    style: TextStyle(
                      color: color,
                      fontSize: fSize,
                      fontFamily: fFamily,
                      fontWeight: fontWeight,
                    ),
                    overflow: overFlow,
                    maxLines: maxLine,
                    textDirection: textDirection,
                  ),
      ),
    );
  }

  static void copyTextToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }
}
