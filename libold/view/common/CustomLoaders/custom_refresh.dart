import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_text.dart';

//if u make new transactions add it in customLoaderList in globalFunctions

class CustomLoader extends StatefulWidget {
  final bool isDefault;
  final Color
      primaryColor; //if default can set or else other color based on theme color
  final Color secondaryColor;
  final int? index;
  final bool isSettings;
  const CustomLoader({
    super.key,
    this.isDefault = true,
    this.primaryColor = Colors.white,
    this.secondaryColor = Colors.black,
    this.index,
    this.isSettings = false,
  });

  @override
  CustomLoaderState createState() => CustomLoaderState();
}

class CustomLoaderState extends State<CustomLoader>
    with TickerProviderStateMixin {
  @override
  void initState() {
    //for Sine Function index 1
    if (widget.index != null) {
      index = widget.index!;
    } else {
      index = Global.customLoaderIndex;
    }
    super.initState();
    _ticker = createTicker((_) => _updatePhase());
    _ticker.start();

    //for Dot Function index 2
    dotController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    dotAnimation1 = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: dotController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    dotAnimation2 = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: dotController,
        curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );

    dotAnimation3 = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: dotController,
        curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    //for Sine Function index 1
    _ticker.dispose();

    //for Dot Function index 2
    dotController.dispose();

    super.dispose();
  }

  //for Sine Function index 1
  final double containerWidth = 3;
  final double containerSpacing = 3;
  final int containerCount =
      12; // Number of containers to show within the fixed width
  final double amplitude = 20; // Amplitude of the sine wave
  final double frequency = 2 * pi; // Frequency of the sine wave

  late Ticker _ticker;
  double _phase = 0;
  int index = 1;

  void _updatePhase() {
    setState(() {
      _phase += (8 / 100); // Adjust speed of movement here
    });
  }

  //for Dot Function index 2
  late AnimationController dotController;
  late Animation<double> dotAnimation1;
  late Animation<double> dotAnimation2;
  late Animation<double> dotAnimation3;

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
            radius: 8.0, backgroundColor: context.resources.color.themeColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color customColor1 = widget.primaryColor;
    Color customColor2 = widget.secondaryColor;
    if (!widget.isDefault || widget.isSettings) {
      //if not default then based on themeColor
      customColor1 = context.resources.color.themeColor;
      customColor2 = AppUtils.generateSecondaryColorWithContrast(customColor1);
    }

    return index == 1
        ? Container(
            width: 180,
            decoration: BoxDecoration(
              color: widget.isSettings
                  ? Colors.transparent
                  : Colors.black.withOpacity(.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 70,
                  width: containerCount * (containerWidth + containerSpacing),
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(containerCount * 2, (index) {
                      bool isPrimary = index % 2 == 0;
                      double phase = (index * pi / 4) +
                          _phase; // Phase offset for each container
                      double height = amplitude * sin(frequency + phase) +
                          30; // Sine function for height
                      return Positioned(
                        right:
                            (index / 2) * (containerWidth + containerSpacing),
                        child: Container(
                          width: containerWidth,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isPrimary ? customColor1 : customColor2,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                CommonTextView(
                  label: "PleaseWait".tr(),
                  fontSize: context.resources.dimension.appBigText + 3,
                  fontFamily: 'Italic',
                  color: customColor1,
                  padding: const EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
          )
        : index == 2
            ? Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildDot(dotAnimation1),
                    _buildDot(dotAnimation2),
                    _buildDot(dotAnimation3),
                  ],
                ),
              )
            : Container(
                color: Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  color: customColor2,
                )));
  }
}

// import 'dart:math';
// import 'package:crebri_erp_app/res/AppContextExtension.dart';
// import 'package:crebri_erp_app/view/widget/common_text_view.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
//
// class CustomLoader extends StatefulWidget {
//   final Color whichColor;
//   const CustomLoader({super.key,this.whichColor = Colors.white});
//
//   @override
//   CustomLoaderState createState() => CustomLoaderState();
// }
//
// class CustomLoaderState extends State<CustomLoader> with TickerProviderStateMixin {
//   final double containerWidth = 3;
//   final double containerSpacing = 3;
//   final int containerCount = 15; // Number of containers to show within the fixed width
//   final double amplitude = 20; // Amplitude of the sine wave
//   final double frequency = 2 * pi; // Frequency of the sine wave
//
//   late Ticker _ticker;
//   double _phase = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _ticker = createTicker((_) => _updatePhase());
//     _ticker.start();
//   }
//
//   @override
//   void dispose() {
//     _ticker.dispose();
//     super.dispose();
//   }
//
//   void _updatePhase() {
//     setState(() {
//       _phase += (8/100); // Adjust speed of movement here
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 180,
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(.5),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             height: 70,
//             width: containerCount * (containerWidth + containerSpacing),
//             child: Stack(
//               alignment: Alignment.center,
//               children: List.generate(containerCount, (index) {
//                 double phase = (index * pi / 4) + _phase; // Phase offset for each container
//                 double height = amplitude * sin(frequency + phase) + 30; // Sine function for height
//                 return Positioned(
//                   right: index * (containerWidth + containerSpacing),
//                   child: Container(
//                     width: containerWidth,
//                     height: height,
//                     color: widget.whichColor,
//                   ),
//                 );
//               }),
//             ),
//           ),
//           CommonTextView(
//             label: "PleaseWait".tr(),
//             fontSize: context.resources.dimension.appBigText+3,
//             fontFamily: 'Italic',
//             color: widget.whichColor,
//             padding: const EdgeInsets.only(bottom: 10),
//           ),
//         ],
//       ),
//     );
//   }
// }

