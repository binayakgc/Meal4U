import 'package:flutter/material.dart';

/// The three meal times a resident orders for each day.
enum MealSlot { breakfast, lunch, dinner }

extension MealSlotX on MealSlot {
  String get label => switch (this) {
        MealSlot.breakfast => 'Breakfast',
        MealSlot.lunch => 'Lunch',
        MealSlot.dinner => 'Dinner',
      };
}

/// Whether a meal has been served, is the resident's current pick, or
/// hasn't been chosen yet.
enum MealStatus { served, current, noSelection }

/// A single choosable food item (a main, a vegetable side, or a drink).
class FoodItem {
  const FoodItem({
    required this.name,
    required this.colors,
    this.imageAsset,
    this.warning,
  });

  final String name;
  final List<Color> colors;
  final String? imageAsset;

  /// Set when this item conflicts with a dietary note, e.g. "Diabetic".
  final String? warning;
}

/// A category of choosable items shown together, e.g. "Main" or "Drink".
class FoodCategory {
  const FoodCategory({required this.title, required this.items});
  final String title;
  final List<FoodItem> items;
}

/// A resident's meal for one slot (breakfast/lunch/dinner) on one day.
class MealPlan {
  MealPlan({
    required this.slot,
    required this.time,
    required this.status,
    required this.categories,
    this.selected = const {},
    this.dietaryNote,
  });

  final MealSlot slot;
  final String time;
  MealStatus status;
  final List<FoodCategory> categories;

  /// Category title -> the item picked for it, e.g. {"Main": roastChicken}.
  Map<String, FoodItem> selected;
  final String? dietaryNote;

  FoodItem? get main => selected['Main'];
}

/// A resident using the app.
class Resident {
  const Resident({
    required this.name,
    required this.initials,
    required this.room,
    required this.ward,
    required this.diagnosis,
    required this.dietaryTags,
    this.assistNeeded = false,
    this.flag,
  });

  final String name;
  final String initials;
  final String room;
  final String ward;
  final String diagnosis;
  final List<String> dietaryTags;
  final bool assistNeeded;

  /// A short warning label shown on the carer's residents list, e.g. "Allergy risk".
  final String? flag;
}