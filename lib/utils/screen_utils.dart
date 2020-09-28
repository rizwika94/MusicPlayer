import 'package:flutter/material.dart';

class ScreenUtils {
  static void keyBoardDismiss(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
