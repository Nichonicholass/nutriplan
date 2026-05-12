import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/meal_plan_model.dart';
import '../../data/repositories/meal_plan_repository.dart';
import '../../../../services/meal_plan/meal_plan_service.dart';



final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  return MealPlanRepository();
});

final mealPlanServiceProvider = Provider<MealPlanService>((ref) {
  return MealPlanService();
});



class MealPlanFormState {
  final String goal;
  final double budgetPerDay;
  final int mealsPerDay;
  final String preferences;
  final List<String> allergies;

  const MealPlanFormState({
    this.goal = 'Healthy Lifestyle',
    this.budgetPerDay = 50000,
    this.mealsPerDay = 3,
    this.preferences = '',
    this.allergies = const [],
  });

  MealPlanFormState copyWith({
    String? goal,
    double? budgetPerDay,
    int? mealsPerDay,
    String? preferences,
    List<String>? allergies,
  }) {
    return MealPlanFormState(
      goal: goal ?? this.goal,
      budgetPerDay: budgetPerDay ?? this.budgetPerDay,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      preferences: preferences ?? this.preferences,
      allergies: allergies ?? this.allergies,
    );
  }
}

class MealPlanFormNotifier extends Notifier<MealPlanFormState> {
  @override
  MealPlanFormState build() => const MealPlanFormState();

  void setGoal(String goal) => state = state.copyWith(goal: goal);
  void setBudget(double budget) => state = state.copyWith(budgetPerDay: budget);
  void setMealsPerDay(int count) => state = state.copyWith(mealsPerDay: count);
  void setPreferences(String pref) => state = state.copyWith(preferences: pref);
  void toggleAllergy(String allergy) {
    final current = List<String>.from(state.allergies);
    if (current.contains(allergy)) {
      current.remove(allergy);
    } else {
      current.add(allergy);
    }
    state = state.copyWith(allergies: current);
  }
  void reset() => state = const MealPlanFormState();
}

final mealPlanFormProvider = NotifierProvider<MealPlanFormNotifier, MealPlanFormState>(
  () => MealPlanFormNotifier(),
);



class MealPlanGeneratorNotifier extends AsyncNotifier<MealPlanModel?> {
  @override
  Future<MealPlanModel?> build() async => null;

  Future<void> generatePlan(MealPlanFormState form) async {
    state = const AsyncLoading();
    final service = ref.read(mealPlanServiceProvider);

    state = await AsyncValue.guard(() => service.generateMealPlan(
          goal: form.goal,
          budgetPerDay: form.budgetPerDay,
          mealsPerDay: form.mealsPerDay,
          preferences: form.preferences,
          allergies: form.allergies,
        ));
  }

  Future<void> regenerateMeal({
    required int mealIndex,
    required String mealType,
    required String regenerateOption,
  }) async {
    final currentPlan = state.value;
    if (currentPlan == null) return;

    final service = ref.read(mealPlanServiceProvider);
    try {
      final newMeal = await service.regenerateSingleMeal(
        mealType: mealType,
        goal: currentPlan.goal,
        budgetPerMeal: currentPlan.budgetPerDay / currentPlan.mealsPerDay,
        preferences: currentPlan.preferences,
        allergies: currentPlan.allergies,
        regenerateOption: regenerateOption,
      );

      final updatedMeals = List<MealItem>.from(currentPlan.meals);
      updatedMeals[mealIndex] = newMeal;


      final newNutrition = _recalculateNutrition(updatedMeals, currentPlan);

      state = AsyncData(currentPlan.copyWith(
        meals: updatedMeals,
        nutritionSummary: newNutrition,
      ));
    } catch (e) {

    }
  }

  NutritionSummary _recalculateNutrition(List<MealItem> meals, MealPlanModel plan) {
    final totalCal = meals.fold(0, (sum, m) => sum + m.calories);
    final totalProt = meals.fold(0.0, (sum, m) => sum + m.protein);
    final totalCarbs = meals.fold(0.0, (sum, m) => sum + m.carbs);
    final totalFat = meals.fold(0.0, (sum, m) => sum + m.fat);

    return NutritionSummary(
      totalCalories: totalCal,
      totalProtein: totalProt,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      goalSuitability: plan.nutritionSummary.goalSuitability,
      targetCalories: plan.nutritionSummary.targetCalories,
    );
  }

  void clearPlan() {
    state = const AsyncData(null);
  }
}

final mealPlanGeneratorProvider = AsyncNotifierProvider<MealPlanGeneratorNotifier, MealPlanModel?>(
  () => MealPlanGeneratorNotifier(),
);



class SavedPlansNotifier extends AsyncNotifier<List<MealPlanModel>> {
  @override
  Future<List<MealPlanModel>> build() async {
    return _loadPlans();
  }

  Future<List<MealPlanModel>> _loadPlans() async {
    final repo = ref.read(mealPlanRepositoryProvider);
    await repo.init();
    return repo.getAllSavedPlans();
  }

  Future<void> savePlan(MealPlanModel plan) async {
    final repo = ref.read(mealPlanRepositoryProvider);
    await repo.init();
    final savedPlan = plan.copyWith(isSaved: true);
    await repo.saveMealPlan(savedPlan);
    state = AsyncData([...(state.value ?? []), savedPlan]);
    final plans = await _loadPlans();
    state = AsyncData(plans);
  }

  Future<void> deletePlan(String id) async {
    final repo = ref.read(mealPlanRepositoryProvider);
    await repo.init();
    await repo.deleteMealPlan(id);
    final plans = await _loadPlans();
    state = AsyncData(plans);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadPlans());
  }
}

final savedPlansProvider = AsyncNotifierProvider<SavedPlansNotifier, List<MealPlanModel>>(
  () => SavedPlansNotifier(),
);
