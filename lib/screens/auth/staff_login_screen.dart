import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../theme.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _idController = TextEditingController(text: 'S-1042');
  final _passwordController = TextEditingController(text: '••••••');
  StaffRole _role = StaffRole.carer;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AppState>().staffRole = _role;
    final label = _role == StaffRole.carer ? 'Carer dashboard' : 'Kitchen dashboard';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(body: Center(child: Text('$label goes here next'))),
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
              const SizedBox(height: 24),
              const Text(
                'Meal4U',
                style: TextStyle(color: AppColors.primary, fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 24),
              const Text('Staff login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Sign in to manage meals', style: TextStyle(color: AppColors.subtext)),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.neutralChipBg, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Expanded(child: _roleSegment('Carer', StaffRole.carer)),
                    Expanded(child: _roleSegment('Kitchen', StaffRole.kitchen)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text('Staff ID', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(controller: _idController),
              const SizedBox(height: 18),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(controller: _passwordController, obscureText: true),
              const SizedBox(height: 26),
              ElevatedButton(onPressed: _login, child: const Text('Log in')),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Resident? Use resident login', style: TextStyle(color: AppColors.subtext)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleSegment(String label, StaffRole value) {
    final selected = _role == value;
    return GestureDetector(
      onTap: () => setState(() => _role = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}