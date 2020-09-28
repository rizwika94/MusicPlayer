import 'package:flutter/material.dart';
import 'package:walkman_music/widgets/validator/string_validator.dart';

class TextFormFieldPropertyBundle {
  TextInputType keyboardType = TextInputType.text;
  FocusNode focusNode;
  TextEditingController controller;
  StringValidator validator;
  String label;
  String helperText;
  String optionalString;
  String fieldError;
  bool obscureText;
  Function onSaved;
  Function onSubmitted;
  Function onChanged;
  bool isAggregateValidator;
  bool enabled;
  IconButton suffixIcon;
  int maxCharactersLength;

  TextFormFieldPropertyBundle(
      {FocusNode focusNode,
      this.keyboardType,
      this.controller,
      this.validator,
      this.label,
      this.helperText,
      this.optionalString,
      this.fieldError,
      this.obscureText = false,
      this.enabled = true,
      this.onSaved,
      this.onSubmitted,
      this.onChanged,
      this.isAggregateValidator = false,
      this.suffixIcon})
      : this.focusNode = focusNode ?? FocusNode();
}
