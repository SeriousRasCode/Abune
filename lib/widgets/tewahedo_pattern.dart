import 'package:flutter/material.dart';

/// A quiet geometric border inspired by Ethiopian Orthodox cross ornament.
class TewahedoPattern extends StatelessWidget {
  const TewahedoPattern({this.height = 18, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _PatternPainter(Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  const _PatternPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = size.height / 2;
    for (double x = 0; x < size.width + 24; x += 24) {
      final diamond = Path()
        ..moveTo(x, center)
        ..lineTo(x + 8, center - 7)
        ..lineTo(x + 16, center)
        ..lineTo(x + 8, center + 7)
        ..close();
      canvas.drawPath(diamond, paint);
      canvas.drawLine(Offset(x + 8, center - 4), Offset(x + 8, center + 4), paint);
      canvas.drawLine(Offset(x + 4, center), Offset(x + 12, center), paint);
      canvas.drawLine(Offset(x + 16, center), Offset(x + 24, center), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) => oldDelegate.color != color;
}
