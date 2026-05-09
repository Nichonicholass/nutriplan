import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../meal_plan/presentation/providers/meal_plan_providers.dart';
import '../../../meal_plan/data/models/meal_plan_model.dart';

class SavedPlansScreen extends ConsumerWidget {
  const SavedPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final plansAsync = ref.watch(savedPlansProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📋 Saved Plans',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimary : AppColors.textLight,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  plansAsync.maybeWhen(
                    data: (plans) => plans.isNotEmpty
                        ? TextButton(
                            onPressed: () => _confirmClearAll(context, ref),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: AppColors.error, fontFamily: 'Nunito'),
                            ),
                          )
                        : const SizedBox(),
                    orElse: () => const SizedBox(),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
            ),
          ),

          plansAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $e', style: const TextStyle(color: AppColors.error)),
              ),
            ),
            data: (plans) {
              if (plans.isEmpty) {
                return SliverFillRemaining(child: _buildEmpty(context));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: _SavedPlanCard(
                      plan: plans[index],
                      onDelete: () => ref.read(savedPlansProvider.notifier).deletePlan(plans[index].id),
                    ).animate().fadeIn(delay: Duration(milliseconds: 80 * index), duration: 400.ms),
                  ),
                  childCount: plans.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📂', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'No saved plans yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate a meal plan and save it!',
            style: TextStyle(fontSize: 14, color: AppColors.textMuted, fontFamily: 'Nunito'),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/generate'),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Generate Plan'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Plans?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final repo = ref.read(mealPlanRepositoryProvider);
      await repo.deleteAllPlans();
      ref.read(savedPlansProvider.notifier).refresh();
    }
  }
}

class _SavedPlanCard extends StatelessWidget {
  final MealPlanModel plan;
  final VoidCallback onDelete;

  const _SavedPlanCard({required this.plan, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalColor = AppColors.goalColors[plan.goal] ?? AppColors.primary;
    final dateStr = DateFormat('d MMM yyyy, HH:mm').format(plan.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: goalColor.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: goalColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _getGoalEmoji(plan.goal),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.planName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimary : AppColors.textLight,
                          fontFamily: 'Nunito',
                        ),
                      ),
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
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: goalColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    plan.goal,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: goalColor,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _Stat(label: 'Calories', value: '${plan.nutritionSummary.totalCalories}', unit: 'kcal', color: AppColors.calorieColor),
                _Stat(label: 'Protein', value: '${plan.nutritionSummary.totalProtein.toStringAsFixed(0)}', unit: 'g', color: AppColors.proteinColor),
                _Stat(label: 'Budget', value: 'Rp${(plan.budgetPerDay / 1000).toStringAsFixed(0)}K', unit: '/day', color: AppColors.secondary),
                _Stat(label: 'Meals', value: '${plan.meals.length}', unit: 'meals', color: AppColors.accentOrange),
              ],
            ),
          ),

          // Meal names preview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: plan.meals.take(3).map((m) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${m.emoji} ${m.name}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                    fontFamily: 'Nunito',
                  ),
                ),
              )).toList(),
            ),
          ),

          // Delete button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: AppColors.error, fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _Stat({required this.label, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              fontFamily: 'Nunito',
            ),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'Nunito'),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Nunito'),
          ),
        ],
      ),
    );
  }
}
