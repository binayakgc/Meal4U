import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/speech_simulator.dart';
import 'voice_listening_screen.dart';

class MealSelectionScreen extends StatelessWidget {
  const MealSelectionScreen({super.key, required this.slot});
  final MealSlot slot;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final plan = app.mealFor(slot);

    return Scaffold(
      appBar: AppBar(title: Text('Select your ${slot.label.toLowerCase()}')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.warnBg, borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your dietary notes', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.warnText)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        Tag('Low sodium', bg: Color(0xFFEFC9C4), fg: AppColors.warnText),
                        Tag('Diabetic', bg: Color(0xFFEFC9C4), fg: AppColors.warnText),
                        Tag('Soft texture', bg: AppColors.cautionBg, fg: AppColors.cautionText),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _applyRecommendation(context, app, plan),
                icon: const Icon(Icons.health_and_safety_outlined),
                label: const Text('Choose for me based on my dietary needs'),
              ),
              const SizedBox(height: 18),
              for (final category in plan.categories)
                _CategorySection(
                  category: category,
                  selected: plan.selected[category.title],
                  onSelect: (item) => _handleSelect(context, app, category.title, item),
                  onSpeak: () => _speakCategory(context, category),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: plan.selected.length >= plan.categories.length
                      ? () {
                          app.confirmMeal(slot);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Confirm my selection'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        final result = await Navigator.of(context).push<Map<String, FoodItem>>(
                          MaterialPageRoute(builder: (_) => const VoiceListeningScreen()),
                        );
                        if (result != null) {
                          for (final entry in result.entries) {
                            app.updateSelection(slot, entry.key, entry.value);
                          }
                        }
                      },
                      child: const CircleAvatar(radius: 26, backgroundColor: AppColors.primary, child: Icon(Icons.mic_none_rounded, color: Colors.white)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap to talk', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSelect(BuildContext context, AppState app, String category, FoodItem item) {
    if (item.warning != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${item.warning} caution'),
          content: Text('${item.name} may not suit this resident\'s ${item.warning!.toLowerCase()} dietary note. Select anyway?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                app.updateSelection(slot, category, item);
              },
              child: const Text('Select anyway'),
            ),
          ],
        ),
      );
    } else {
      app.updateSelection(slot, category, item);
    }
  }

  void _applyRecommendation(BuildContext context, AppState app, MealPlan plan) {
    for (final category in plan.categories) {
      final safeItem = category.items.firstWhere(
        (item) => item.warning == null,
        orElse: () => category.items.first,
      );
      app.updateSelection(slot, category.title, safeItem);
    }
    simulateSpeech(context, "I've chosen options that suit your dietary needs.");
  }

  void _speakCategory(BuildContext context, FoodCategory category) {
    final names = category.items.map((i) => i.name).toList();
    final optionsText = names.length <= 1
        ? names.join()
        : '${names.sublist(0, names.length - 1).join(', ')} or ${names.last}';
    simulateSpeech(context, '${category.title}. Would you like $optionsText?');
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.selected,
    required this.onSelect,
    required this.onSpeak,
  });
  final FoodCategory category;
  final FoodItem? selected;
  final ValueChanged<FoodItem> onSelect;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(category.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ),
              SpeakerIcon(onTap: onSpeak),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final item in category.items) ...[
                Expanded(child: _FoodTile(item: item, selected: selected == item, onTap: () => onSelect(item))),
                if (item != category.items.last) const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodTile extends StatelessWidget {
  const _FoodTile({required this.item, required this.selected, required this.onTap});
  final FoodItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isWarning = item.warning != null;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? AppColors.primary : (isWarning ? AppColors.warnText : Colors.transparent),
                    width: 2,
                  ),
                ),
                child: MealThumb(colors: item.colors, imageAsset: item.imageAsset, size: 88, radius: 12),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : (isWarning ? AppColors.warnText : Colors.transparent),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : (isWarning ? const Icon(Icons.priority_high_rounded, size: 13, color: Colors.white) : null),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}