import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: index == currentIndex ? 5 : 4,
          height: index == currentIndex ? 5 : 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? context.resources.color.themeColor
                : context.resources.color.themeColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
