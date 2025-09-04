// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class GradientButton extends StatefulWidget {
  final String? icon;
  final String buttonText;
  final bool isLoading;
  final Function onPressed;
  final double elevation;

  const GradientButton({
    super.key,
    this.icon,
    required this.buttonText,
    this.isLoading = false,
    required this.onPressed,
    this.elevation = 2,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
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
      child: ElevatedButton(
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
          // width: dW * 0.87,
          height: dW * 0.145,
          decoration: BoxDecoration(
            color: themeColor,
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
                          color: Colors.white,
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

// class CustomGradientButton extends StatefulWidget {
//   final String? icon;
//   final String buttonText;
//   final bool isLoading;
//   final Function onPressed;
//   final double elevation;

//   const CustomGradientButton({
//     super.key,
//     this.icon,
//     required this.buttonText,
//     this.isLoading = false,
//     required this.onPressed,
//     this.elevation = 2,
//   });

//   @override
//   State<CustomGradientButton> createState() => _CustomGradientButtonState();
// }

// class _CustomGradientButtonState extends State<CustomGradientButton> {
//   double dW = 0.0;
//   double tS = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     return Container(
//       width: dW,
//       padding: EdgeInsets.only(top: dW * 0.02),
//       child: ElevatedButton(
//         onPressed: () => widget.onPressed(),
//         style: ElevatedButton.styleFrom(
//           elevation: widget.elevation,
//           padding: const EdgeInsets.all(0),
//           fixedSize: Size(dW * 0.87, dW * 0.145),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//         child: Container(
//           // width: dW * 0.87,
//           height: dW * 0.145,
//           decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(5),
//               gradient: linearGradient),
//           child: Center(
//             child: widget.isLoading
//                 ? SizedBox(
//                     height: dW * 0.055,
//                     width: dW * 0.055,
//                     child: circularForButton(dW * 0.05),
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (widget.icon != null)
//                         Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: AssetSvgIcon(widget.icon!),
//                         ),
//                       Text(
//                         widget.buttonText,
//                         style: TextStyle(
//                           color: white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: tS * 14,
//                           letterSpacing: .3,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
