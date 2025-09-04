import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? bgColor;
  final bool disable;
  final double height;
  final double fontSize;
  final String fontFamily;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.bgColor,
    this.disable = false,
    this.height = 50.0,
    this.fontSize = 18.0,
    this.fontFamily = 'Regular',
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = bgColor ?? Theme.of(context).primaryColor;
    final applyColor = disable ? buttonColor.withOpacity(0.5) : buttonColor;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(applyColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5.0), // Adjust the value as needed
          ),
        ),
      ),
      onPressed: (disable || isLoading) ? null : onPressed,
      child: AnimatedContainer(
        width: isLoading ? 50 : MediaQuery.of(context).size.width,
        height: height,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontFamily: fontFamily),
                ),
        ),
      ),
    );
  }
}
