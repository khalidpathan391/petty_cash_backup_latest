import 'package:flutter/material.dart';
import 'package:petty_cash/resources/color/base_colors.dart';

class AppColors implements BaseColors {
  final Map<int, Color> _primary = {
    50: Color.fromRGBO(22, 134, 206, 0.1),
    100: Color.fromRGBO(22, 134, 206, 0.2),
    200: Color.fromRGBO(22, 134, 206, 0.3),
    300: Color.fromRGBO(22, 134, 206, 0.4),
    400: Color.fromRGBO(22, 134, 206, 0.5),
    500: Color.fromRGBO(22, 134, 206, 0.6),
    600: Color.fromRGBO(22, 134, 206, 0.7),
    700: Color.fromRGBO(22, 134, 206, 0.8),
    800: Color.fromRGBO(22, 134, 206, 0.9),
    900: Color.fromRGBO(22, 134, 206, 1.0),
  };

  final BuildContext _context;

  AppColors(this._context);

  @override
  MaterialColor get colorAccent => Colors.amber;

  @override
  MaterialColor get colorPrimary => MaterialColor(0xff1686ce, _primary);

  @override
  Color get colorPrimaryText => const Color(0xff49ABFF);

  @override
  Color get colorSecondaryText => const Color(0xff3593FF);

  @override
  Color get colorWhite => const Color(0xffffffff);

  @override
  Color get colorBlack => const Color(0xff000000);

  @override
  Color get castChipColor => Colors.deepOrangeAccent;

  @override
  Color get catChipColor => Colors.indigoAccent;

  @override
  Color get colorTextFormFieldFill => const Color(0xaed8dbdb);

  @override
  Color get colorGrey => Colors.grey;

  @override
  Color get colorGreen => Colors.green;

  @override
  Color get colorRed => Colors.red;

  @override
  Color get colorLightGrey => Color(0xffd3d3d3);

  // Define a function to generate shades of a color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      swatch[(strengths[i] * 1000).round()] =
          Color.fromRGBO(r, g, b, strengths[i]);
    }

    return MaterialColor(color.value, swatch);
  }

  @override
  Color get colorTransparent => Colors.transparent;

  @override
  Color get themeColor => Theme.of(_context).primaryColor;

  @override
  Color get secondaryColor => Theme.of(_context).primaryColorDark;

  @override
  Color get defaultMediumGrey => const Color(0xFF707070);

  @override
  Color get defaultBlueGrey => const Color(0xFF5C6D84);
}
