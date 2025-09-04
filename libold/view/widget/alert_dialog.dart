import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_text.dart';

void showCustomBottomSheet({
  required BuildContext context,
  String? title,
  required List<Widget> content,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    builder: (BuildContext context) {
      Color themeColor = context.resources.color.themeColor;
      return FractionallySizedBox(
        heightFactor: 0.3,
        widthFactor: 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                color: themeColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CommonTextView(
                  label: title,
                  textAlign: TextAlign.center,
                ),
              ),
            if (content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: content,
                ),
              ),
          ],
        ),
      );
    },
  );
}
