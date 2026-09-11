import 'package:flutter/material.dart';
import '../../mock_data.dart';
import '../../models.dart';
import '../../theme.dart';
import '../resident/meal_selection_screen.dart';

class CarerDashboardScreen extends StatefulWidget {
  const CarerDashboardScreen({super.key});

  @override
  State<CarerDashboardScreen> createState() => _CarerDashboardScreenState();
}

class _CarerDashboardScreenState extends State<CarerDashboardScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = residents.where((r) => r.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Residents')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            Text('${residents.length} residents', style: const TextStyle(color: AppColors.subtext)),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search residents',
                prefixIcon: Icon(Icons.search, color: AppColors.subtext),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            for (final r in filtered) _ResidentCard(resident: r),
          ],
        ),
      ),
    );
  }
}

class _ResidentCard extends StatelessWidget {
  const _ResidentCard({required this.resident});
  final Resident resident;

  @override
  Widget build(BuildContext context) {
    final stripe = resident.flag != null ? AppColors.warnText : AppColors.success;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: stripe, width: 4)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.neutralChipBg,
            child: Text(resident.initials, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resident.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text('${resident.room} · ${resident.diagnosis}', style: const TextStyle(color: AppColors.subtext, fontSize: 12.5)),
                const SizedBox(height: 6),
                Tag(
                  resident.flag ?? resident.dietaryTags.first,
                  bg: resident.flag != null ? AppColors.warnBg : AppColors.successBg,
                  fg: resident.flag != null ? AppColors.warnText : AppColors.successText,
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (resident.assistNeeded)
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MealSelectionScreen(slot: MealSlot.lunch)),
              ),
              child: const Text('Assist needed', style: TextStyle(fontSize: 12.5)),
            ),
        ],
      ),
    );
  }
}