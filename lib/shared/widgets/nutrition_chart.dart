import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/meal_plan/data/models/meal_plan_model.dart';

class NutritionSummaryCard extends StatelessWidget {
  final NutritionSummary nutrition;

  const NutritionSummaryCard({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = nutrition.targetCalories > 0
        ? (nutrition.totalCalories / nutrition.targetCalories).clamp(0.0, 1.0)
        : 0.5;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nutrition Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimary : AppColors.textLight,
                  fontFamily: 'Nunito',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.calorieColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${nutrition.totalCalories} kcal',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.calorieColor,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Calorie progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Calories',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  Text(
                    '${nutrition.totalCalories} / ${nutrition.targetCalories} kcal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightBg,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 0.95 ? AppColors.error : AppColors.calorieColor,
                  ),
                  minHeight: 10,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Macros row
          Row(
            children: [
              _MacroBar(
                label: 'Protein',
                value: nutrition.totalProtein,
                unit: 'g',
                color: AppColors.proteinColor,
                maxValue: 200,
              ),
              const SizedBox(width: 12),
              _MacroBar(
                label: 'Carbs',
                value: nutrition.totalCarbs,
                unit: 'g',
                color: AppColors.carbsColor,
                maxValue: 300,
              ),
              const SizedBox(width: 12),
              _MacroBar(
                label: 'Fat',
                value: nutrition.totalFat,
                unit: 'g',
                color: AppColors.fatColor,
                maxValue: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  final double maxValue;

  const _MacroBar({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardElevated : AppColors.lightBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${value.toStringAsFixed(0)}$unit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Nunito',
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
