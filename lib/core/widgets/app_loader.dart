import 'package:flutter/material.dart';
import 'package:memora/core/theme/app-colors.dart';


class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.8,
    this.color = AppColors.primary,
  });

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color),
    );
  }
}
