import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';

class AnimatedMicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;
  final bool enabled;

  const AnimatedMicButton({
    super.key,
    required this.isListening,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: isListening
          ? Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 36,
              ),
            )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.15, 1.15),
                duration: 600.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.15, 1.15),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.easeInOut,
              )
          : Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: enabled
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                border: Border.all(
                  color: enabled ? AppColors.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.mic,
                color: enabled ? AppColors.primary : Colors.grey,
                size: 36,
              ),
            ),
    );
  }
}
