import 'package:flutter/cupertino.dart';

abstract class StringValidator {
  static const String REGEX = "";
  static const String DESCRIPTION = "";

  String get description;
  FormFieldValidator<String> get validator;
}
