import 'package:flutter/material.dart';
double appHeight = 0;
double appWidth = 0;
double appHeightP = 0;
double appWidthP = 0;
class AppSize {

  static void initialize(BuildContext context, double width, double height) {
    double screenSizeHeight = MediaQuery.of(context).size.height;
    double screenSizeWidth = MediaQuery.of(context).size.width;

    //as per design
    appHeight = screenSizeHeight / height;
    appWidth = screenSizeWidth / width;

    //as per screen percentage
    appHeightP = screenSizeHeight / 100;
    appWidthP = screenSizeWidth / 100;
  }
}

double AppHeight(double height){
  return appHeight*height;
}

double AppWidth(double width){
  return appWidth*width;
}

double AppHeightP(double percentage){
  return appHeightP * percentage;
}

double AppWidthP(double percentage){
  return appWidthP * percentage;
}

double appTextSize(double figmaTextSize) {
  return figmaTextSize/1.238;
  //in my figma AppWidth(70)only 11 size is fitting
  // so i checked how much textSize can fit max in that which was 8.89
//   so 11/x = 8.89 so x = 1.238
}