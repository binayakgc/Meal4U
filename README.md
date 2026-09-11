# Meal4U

A Flutter prototype for an aged-care meal ordering system, covering the
resident ordering flow and the two staff-facing apps (carer and kitchen).

This is a **static, offline hi-fidelity prototype** — there is no backend or
database. All data is defined in `lib/mock_data.dart` and lives only in
memory while the app is running; it resets every time the app restarts.

## Features

### Resident app
- Login with Room ID + PIN, or a simulated "Scan to login" QR badge screen
- Home dashboard showing the resident's meals for the day (Breakfast, Lunch,
  Dinner) with their current status and a matching action (Details / Change
  meal / Select now), plus a logout button
- Menu day view with Today / Tomorrow / Day after tabs
- Meal selection screen for picking a Main, Vegetable, and Drink, with:
  - a caution dialog when a choice conflicts with the resident's dietary
    notes (e.g. a diabetic-flagged drink)
  - a speaker icon per category that reads out the available options
    (e.g. "Main. Would you like Roast chicken, Baked fish or Veg curry?")
  - a "Choose for me based on my dietary needs" button that automatically
    picks a safe option in every category
- Simulated voice ordering ("Tap to talk")
- Simulated text-to-speech: speaker icons read meals and options aloud via
  an animated caption bubble

### Carer app
- Shared staff login (Staff ID + Password) with a Carer/Kitchen toggle
- Searchable residents list showing dietary flags and an "Assist needed"
  action for residents who can't order for themselves
- Logout button back to staff login

### Kitchen app
- Today's orders for the current meal service
- A countdown to serving time and order counts
- A "Mark served" toggle per resident
- Logout button back to staff login

## Getting started

```bash
flutter pub get
flutter run
```

Any text can be entered in the login screens — there is no real
authentication, it's just a gate between the resident and staff sides of the
prototype.

## Project structure

```
lib/
├── main.dart                          App entry point, wires up shared state
├── app_state.dart                     Shared meal state + staff role (Provider)
├── models.dart                        Data shapes: MealSlot, FoodItem, MealPlan, Resident
├── mock_data.dart                     Demo food items and residents
├── theme.dart                         Colors and shared widgets (MealThumb, Tag, SpeakerIcon)
├── widgets/
│   ├── bottom_nav.dart                Resident Home/Menu tab bar
│   └── speech_simulator.dart          Text-to-speech caption bubble
└── screens/
    ├── auth/                          Resident login, scan login, staff login
    ├── resident/                      Home dashboard, menu, meal selection, voice ordering
    ├── carer/                         Residents list
    └── kitchen/                       Kitchen dashboard
```

## Tech stack

- Flutter / Dart
- [`provider`](https://pub.dev/packages/provider) for shared app state

## Assets

Food photos in `assets/images/` are sourced from Wikimedia Commons under
their respective free licenses.
