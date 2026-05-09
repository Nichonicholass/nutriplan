import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../features/meal_plan/data/models/meal_plan_model.dart';

class MealPlanCard extends ConsumerWidget {
  final MealPlanModel plan;

  const MealPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalColor = AppColors.goalColors[plan.goal] ?? AppColors.primary;
    final dateStr = DateFormat('d MMM').format(plan.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: goalColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                _getGoalEmoji(plan.goal),
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.planName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimary : AppColors.textLight,
                    fontFamily: 'Nunito',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: goalColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan.goal,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: goalColor,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${plan.nutritionSummary.totalCalories} kcal',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.calorieColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const Text('  ·  ', style: TextStyle(color: AppColors.textMuted)),
                    Text(
                      '${plan.nutritionSummary.totalProtein.toStringAsFixed(0)}g protein',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.proteinColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }

  String _getGoalEmoji(String goal) {
    switch (goal) {
      case 'Bulking': return '💪';
      case 'Cutting': return '✂️';
      case 'Healthy Lifestyle': return '💚';
      case 'Stunting Prevention': return '🌱';
      case 'Diabetes Friendly': return '🩺';
      default: return '🍽️';
    }
  }
}
