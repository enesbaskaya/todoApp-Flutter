import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;
  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;
  Color get whiteColor => Colors.white;
  Color get orangeColor => Colors.orange;
  Color get greenColor => Colors.green;
  Color get redColor => Colors.red;
  Color get greyColor => Color(0xFFE0E0E0);
}
