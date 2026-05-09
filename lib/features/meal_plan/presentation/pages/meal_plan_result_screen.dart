import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/meal_plan_providers.dart';
import '../../data/models/meal_plan_model.dart';
import '../../../../shared/widgets/nutrition_chart.dart';
import '../../../../shared/widgets/meal_item_card.dart';

class MealPlanResultScreen extends ConsumerWidget {
  const MealPlanResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final planAsync = ref.watch(mealPlanGeneratorProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: planAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(error: e.toString()),
        data: (plan) {
          if (plan == null) {
            return const _ErrorView(error: 'No meal plan generated. Please try again.');
          }
          return _ResultContent(plan: plan);
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.darkGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 40),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(end: 1.1, duration: 800.ms, curve: Curves.easeInOut),
            const SizedBox(height: 24),
            const Text(
              'Cooking your meal plan...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gemini AI is analyzing your preferences',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontFamily: 'Nunito'),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.darkCard,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: 'Nunito',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontFamily: 'Nunito'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/generate'),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultContent extends ConsumerStatefulWidget {
  final MealPlanModel plan;
  const _ResultContent({required this.plan});

  @override
  ConsumerState<_ResultContent> createState() => _ResultContentState();
}

class _ResultContentState extends ConsumerState<_ResultContent> {
  bool _isSaving = false;
  bool _isSaved = false;

  Future<void> _savePlan() async {
    setState(() => _isSaving = true);
    await ref.read(savedPlansProvider.notifier).savePlan(widget.plan);
    if (mounted) {
      setState(() {
        _isSaving = false;
        _isSaved = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Meal plan saved!'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final plan = widget.plan;
    final nutrition = plan.nutritionSummary;
    final goalColor = AppColors.goalColors[plan.goal] ?? AppColors.primary;

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [goalColor.withOpacity(0.8), AppColors.darkBg],
              ),
            ),
            child: Column(
              children: [
                // AppBar row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/generate'),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          'Your Meal Plan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSaved || _isSaving ? null : _savePlan,
                        icon: Icon(
                          _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: _isSaved ? AppColors.accentYellow : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Plan Name + Goal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.goal,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.planName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Nutrition Summary
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: NutritionSummaryCard(nutrition: nutrition),
          ),
        ),

        // Meals Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Meals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimary : AppColors.textLight,
                    fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  '${plan.meals.length} meals',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
        ),

        // Meals List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final meal = plan.meals[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: MealItemCard(
                  meal: meal,
                  mealIndex: index,
                  planMealsCount: plan.meals.length,
                ).animate().fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms).slideY(begin: 0.2, end: 0),
              );
            },
            childCount: plan.meals.length,
          ),
        ),

        // Goal Suitability
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🎯', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Text(
                        'Goal Analysis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nutrition.goalSuitability,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                      fontFamily: 'Nunito',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action Buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/grocery'),
                    icon: const Icon(Icons.shopping_cart_rounded, size: 18),
                    label: const Text('Grocery List'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/generate'),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Regenerate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}
