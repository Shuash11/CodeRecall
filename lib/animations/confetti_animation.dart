import 'dart:math';
import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';

/// A confetti burst animation widget displayed on level-up events.
class ConfettiAnimation extends StatefulWidget {
  final bool trigger;
  final Widget? child;

  const ConfettiAnimation({
    super.key,
    this.trigger = false,
    this.child,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiPiece> _pieces = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _pieces.clear());
      }
    });
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _generatePieces();
      _controller.forward(from: 0);
    }
  }

  void _generatePieces() {
    _pieces.clear();
    const colors = [
      AppColors.accent,
      AppColors.correct,
      AppColors.xpGold,
      AppColors.wrong,
      Colors.purple,
      Colors.cyan,
    ];

    for (int i = 0; i < 40; i++) {
      _pieces.add(_ConfettiPiece(
        color: colors[_random.nextInt(colors.length)],
        startX: _random.nextDouble(),
        startY: 0.3 + _random.nextDouble() * 0.3,
        velocityX: (_random.nextDouble() - 0.5) * 2,
        velocityY: -1 - _random.nextDouble() * 2,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        size: 4 + _random.nextDouble() * 6,
      ));
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
        return Stack(
          children: [
            if (widget.child != null) widget.child!,
            if (_pieces.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ConfettiPainter(
                      pieces: _pieces,
                      progress: _controller.value,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ConfettiPiece {
  final Color color;
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
  final double size;

  _ConfettiPiece({
    required this.color,
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final piece in pieces) {
      final x = (piece.startX + piece.velocityX * progress * 0.5) * size.width;
      final y = (piece.startY + piece.velocityY * progress * 0.3) * size.height;
      final rotation = piece.rotation + piece.rotationSpeed * progress;
      final alpha = (1 - progress).clamp(0.0, 1.0);

      paint.color = piece.color.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
