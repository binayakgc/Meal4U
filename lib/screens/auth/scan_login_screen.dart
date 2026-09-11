import 'package:flutter/material.dart';
import '../../theme.dart';
import '../resident/resident_home_screen.dart';

class ScanLoginScreen extends StatefulWidget {
  const ScanLoginScreen({super.key});

  @override
  State<ScanLoginScreen> createState() => _ScanLoginScreenState();
}

class _ScanLoginScreenState extends State<ScanLoginScreen> {
  bool _scanning = false;

  Future<void> _simulateScan() async {
    setState(() => _scanning = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ResidentHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Scan your QR badge',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text('Line the code up inside the frame', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _simulateScan,
              child: Container(
                width: 220,
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: _scanning
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : const Icon(Icons.qr_code_2_rounded, color: Colors.white54, size: 96),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _scanning ? 'Scanning...' : 'Tap the frame to simulate a scan',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}