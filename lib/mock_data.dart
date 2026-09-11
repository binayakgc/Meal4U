import 'package:flutter/material.dart';
import 'models.dart';

/// Static demo data. Nothing here talks to a network or backend.
class Foods {
  Foods._();

  static const roastChicken = FoodItem(
    name: 'Roast chicken',
    emoji: '🍗',
    colors: [Color(0xFFE7B27B), Color(0xFFC97B4A)],
    imageAsset: 'assets/images/roast_chicken.jpg',
  );
  static const bakedFish = FoodItem(
    name: 'Baked fish',
    emoji: '🐟',
    colors: [Color(0xFF7FBFA0), Color(0xFF3E8F72)],
    imageAsset: 'assets/images/baked_fish.jpg',
  );
  static const vegCurry = FoodItem(
    name: 'Veg curry',
    emoji: '🍛',
    colors: [Color(0xFFE7C36B), Color(0xFFC98F3A)],
    imageAsset: 'assets/images/veg_curry.jpg',
  );

  static const steamedGreens = FoodItem(
    name: 'Steamed greens',
    emoji: '🥦',
    colors: [Color(0xFF9BCB8C), Color(0xFF5E9E52)],
    imageAsset: 'assets/images/steamed_greens.jpg',
  );
  static const mashPotato = FoodItem(
    name: 'Mash potato',
    emoji: '🥔',
    colors: [Color(0xFFEFE3C6), Color(0xFFD8C89B)],
    imageAsset: 'assets/images/mash_potato.jpg',
  );
  static const roastPumpkin = FoodItem(
    name: 'Roast pumpkin',
    emoji: '🎃',
    colors: [Color(0xFFEFA24B), Color(0xFFCB6E22)],
    imageAsset: 'assets/images/roast_pumpkin.jpg',
  );

  static const water = FoodItem(
    name: 'Water',
    emoji: '💧',
    colors: [Color(0xFFCBE0EE), Color(0xFF9BBFD6)],
    imageAsset: 'assets/images/water.jpg',
  );
  static const appleJuice = FoodItem(
    name: 'Apple juice',
    emoji: '🧃',
    colors: [Color(0xFF3A2E28), Color(0xFF1E1714)],
    imageAsset: 'assets/images/apple_juice.jpg',
    warning: 'Diabetic',
  );
  static const tea = FoodItem(
    name: 'Tea',
    emoji: '🍵',
    colors: [Color(0xFFCDBBA0), Color(0xFFA98F6C)],
    imageAsset: 'assets/images/tea.jpg',
  );
}

MealPlan buildBreakfast() => MealPlan(
      slot: MealSlot.breakfast,
      time: '7:30am',
      status: MealStatus.served,
      categories: const [],
      selected: {'Main': Foods.roastChicken},
      dietaryNote: 'Soft texture',
    );

MealPlan buildLunch() => MealPlan(
      slot: MealSlot.lunch,
      time: '12:30pm',
      status: MealStatus.current,
      dietaryNote: 'No shellfish',
      categories: const [
        FoodCategory(title: 'Main', items: [Foods.roastChicken, Foods.bakedFish, Foods.vegCurry]),
        FoodCategory(title: 'Vegetable', items: [Foods.steamedGreens, Foods.mashPotato, Foods.roastPumpkin]),
        FoodCategory(title: 'Drink', items: [Foods.water, Foods.appleJuice, Foods.tea]),
      ],
      selected: {
        'Main': Foods.roastChicken,
        'Vegetable': Foods.steamedGreens,
        'Drink': Foods.water,
      },
    );

MealPlan buildDinner() => MealPlan(
      slot: MealSlot.dinner,
      time: '6:00pm',
      status: MealStatus.noSelection,
      dietaryNote: 'Low sodium',
      categories: const [
        FoodCategory(title: 'Main', items: [Foods.roastChicken, Foods.bakedFish, Foods.vegCurry]),
        FoodCategory(title: 'Vegetable', items: [Foods.steamedGreens, Foods.mashPotato, Foods.roastPumpkin]),
        FoodCategory(title: 'Drink', items: [Foods.water, Foods.appleJuice, Foods.tea]),
      ],
    );

const margaretWilson = Resident(
  name: 'Margaret Wilson',
  initials: 'MW',
  room: 'Room 214',
  ward: 'Sunflower Wing',
  diagnosis: 'Type 2 diabetes',
  dietaryTags: ['Low sodium', 'Diabetic', 'Soft texture'],
  assistNeeded: true,
  flag: 'Allergy risk',
);

const jamesBrennan = Resident(
  name: 'James Brennan',
  initials: 'JB',
  room: 'Room 208',
  ward: 'Sunflower Wing',
  diagnosis: 'Dysphagia',
  dietaryTags: ['Soft texture'],
  assistNeeded: true,
);

const eleanorKing = Resident(
  name: 'Eleanor King',
  initials: 'EK',
  room: 'Room 221',
  ward: 'Sunflower Wing',
  diagnosis: 'Low mobility',
  dietaryTags: ['Low sodium'],
  assistNeeded: false,
);

const robertTan = Resident(
  name: 'Robert Tan',
  initials: 'RT',
  room: 'Room 219',
  ward: 'Sunflower Wing',
  diagnosis: 'Nut allergy',
  dietaryTags: ['No nuts'],
  assistNeeded: true,
  flag: 'Anaphylaxis risk',
);

const residents = [margaretWilson, jamesBrennan, eleanorKing, robertTan];