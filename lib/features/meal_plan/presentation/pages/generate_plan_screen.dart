import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/meal_plan_providers.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/section_header.dart';

class GeneratePlanScreen extends ConsumerStatefulWidget {
  const GeneratePlanScreen({super.key});

  @override
  ConsumerState<GeneratePlanScreen> createState() => _GeneratePlanScreenState();
}

class _GeneratePlanScreenState extends ConsumerState<GeneratePlanScreen> {
  final _preferencesController = TextEditingController();
  final _allergyController = TextEditingController();

  final _goals = [
    {'label': 'Healthy Lifestyle', 'emoji': '💚', 'desc': 'Balanced nutrition'},
    {'label': 'Bulking', 'emoji': '💪', 'desc': 'High protein & calories'},
    {'label': 'Cutting', 'emoji': '✂️', 'desc': 'Low calorie, lean'},
    {'label': 'Stunting Prevention', 'emoji': '🌱', 'desc': 'Growth-focused nutrition'},
    {'label': 'Diabetes Friendly', 'emoji': '🩺', 'desc': 'Low GI, controlled carbs'},
  ];

  final _commonAllergies = ['Gluten', 'Dairy', 'Nuts', 'Seafood', 'Eggs', 'Soy'];

  @override
  void dispose() {
    _preferencesController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final form = ref.read(mealPlanFormProvider);
    await ref.read(mealPlanGeneratorProvider.notifier).generatePlan(form);
    if (mounted) {
      final state = ref.read(mealPlanGeneratorProvider);
      if (state.hasValue && state.value != null) {
        context.go('/result');
      } else if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final form = ref.watch(mealPlanFormProvider);
    final isGenerating = ref.watch(mealPlanGeneratorProvider).isLoading;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✨ Generate Plan',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimary : AppColors.textLight,
                          fontFamily: 'Nunito',
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
                      Text(
                        'Customize your AI meal plan',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                          fontFamily: 'Nunito',
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),

              // ─── GOAL SELECTION ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: '🎯 Health Goal'),
                      const SizedBox(height: 12),
                      ...List.generate(_goals.length, (i) {
                        final goal = _goals[i];
                        final isSelected = form.goal == goal['label'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _GoalOption(
                            emoji: goal['emoji']!,
                            label: goal['label']!,
                            desc: goal['desc']!,
                            isSelected: isSelected,
                            onTap: () => ref.read(mealPlanFormProvider.notifier).setGoal(goal['label']!),
                          ).animate().fadeIn(delay: Duration(milliseconds: 150 * i), duration: 400.ms).slideX(begin: 0.2, end: 0),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── BUDGET ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: '💰 Daily Budget'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${form.budgetPerDay.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          Text(
                            'per day',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: form.budgetPerDay,
                        min: 15000,
                        max: 200000,
                        divisions: 37,
                        activeColor: AppColors.primary,
                        inactiveColor: isDark ? AppColors.darkCard : AppColors.lightBorder,
                        onChanged: (v) => ref.read(mealPlanFormProvider.notifier).setBudget(v),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rp 15.000', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMuted : AppColors.textLightSecondary, fontFamily: 'Nunito')),
                          Text('Rp 200.000', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMuted : AppColors.textLightSecondary, fontFamily: 'Nunito')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [25000.0, 50000.0, 75000.0, 100000.0].map((b) => ActionChip(
                          label: Text('Rp ${(b / 1000).toStringAsFixed(0)}K'),
                          onPressed: () => ref.read(mealPlanFormProvider.notifier).setBudget(b),
                          backgroundColor: form.budgetPerDay == b
                              ? AppColors.primary.withOpacity(0.15)
                              : (isDark ? AppColors.darkCard : Colors.white),
                          side: BorderSide(
                            color: form.budgetPerDay == b ? AppColors.primary : AppColors.darkBorder,
                          ),
                          labelStyle: TextStyle(
                            color: form.budgetPerDay == b ? AppColors.primary : (isDark ? AppColors.textSecondary : AppColors.textLightSecondary),
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── MEALS PER DAY ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: '🍽️ Meals Per Day'),
                      const SizedBox(height: 12),
                      Row(
                        children: [3, 4, 5].map((n) {
                          final isSelected = form.mealsPerDay == n;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => ref.read(mealPlanFormProvider.notifier).setMealsPerDay(n),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : (isDark ? AppColors.darkCard : Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.darkBorder,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '$n',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected ? Colors.white : (isDark ? AppColors.textPrimary : AppColors.textLight),
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      Text(
                                        n == 3 ? 'Basic' : n == 4 ? 'Standard' : 'Full',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected ? Colors.white70 : AppColors.textMuted,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── PREFERENCES ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: '🥘 Food Preferences (Optional)'),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _preferencesController,
                        hint: 'e.g., I love nasi goreng, prefer no spicy food...',
                        maxLines: 3,
                        onChanged: (v) => ref.read(mealPlanFormProvider.notifier).setPreferences(v),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─── ALLERGIES ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: '⚠️ Allergies & Restrictions'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _commonAllergies.map((allergy) {
                          final isSelected = form.allergies.contains(allergy);
                          return FilterChip(
                            label: Text(allergy),
                            selected: isSelected,
                            onSelected: (_) => ref.read(mealPlanFormProvider.notifier).toggleAllergy(allergy),
                            selectedColor: AppColors.error.withOpacity(0.15),
                            checkmarkColor: AppColors.error,
                            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                            side: BorderSide(
                              color: isSelected ? AppColors.error : AppColors.darkBorder,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.error : (isDark ? AppColors.textSecondary : AppColors.textLightSecondary),
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // ─── GENERATE BUTTON (floating) ────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (isDark ? AppColors.darkBg : AppColors.lightBg).withOpacity(0),
                    isDark ? AppColors.darkBg : AppColors.lightBg,
                  ],
                ),
              ),
              child: SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: isGenerating ? null : _generate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    disabledBackgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: isGenerating
                          ? const LinearGradient(colors: [Color(0xFF4A4A6A), Color(0xFF4A4A6A)])
                          : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: isGenerating
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Generating AI Plan...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              '✨ Generate Meal Plan',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String desc;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalOption({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalColor = AppColors.goalColors[label] ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? goalColor.withOpacity(0.12) : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? goalColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? goalColor : (isDark ? AppColors.textPrimary : AppColors.textLight),
                      fontFamily: 'Nunito',
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: goalColor, size: 22),
          ],
        ),
      ),
    );
  }
}
