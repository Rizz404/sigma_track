import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';

class AppCheckbox extends StatelessWidget {
  final String name;
  final Widget title;
  final String? Function(bool?)? validator;

  const AppCheckbox({
    super.key,
    required this.name,
    required this.title,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckbox(
      name: name,
      title: title,
      validator: validator,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: context.colors.primary,
      checkColor: context.colors.textOnPrimary,
    );
  }
}
