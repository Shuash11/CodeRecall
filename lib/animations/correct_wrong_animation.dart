import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';

/// An animation wrapper for correct/wrong answer feedback.
/// Shows a green pulse for correct, red shake for wrong.
class CorrectWrongAnimation extends StatefulWidget {
  final bool isCorrect;
  final bool showFeedback;
  final Widget child;

  const CorrectWrongAnimation({
    super.key,
    required this.isCorrect,
    required this.showFeedback,
    required this.child,
  });

  @override
  State<CorrectWrongAnimation> createState() => _CorrectWrongAnimationState();
}

class _CorrectWrongAnimationState extends State<CorrectWrongAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseScale;
  late Animation<double> _shakeOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(CorrectWrongAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFeedback && !oldWidget.showFeedback) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Color? borderColor;
        if (_controller.value > 0) {
          borderColor = widget.isCorrect ? AppColors.correct : AppColors.wrong;
        }

        Widget animatedChild = widget.child;

        if (widget.isCorrect) {
          animatedChild = Transform.scale(
            scale: 1.0 + (_pulseScale.value - 1.0) * _controller.value,
            child: animatedChild,
          );
        } else {
          animatedChild = Transform.translate(
            offset: Offset(_shakeOffset.value * _controller.value, 0),
            child: animatedChild,
          );
        }

        if (borderColor != null) {
          animatedChild = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 2),
            ),
            child: animatedChild,
          );
        }

        return animatedChild;
      },
    );
  }
}
