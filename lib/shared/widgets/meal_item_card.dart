import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../features/meal_plan/data/models/meal_plan_model.dart';
import '../../features/meal_plan/presentation/providers/meal_plan_providers.dart';

class MealItemCard extends ConsumerWidget {
  final MealItem meal;
  final int mealIndex;
  final int planMealsCount;

  const MealItemCard({
    super.key,
    required this.meal,
    required this.mealIndex,
    required this.planMealsCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mealTypeColor = _getMealTypeColor(meal.mealType);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: mealTypeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: mealTypeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getMealTypeIcon(meal.mealType), size: 12, color: mealTypeColor),
                      const SizedBox(width: 4),
                      Text(
                        _capitalize(meal.mealType),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: mealTypeColor,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                GestureDetector(
                  onTap: () => _showRegenerateOptions(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, size: 12, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Regenerate',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(meal.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimary : AppColors.textLight,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meal.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),


                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : AppColors.lightBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NutritionBadge(value: '${meal.calories}', unit: 'kcal', color: AppColors.calorieColor),
                      _NutritionBadge(value: '${meal.protein.toStringAsFixed(0)}g', unit: 'protein', color: AppColors.proteinColor),
                      _NutritionBadge(value: '${meal.carbs.toStringAsFixed(0)}g', unit: 'carbs', color: AppColors.carbsColor),
                      _NutritionBadge(value: '${meal.fat.toStringAsFixed(0)}g', unit: 'fat', color: AppColors.fatColor),
                    ],
                  ),
                ),

                if (meal.ingredients.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: meal.ingredients.map((ing) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ing,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    )).toList(),
                  ),
                ],

                const SizedBox(height: 12),


                Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      'Est. Rp ${meal.estimatedCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMealTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast': return const Color(0xFFFF9F43);
      case 'lunch': return const Color(0xFF6C63FF);
      case 'dinner': return const Color(0xFF00D9A3);
      case 'snack': return const Color(0xFFFF6B6B);
      default: return AppColors.primary;
    }
  }

  IconData _getMealTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast': return Icons.wb_sunny_rounded;
      case 'lunch': return Icons.lunch_dining_rounded;
      case 'dinner': return Icons.nights_stay_rounded;
      case 'snack': return Icons.cookie_rounded;
      default: return Icons.restaurant_rounded;
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  void _showRegenerateOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RegenerateSheet(
        mealIndex: mealIndex,
        mealType: meal.mealType,
      ),
    );
  }
}

class _RegenerateSheet extends ConsumerWidget {
  final int mealIndex;
  final String mealType;

  const _RegenerateSheet({required this.mealIndex, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final options = [
      {'label': '🔄 Different meal', 'key': 'different', 'desc': 'Try a completely new option'},
      {'label': '💰 Cheaper alternative', 'key': 'cheaper', 'desc': 'Use more affordable ingredients'},
      {'label': '💪 Higher protein', 'key': 'high_protein', 'desc': 'Boost protein content'},
      {'label': '⚡ Simpler meal', 'key': 'simpler', 'desc': 'Fewer ingredients, easier to make'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Regenerate ${_capitalize(mealType)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimary : AppColors.textLight,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((opt) => ListTile(
            onTap: () async {
              Navigator.pop(context);
              await ref.read(mealPlanGeneratorProvider.notifier).regenerateMeal(
                mealIndex: mealIndex,
                mealType: mealType,
                regenerateOption: opt['key']!,
              );
            },
            title: Text(
              opt['label']!,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimary : AppColors.textLight,
              ),
            ),
            subtitle: Text(
              opt['desc']!,
              style: const TextStyle(fontFamily: 'Nunito', color: AppColors.textMuted, fontSize: 12),
            ),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _NutritionBadge extends StatelessWidget {
  final String value;
  final String unit;
  final Color color;

  const _NutritionBadge({required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: color,
            fontFamily: 'Nunito',
          ),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'Nunito'),
        ),
      ],
    );
  }
}
