





import 'package:hive/hive.dart';

part 'meal_plan_model.g.dart';

@HiveType(typeId: 0)
class MealItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final double protein;

  @HiveField(4)
  final double carbs;

  @HiveField(5)
  final double fat;

  @HiveField(6)
  final double estimatedCost;

  @HiveField(7)
  final List<String> ingredients;

  @HiveField(8)
  final String mealType; // breakfast, lunch, dinner, snack

  @HiveField(9)
  final String emoji;

  MealItem({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.estimatedCost,
    required this.ingredients,
    required this.mealType,
    this.emoji = '🍽️',
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      name: json['name'] as String? ?? 'Unknown Meal',
      description: json['description'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      mealType: json['meal_type'] as String? ?? 'meal',
      emoji: json['emoji'] as String? ?? '🍽️',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'estimated_cost': estimatedCost,
        'ingredients': ingredients,
        'meal_type': mealType,
        'emoji': emoji,
      };

  MealItem copyWith({
    String? name,
    String? description,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? estimatedCost,
    List<String>? ingredients,
    String? mealType,
    String? emoji,
  }) {
    return MealItem(
      name: name ?? this.name,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      ingredients: ingredients ?? this.ingredients,
      mealType: mealType ?? this.mealType,
      emoji: emoji ?? this.emoji,
    );
  }
}

@HiveType(typeId: 1)
class GroceryItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String quantity;

  @HiveField(2)
  final double estimatedCost;

  @HiveField(3)
  final String category;

  @HiveField(4)
  bool isChecked;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.estimatedCost,
    required this.category,
    this.isChecked = false,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'Other',
      isChecked: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'estimated_cost': estimatedCost,
        'category': category,
        'is_checked': isChecked,
      };
}

@HiveType(typeId: 2)
class NutritionSummary extends HiveObject {
  @HiveField(0)
  final int totalCalories;

  @HiveField(1)
  final double totalProtein;

  @HiveField(2)
  final double totalCarbs;

  @HiveField(3)
  final double totalFat;

  @HiveField(4)
  final String goalSuitability;

  @HiveField(5)
  final int targetCalories;

  NutritionSummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.goalSuitability,
    required this.targetCalories,
  });

  factory NutritionSummary.fromJson(Map<String, dynamic> json) {
    return NutritionSummary(
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
      totalFat: (json['total_fat'] as num?)?.toDouble() ?? 0.0,
      goalSuitability: json['goal_suitability'] as String? ?? '',
      targetCalories: (json['target_calories'] as num?)?.toInt() ?? 2000,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_calories': totalCalories,
        'total_protein': totalProtein,
        'total_carbs': totalCarbs,
        'total_fat': totalFat,
        'goal_suitability': goalSuitability,
        'target_calories': targetCalories,
      };
}

@HiveType(typeId: 3)
class MealPlanModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String goal;

  @HiveField(2)
  final double budgetPerDay;

  @HiveField(3)
  final List<MealItem> meals;

  @HiveField(4)
  final List<GroceryItem> groceryList;

  @HiveField(5)
  final NutritionSummary nutritionSummary;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String preferences;

  @HiveField(8)
  final List<String> allergies;

  @HiveField(9)
  final int mealsPerDay;

  @HiveField(10)
  final String planName;

  @HiveField(11)
  final bool isSaved;

  MealPlanModel({
    required this.id,
    required this.goal,
    required this.budgetPerDay,
    required this.meals,
    required this.groceryList,
    required this.nutritionSummary,
    required this.createdAt,
    required this.preferences,
    required this.allergies,
    required this.mealsPerDay,
    required this.planName,
    this.isSaved = false,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json, {
    required String id,
    required String goal,
    required double budgetPerDay,
    required String preferences,
    required List<String> allergies,
    required int mealsPerDay,
  }) {
    final mealsJson = json['meals'] as List<dynamic>? ?? [];
    final groceryJson = json['grocery_list'] as List<dynamic>? ?? [];

    return MealPlanModel(
      id: id,
      goal: goal,
      budgetPerDay: budgetPerDay,
      meals: mealsJson.map((e) => MealItem.fromJson(e as Map<String, dynamic>)).toList(),
      groceryList: groceryJson.map((e) => GroceryItem.fromJson(e as Map<String, dynamic>)).toList(),
      nutritionSummary: NutritionSummary.fromJson(
        json['nutrition_summary'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: DateTime.now(),
      preferences: preferences,
      allergies: allergies,
      mealsPerDay: mealsPerDay,
      planName: json['plan_name'] as String? ?? 'Meal Plan',
      isSaved: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'goal': goal,
        'budget_per_day': budgetPerDay,
        'meals': meals.map((e) => e.toJson()).toList(),
        'grocery_list': groceryList.map((e) => e.toJson()).toList(),
        'nutrition_summary': nutritionSummary.toJson(),
        'created_at': createdAt.toIso8601String(),
        'preferences': preferences,
        'allergies': allergies,
        'meals_per_day': mealsPerDay,
        'plan_name': planName,
        'is_saved': isSaved,
      };

  MealPlanModel copyWith({
    String? id,
    String? goal,
    double? budgetPerDay,
    List<MealItem>? meals,
    List<GroceryItem>? groceryList,
    NutritionSummary? nutritionSummary,
    DateTime? createdAt,
    String? preferences,
    List<String>? allergies,
    int? mealsPerDay,
    String? planName,
    bool? isSaved,
  }) {
    return MealPlanModel(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      budgetPerDay: budgetPerDay ?? this.budgetPerDay,
      meals: meals ?? this.meals,
      groceryList: groceryList ?? this.groceryList,
      nutritionSummary: nutritionSummary ?? this.nutritionSummary,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
      allergies: allergies ?? this.allergies,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      planName: planName ?? this.planName,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
