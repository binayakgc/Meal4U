import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'models.dart';

enum StaffRole { carer, kitchen }

/// Shared app state: today's meals for the resident, plus which staff role
/// is currently signed in. Everything is in-memory only — it resets when
/// the app restarts, since there's no backend.
class AppState extends ChangeNotifier {
  String residentName = 'Margaret Wilson';
  String residentRoom = 'Room 214';

  StaffRole staffRole = StaffRole.carer;

  final Map<MealSlot, MealPlan> meals = {
    MealSlot.breakfast: buildBreakfast(),
    MealSlot.lunch: buildLunch(),
    MealSlot.dinner: buildDinner(),
  };

  int dayOffset = 0; // 0 = today, 1 = tomorrow, 2 = day after

  void setDayOffset(int value) {
    dayOffset = value;
    notifyListeners();
  }

  MealPlan mealFor(MealSlot slot) => meals[slot]!;

  void updateSelection(MealSlot slot, String category, FoodItem item) {
    final plan = meals[slot]!;
    plan.selected = {...plan.selected, category: item};
    notifyListeners();
  }

  void confirmMeal(MealSlot slot) {
    meals[slot]!.status = MealStatus.current;
    notifyListeners();
  }
}