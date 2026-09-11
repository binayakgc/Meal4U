import 'package:flutter/material.dart';
import '../theme.dart';

/// Simulates a text-to-speech readout: shows a brief animated "speaking"
/// bubble with the text that would be read aloud.
void simulateSpeech(BuildContext context, String text) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _SpeechBubble(text: text, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _SpeechBubble extends StatefulWidget {
  const _SpeechBubble({required this.text, required this.onDone});
  final String text;
  final VoidCallback onDone;

  @override
  State<_SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<_SpeechBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 220))..forward();
    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 32,
      child: FadeTransition(
        opacity: _controller,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: AppColors.dark, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 13.5))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}