import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE0714B);
  static const Color background = Color(0xFFF8F1E1);
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF2A2420);
  static const Color subtext = Color(0xFF8A8078);
  static const Color divider = Color(0xFFE9DFCE);

  static const Color success = Color(0xFF6FA98A);
  static const Color successBg = Color(0xFFDCEEE3);
  static const Color successText = Color(0xFF3E7A5D);

  static const Color warnBg = Color(0xFFF6D9D6);
  static const Color warnText = Color(0xFFB23B32);

  static const Color cautionBg = Color(0xFFF3D9B1);
  static const Color cautionText = Color(0xFF8A5A20);

  static const Color neutralChipBg = Color(0xFFEDE6D8);
  static const Color neutralChipText = Color(0xFF5B5349);
}

/// A meal item's thumbnail: shows a real bundled photo when one is given,
/// otherwise falls back to a coloured gradient + emoji tile.
class MealThumb extends StatelessWidget {
  const MealThumb({
    super.key,
    required this.emoji,
    required this.colors,
    this.imageAsset,
    this.size = 64,
    this.radius = 14,
  });

  final String emoji;
  final List<Color> colors;
  final String? imageAsset;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: imageAsset != null
            ? Image.asset(imageAsset!, fit: BoxFit.cover)
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: TextStyle(fontSize: size * 0.42)),
              ),
      ),
    );
  }
}

/// A small colored chip used for dietary tags like "Low sodium" or "Served".
class Tag extends StatelessWidget {
  const Tag(
    this.label, {
    super.key,
    this.bg = AppColors.neutralChipBg,
    this.fg = AppColors.neutralChipText,
    this.dense = false,
  });

  final String label;
  final Color bg;
  final Color fg;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : 12,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: dense ? 11 : 12.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// A small tappable "speaker" icon used next to meal names for text-to-speech.
class SpeakerIcon extends StatelessWidget {
  const SpeakerIcon({super.key, this.onTap, this.color = AppColors.primary});

  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(Icons.volume_up_rounded, color: color, size: 20),
      ),
    );
  }
}