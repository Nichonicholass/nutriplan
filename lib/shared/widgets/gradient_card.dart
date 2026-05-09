import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GradientCard extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;

  const GradientCard({
    super.key,
    required this.gradient,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
