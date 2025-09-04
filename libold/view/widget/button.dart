// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class Button extends StatelessWidget {
  final VoidCallback onClick;
  final String icon;
  final String text;
  final double text_size;
  final Color text_color;
  final bool is_need_show_loader;
  final double width;

  const Button({
    super.key,
    required this.onClick,
    this.icon = 'assets/images/gmail.svg',
    this.text = '',
    this.text_size = 12.0,
    this.text_color = Colors.black,
    this.is_need_show_loader = false,
    this.width = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == 0 ? null : width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white),
        onPressed: is_need_show_loader ? null : onClick,
        icon: is_need_show_loader
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ))
            : SvgPicture.asset(
                icon,
                height: 24,
                width: 24,
              ),
        label: CommonTextView(
          label: text,
        ),
      ),
    );
  }
}
