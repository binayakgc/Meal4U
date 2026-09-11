import 'package:flutter/material.dart';
import '../../theme.dart';
import '../auth/staff_login_screen.dart';

class KitchenOrder {
  KitchenOrder({required this.name, required this.room, required this.items, required this.tag, this.served = false});
  final String name;
  final String room;
  final String items;
  final String tag;
  bool served;
}

class KitchenDashboardScreen extends StatefulWidget {
  const KitchenDashboardScreen({super.key});

  @override
  State<KitchenDashboardScreen> createState() => _KitchenDashboardScreenState();
}

class _KitchenDashboardScreenState extends State<KitchenDashboardScreen> {
  final List<KitchenOrder> _orders = [
    KitchenOrder(name: 'Margaret Wilson', room: 'Room 214', items: 'Roast chicken, mash, greens', tag: 'Low sodium'),
    KitchenOrder(name: 'James Brennan', room: 'Room 208', items: 'Roast chicken (minced), gravy', tag: 'Soft texture'),
    KitchenOrder(name: 'Eleanor King', room: 'Room 221', items: 'Baked fish, potato, greens', tag: 'Low sodium', served: true),
    KitchenOrder(name: 'Robert Tan', room: 'Room 219', items: 'Veg curry, rice', tag: 'No nuts'),
  ];

  @override
  Widget build(BuildContext context) {
    final servedCount = _orders.where((o) => o.served).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen · Lunch service'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const StaffLoginScreen()),
              (route) => false,
            ),
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: AppColors.cautionBg, shape: BoxShape.circle),
                    child: const Icon(Icons.access_time_rounded, color: AppColors.cautionText),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Serving in 12 minutes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('Service starts 12:30pm', style: TextStyle(color: AppColors.subtext, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _StatTile(count: '${_orders.length}', label: 'Total orders')),
                const SizedBox(width: 12),
                Expanded(child: _StatTile(count: '$servedCount', label: 'Served so far')),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Orders', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 10),
            for (final order in _orders) _OrderCard(order: order, onToggle: () => setState(() => order.served = !order.served)),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.count, required this.label});
  final String count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.subtext, fontSize: 11.5)),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onToggle});
  final KitchenOrder order;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(order.room, style: const TextStyle(color: AppColors.subtext, fontSize: 12.5)),
                Text(order.items, style: const TextStyle(color: AppColors.subtext, fontSize: 12.5)),
                const SizedBox(height: 6),
                Tag(order.tag, bg: AppColors.warnBg, fg: AppColors.warnText, dense: true),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (order.served)
            const Tag('Served', bg: AppColors.successBg, fg: AppColors.successText)
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              onPressed: onToggle,
              child: const Text('Mark served', style: TextStyle(fontSize: 12.5)),
            ),
        ],
      ),
    );
  }
}