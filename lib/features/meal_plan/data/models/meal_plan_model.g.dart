

part of 'meal_plan_model.dart';





class MealItemAdapter extends TypeAdapter<MealItem> {
  @override
  final int typeId = 0;

  @override
  MealItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealItem(
      name: fields[0] as String,
      description: fields[1] as String,
      calories: fields[2] as int,
      protein: fields[3] as double,
      carbs: fields[4] as double,
      fat: fields[5] as double,
      estimatedCost: fields[6] as double,
      ingredients: (fields[7] as List).cast<String>(),
      mealType: fields[8] as String,
      emoji: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MealItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.protein)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.fat)
      ..writeByte(6)
      ..write(obj.estimatedCost)
      ..writeByte(7)
      ..write(obj.ingredients)
      ..writeByte(8)
      ..write(obj.mealType)
      ..writeByte(9)
      ..write(obj.emoji);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class GroceryItemAdapter extends TypeAdapter<GroceryItem> {
  @override
  final int typeId = 1;

  @override
  GroceryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroceryItem(
      name: fields[0] as String,
      quantity: fields[1] as String,
      estimatedCost: fields[2] as double,
      category: fields[3] as String,
      isChecked: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GroceryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.estimatedCost)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.isChecked);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class NutritionSummaryAdapter extends TypeAdapter<NutritionSummary> {
  @override
  final int typeId = 2;

  @override
  NutritionSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionSummary(
      totalCalories: fields[0] as int,
      totalProtein: fields[1] as double,
      totalCarbs: fields[2] as double,
      totalFat: fields[3] as double,
      goalSuitability: fields[4] as String,
      targetCalories: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NutritionSummary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalCalories)
      ..writeByte(1)
      ..write(obj.totalProtein)
      ..writeByte(2)
      ..write(obj.totalCarbs)
      ..writeByte(3)
      ..write(obj.totalFat)
      ..writeByte(4)
      ..write(obj.goalSuitability)
      ..writeByte(5)
      ..write(obj.targetCalories);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class MealPlanModelAdapter extends TypeAdapter<MealPlanModel> {
  @override
  final int typeId = 3;

  @override
  MealPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanModel(
      id: fields[0] as String,
      goal: fields[1] as String,
      budgetPerDay: fields[2] as double,
      meals: (fields[3] as List).cast<MealItem>(),
      groceryList: (fields[4] as List).cast<GroceryItem>(),
      nutritionSummary: fields[5] as NutritionSummary,
      createdAt: fields[6] as DateTime,
      preferences: fields[7] as String,
      allergies: (fields[8] as List).cast<String>(),
      mealsPerDay: fields[9] as int,
      planName: fields[10] as String,
      isSaved: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goal)
      ..writeByte(2)
      ..write(obj.budgetPerDay)
      ..writeByte(3)
      ..write(obj.meals)
      ..writeByte(4)
      ..write(obj.groceryList)
      ..writeByte(5)
      ..write(obj.nutritionSummary)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.preferences)
      ..writeByte(8)
      ..write(obj.allergies)
      ..writeByte(9)
      ..write(obj.mealsPerDay)
      ..writeByte(10)
      ..write(obj.planName)
      ..writeByte(11)
      ..write(obj.isSaved);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
