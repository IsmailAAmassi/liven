import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style ?? Theme.of(context).textTheme.bodyMedium ?? AppTextStyles.body,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
