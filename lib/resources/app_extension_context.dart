import 'package:flutter/cupertino.dart';
import 'package:petty_cash/resources/resources.dart';

extension AppContextExtension on BuildContext {
  Resources get resources => Resources.of(this);
}
