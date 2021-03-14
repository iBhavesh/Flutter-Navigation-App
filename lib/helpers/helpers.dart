import 'package:flutter/material.dart';

import '../theme/theme.dart';

void showSnackBar(BuildContext context, String text,
    {int duration = 1, Color? color, double textScaleFactor = 1}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.hideCurrentSnackBar();
  scaffoldMessenger.showSnackBar(SnackBar(
    content: Text(
      text,
      textScaleFactor: textScaleFactor,
    ),
    duration: Duration(seconds: duration),
    backgroundColor: color ?? theme.primaryColor,
  ));
}
