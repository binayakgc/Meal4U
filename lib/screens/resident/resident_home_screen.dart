import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets/bottom_nav.dart';
import 'meal_selection_screen.dart';
import '../../widgets/speech_simulator.dart';
import '../auth/resident_login_screen.dart';

/// Shell for the resident app: a persistent bottom nav switching between
/// the Home dashboard and the Menu day view.
class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const _DashboardTab(), const _MenuTab()];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tab, children: pages),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        destinations: residentNavDestinations,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.residentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        app.residentRoom,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const ResidentLoginScreen()),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  tooltip: 'Log out',
                ),
              ],
            ),
          ),
          for (final slot in MealSlot.values)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _MealCard(slot: slot, plan: app.mealFor(slot)),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.slot, required this.plan});
  final MealSlot slot;
  final MealPlan plan;

  @override
  Widget build(BuildContext context) {
    final main = plan.main;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          if (main != null)
            MealThumb(
              emoji: main.emoji,
              colors: main.colors,
              imageAsset: main.imageAsset,
            )
          else
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.neutralChipBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.subtext,
              ),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        slot.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SpeakerIcon(onTap: () => _speak(context, slot, plan)),
                  ],
                ),
                Text(
                  plan.time,
                  style: const TextStyle(
                    color: AppColors.subtext,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 6),
                _statusTag(plan.status),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _actionButton(context, slot, plan),
        ],
      ),
    );
  }

  void _speak(BuildContext context, MealSlot slot, MealPlan plan) {
    final text = plan.main != null
        ? '${slot.label}. ${plan.main!.name}.'
        : '${slot.label}. Nothing selected yet.';
    simulateSpeech(context, text);
  }

  Widget _statusTag(MealStatus status) {
    return switch (status) {
      MealStatus.served => const Tag(
        'Served',
        bg: AppColors.successBg,
        fg: AppColors.successText,
        dense: true,
      ),
      MealStatus.current => const Tag(
        'Current',
        bg: AppColors.cautionBg,
        fg: AppColors.cautionText,
        dense: true,
      ),
      MealStatus.noSelection => const Tag(
        'No selection',
        bg: AppColors.warnBg,
        fg: AppColors.warnText,
        dense: true,
      ),
    };
  }

  Widget _actionButton(BuildContext context, MealSlot slot, MealPlan plan) {
    if (plan.status == MealStatus.served) {
      return OutlinedButton(
        onPressed: () => _showDetailsSheet(context, plan),
        child: const Text('Details'),
      );
    }
    final label = plan.status == MealStatus.current
        ? 'Change meal'
        : 'Select now';
    return ElevatedButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MealSelectionScreen(slot: slot)),
      ),
      child: Text(label),
    );
  }

  void _showDetailsSheet(BuildContext context, MealPlan plan) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.main?.name ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Served at ${plan.time}',
              style: const TextStyle(color: AppColors.subtext),
            ),
            if (plan.dietaryNote != null) ...[
              const SizedBox(height: 10),
              Tag(plan.dietaryNote!, dense: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuTab extends StatelessWidget {
  const _MenuTab();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    const days = ['Today', 'Tomorrow', 'Day after'];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.neutralChipBg,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < days.length; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => app.setDayOffset(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: app.dayOffset == i
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            days[i],
                            style: TextStyle(
                              color: app.dayOffset == i
                                  ? Colors.white
                                  : AppColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            for (final slot in MealSlot.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _MenuRow(slot: slot, plan: app.mealFor(slot)),
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.slot, required this.plan});
  final MealSlot slot;
  final MealPlan plan;

  @override
  Widget build(BuildContext context) {
    final main = plan.main;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (main != null)
            MealThumb(
              emoji: main.emoji,
              colors: main.colors,
              imageAsset: main.imageAsset,
              size: 56,
            )
          else
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.neutralChipBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.subtext,
              ),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.label,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  main?.name ?? 'Not chosen yet',
                  style: const TextStyle(
                    color: AppColors.subtext,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
