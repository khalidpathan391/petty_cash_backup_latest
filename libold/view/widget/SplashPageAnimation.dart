import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class SplashPageAnimation {
  BuildContext context;

  SplashPageAnimation(this.context);

  Row callAnimationOne(bool isAnimation) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (i) {
        double height = 45.0;
        if (i == 1 || i == 3 || i == 5) {
          height = 80;
        } else if (i == 4) {
          height = 100;
        }
        return _getContainer(
          context,
          isAnimation ? MediaQuery.of(context).size.height : height,
          i,
        );
      }),
    );
  }

  AnimatedContainer _getContainer(
      BuildContext context, double height, int index) {
    return AnimatedContainer(
      width: 7.5,
      height: height,
      margin: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.resources.color.themeColor,
      ),
      duration: Duration(milliseconds: _getDuration(index)),
      curve: Curves.easeInOut,
    );
  }

  int _getDuration(int i) {
    int duration;
    if (i == 1 || i == 3 || i == 5) {
      duration = 800;
    } else if (i == 4) {
      duration = 500;
    } else {
      duration = 600;
    }
    return duration;
  }

  Stack callAnimationTwo(bool isOpen) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        AnimatedPositioned(
          left: isOpen ? -fullWidth / 2 : 0,
          top: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            width: fullWidth / 2,
            height: MediaQuery.of(context).size.height,
            color: context.resources.color.themeColor,
          ),
        ),
        AnimatedPositioned(
          left: isOpen ? fullWidth : fullWidth / 2,
          top: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            width: fullWidth / 2,
            height: MediaQuery.of(context).size.height,
            color: context.resources.color.themeColor,
          ),
        ),
      ],
    );
  }
}
