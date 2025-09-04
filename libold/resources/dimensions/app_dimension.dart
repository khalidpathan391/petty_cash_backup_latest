import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/dimensions/dimension.dart';

class AppDimension extends Dimensions {
  @override
  double get extraBigMargin => 50;
  @override
  double get bigMargin => 20;

  @override
  double get defaultMargin => 16;

  @override
  double get mediumMargin => 12;

  @override
  double get smallMargin => 8;

  @override
  double get verySmallMargin => 4;

  @override
  double get highElevation => 16;

  @override
  double get mediumElevation => 8;

  @override
  double get lightElevation => 4;

  @override
  double get listImageSize => 50;

  @override
  double get imageBorderRadius => 8;

  @override
  double get imageHeight => 450;

  @override
  double get appBigText => appTextSize(19);

  @override
  double get appExtraBigText => appTextSize(37);

  @override
  double get appExtraSmallText => appTextSize(12);

  @override
  double get appMediumText => appTextSize(15);

  @override
  double get appSmallText => appTextSize(13);
}
