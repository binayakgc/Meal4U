import 'package:flutter/material.dart';
import '../../theme.dart';
import 'scan_login_screen.dart';
import 'staff_login_screen.dart';

class ResidentLoginScreen extends StatefulWidget {
  const ResidentLoginScreen({super.key});

  @override
  State<ResidentLoginScreen> createState() => _ResidentLoginScreenState();
}

class _ResidentLoginScreenState extends State<ResidentLoginScreen> {
  final _roomController = TextEditingController(text: '214');
  final _pinController = TextEditingController(text: '••••');

  @override
  void dispose() {
    _roomController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _login() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Home dashboard goes here next')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ScanLoginScreen()),
                  ),
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                  label: const Text('Scan'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Meal4U',
                style: TextStyle(color: AppColors.primary, fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 24),
              const Text('Welcome back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Log in to see your meals for today', style: TextStyle(color: AppColors.subtext)),
              const SizedBox(height: 24),
              const Text('Room ID', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(controller: _roomController, keyboardType: TextInputType.number),
              const SizedBox(height: 18),
              const Text('Pin', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(controller: _pinController, obscureText: true, keyboardType: TextInputType.number),
              const SizedBox(height: 26),
              ElevatedButton(onPressed: _login, child: const Text('Log in')),
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StaffLoginScreen()),
                  ),
                  child: const Text(
                    'Kitchen or care staff? Use staff login',
                    style: TextStyle(color: AppColors.subtext),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}