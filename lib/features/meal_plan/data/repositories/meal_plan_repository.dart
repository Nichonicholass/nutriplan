import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_plan_model.dart';
import '../../../../core/constants/app_constants.dart';

class MealPlanRepository {
  Box<dynamic>? _box;

  Future<void> init() async {
    _box = await Hive.openBox(AppConstants.mealPlanBox);
  }

  Box<dynamic> get _safeBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Hive box not initialized');
    }
    return _box!;
  }

  Future<void> saveMealPlan(MealPlanModel plan) async {
    final json = jsonEncode(plan.toJson());
    await _safeBox.put(plan.id, json);
  }

  Future<List<MealPlanModel>> getAllSavedPlans() async {
    final List<MealPlanModel> plans = [];
    for (final key in _safeBox.keys) {
      try {
        final jsonStr = _safeBox.get(key) as String?;
        if (jsonStr != null) {
          final json = jsonDecode(jsonStr) as Map<String, dynamic>;
          final plan = _fromStoredJson(json);
          plans.add(plan);
        }
      } catch (_) {
        // Skip corrupted entries
      }
    }
    plans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return plans;
  }

  Future<MealPlanModel?> getMealPlanById(String id) async {
    final jsonStr = _safeBox.get(id) as String?;
    if (jsonStr == null) return null;
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _fromStoredJson(json);
  }

  Future<void> deleteMealPlan(String id) async {
    await _safeBox.delete(id);
  }

  Future<void> deleteAllPlans() async {
    await _safeBox.clear();
  }

  MealPlanModel _fromStoredJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as List<dynamic>? ?? [];
    final groceryJson = json['grocery_list'] as List<dynamic>? ?? [];

    return MealPlanModel(
      id: json['id'] as String,
      goal: json['goal'] as String,
      budgetPerDay: (json['budget_per_day'] as num).toDouble(),
      meals: mealsJson.map((e) => MealItem.fromJson(e as Map<String, dynamic>)).toList(),
      groceryList: groceryJson.map((e) => GroceryItem.fromJson(e as Map<String, dynamic>)).toList(),
      nutritionSummary: NutritionSummary.fromJson(
        json['nutrition_summary'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      preferences: json['preferences'] as String? ?? '',
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      mealsPerDay: (json['meals_per_day'] as num?)?.toInt() ?? 3,
      planName: json['plan_name'] as String? ?? 'Meal Plan',
      isSaved: json['is_saved'] as bool? ?? false,
    );
  }
}
