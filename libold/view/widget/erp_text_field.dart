import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view_model/CommonProvider.dart';
import 'package:provider/provider.dart';

class CommonTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final bool showLabel;
  final String font;
  final bool allCaps;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final double? height;
  final double? width;
  final bool isBorderUnderLine;
  final bool isBorderSideNone;
  final bool enabled;
  final int? maxLength;
  final String? counterText;
  final EdgeInsets? margin;
  final bool suffixIcon;
  final Color textColor;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final int maxLines;
  final Color cursorColor;
  final Color hintColor;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final double? hintFontSize;
  final double? fontSize; // New parameter for font size

  const CommonTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.showLabel = false,
    this.allCaps = false,
    this.font = 'Regular',
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.height,
    this.width,
    this.isBorderUnderLine = false,
    this.isBorderSideNone = false,
    this.enabled = true,
    this.maxLength,
    this.counterText,
    this.margin,
    this.suffixIcon = false,
    this.textColor = Colors.black,
    this.prefixWidget,
    this.suffixWidget,
    this.maxLines = 1,
    this.cursorColor = Colors.black,
    this.hintColor = Colors.grey,
    this.onFieldSubmitted,
    this.textInputAction,
    this.hintFontSize,
    this.fontSize, // Initialize the new parameter
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonVM>(builder: (context, commonProvider, widget) {
      return Container(
        margin: margin,
        height: height,
        width: width,
        child: TextFormField(
          controller: controller,
          obscureText: commonProvider.obscureText ? obscureText : false,
          keyboardType: keyboardType,
          inputFormatters: [
            UpperCaseTextFormatter(allCaps),
            LengthLimitingTextInputFormatter(maxLength),
          ],
          onChanged: onChanged,
          maxLines: maxLines,
          cursorColor: cursorColor,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize ??
                context.resources.dimension
                    .appBigText, // Use the new fontSize parameter
            fontFamily: font,
          ),
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            isDense: false,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            fillColor: context.resources.color.colorTextFormFieldFill,
            focusedBorder: isBorderUnderLine
                ? UnderlineInputBorder(
                    borderSide: isBorderSideNone
                        ? BorderSide.none
                        : BorderSide(
                            color: context.resources.color.themeColor
                                .withOpacity(0.8),
                            width: 1.5,
                          ),
                  )
                : OutlineInputBorder(
                    borderSide: isBorderSideNone
                        ? BorderSide.none
                        : BorderSide(
                            color: context.resources.color.themeColor
                                .withOpacity(0.8),
                            width: 1.5),
                  ),
            enabledBorder: isBorderUnderLine
                ? UnderlineInputBorder(
                    borderSide: isBorderSideNone
                        ? BorderSide.none
                        : BorderSide(
                            color: context.resources.color.themeColor
                                .withOpacity(0.3),
                            width: 1,
                          ),
                  )
                : OutlineInputBorder(
                    borderSide: isBorderSideNone
                        ? BorderSide.none
                        : BorderSide(
                            color: context.resources.color.themeColor
                                .withOpacity(0.3),
                            width: 1,
                          ),
                  ),
            labelText: showLabel ? label : null,
            labelStyle: getStyle1(context),
            hintText: label,
            hintStyle: getStyle(context),
            counterText: counterText,
            suffixIcon: suffixIcon
                ? IconButton(
                    onPressed: () {
                      commonProvider.setObscureText();
                    },
                    icon: Icon(commonProvider.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility))
                : suffixWidget,
            prefixIcon: prefixWidget,
            counterStyle: getStyle(context),
            disabledBorder: isBorderUnderLine
                ? UnderlineInputBorder(
                    borderSide: isBorderSideNone
                        ? BorderSide.none
                        : BorderSide(
                            color: context.resources.color.themeColor
                                .withOpacity(0.3),
                            width: 1,
                          ),
                  )
                : OutlineInputBorder(
                    borderSide: isBorderSideNone
                        ? BorderSide.none
                        : BorderSide(
                            color: context.resources.color.themeColor
                                .withOpacity(0.3),
                            width: 1,
                          ),
                  ),
            enabled: enabled,
          ),
        ),
      );
    });
  }

  TextStyle getStyle(BuildContext context) {
    return TextStyle(
      color: hintColor,
      fontSize: hintFontSize ?? context.resources.dimension.appBigText,
      fontFamily: font,
    );
  }

  TextStyle getStyle1(BuildContext context) {
    return TextStyle(
      color: context.resources.color.colorGrey,
      fontSize: context.resources.dimension.appBigText,
      fontFamily: font,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  bool isNeedAllCaps;

  UpperCaseTextFormatter(this.isNeedAllCaps);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: isNeedAllCaps ? newValue.text.toUpperCase() : newValue.text,
      selection: newValue.selection,
    );
  }
}
