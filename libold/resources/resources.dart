import 'package:flutter/material.dart';
import 'package:petty_cash/resources/color/app_colors.dart';
import 'package:petty_cash/resources/dimensions/app_dimension.dart';

class Resources {
  final BuildContext _context;

  Resources(this._context);

  AppColors get color {
    return AppColors(_context);
  }

  AppDimension get dimension {
    return AppDimension();
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
