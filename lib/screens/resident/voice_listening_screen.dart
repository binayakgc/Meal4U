import 'package:flutter/material.dart';
import '../../mock_data.dart';
import '../../theme.dart';

/// Simulated voice ordering. Returns a map of category -> chosen item when
/// the resident confirms, or null if they cancel.
class VoiceListeningScreen extends StatelessWidget {
  const VoiceListeningScreen({super.key});

  static const _transcript = "I'd like the roast chicken with mashed potato please";
  static const _heard = {'Main': Foods.roastChicken, 'Vegetable': Foods.mashPotato};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 22),
              const Text('Listening...', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text("Say what you'd like to eat", style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                child: const Text(_transcript, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_heard),
                  child: const Text('Confirm this order'),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}