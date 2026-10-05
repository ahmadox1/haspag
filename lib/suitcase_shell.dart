import 'package:flutter/material.dart';

const suitcaseInk = Color(0xFF382639);

/// Decorative luggage details are painted, so they never intercept key taps.
class SuitcaseShell extends StatelessWidget {
  const SuitcaseShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 48, 8, 24),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: -42,
              child: Container(
                width: 116,
                height: 62,
                decoration: BoxDecoration(
                  border: Border.all(color: suitcaseInk, width: 9),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFEEA9CC),
                ),
              ),
            ),
            for (final left in [true, false])
              Positioned(
                bottom: -18,
                left: left ? 35 : null,
                right: left ? null : 35,
                child: Container(
                  width: 32,
                  height: 38,
                  decoration: BoxDecoration(
                    color: suitcaseInk,
                    border: Border.all(color: const Color(0xFF705369), width: 5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFDAED), Color(0xFFF185B9), Color(0xFFD95298)],
                  stops: [0, 0.45, 1],
                ),
                border: Border.all(color: suitcaseInk, width: 5),
                borderRadius: BorderRadius.circular(38),
                boxShadow: const [
                  BoxShadow(color: Color(0x40382639), blurRadius: 22, offset: Offset(0, 12)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ExcludeSemantics(
                    child: SizedBox(
                      height: 104,
                      width: double.infinity,
                      child: CustomPaint(painter: _CatPainter()),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ],
        ),
      );
}

class _CatPainter extends CustomPainter {
  const _CatPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / 104);
    final outline = Paint()
      ..color = suitcaseInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final ear = Paint()..color = const Color(0xFFAE397C);
    for (final mirrored in [false, true]) {
      canvas.save();
      if (mirrored) {
        canvas.translate(320, 0);
        canvas.scale(-1, 1);
      }
      final path = Path()..moveTo(45, 32)..lineTo(51, 4)..quadraticBezierTo(69, 8, 82, 24);
      canvas.drawPath(path, ear);
      canvas.drawPath(path, outline);
      canvas.drawOval(const Rect.fromLTWH(65, 29, 66, 42), Paint()..color = Colors.white);
      canvas.drawOval(const Rect.fromLTWH(65, 29, 66, 42), outline);
      canvas.drawOval(const Rect.fromLTWH(89, 30, 28, 40), Paint()..color = const Color(0xFF35B9ED));
      canvas.drawOval(const Rect.fromLTWH(99, 33, 12, 33), Paint()..color = suitcaseInk);
      canvas.drawCircle(const Offset(99, 40), 5, Paint()..color = Colors.white);
      canvas.drawLine(const Offset(66, 40), const Offset(58, 33), outline);
      canvas.drawLine(const Offset(73, 32), const Offset(67, 24), outline);
      canvas.drawLine(const Offset(51, 73), const Offset(99, 80), outline);
      canvas.drawLine(const Offset(56, 91), const Offset(99, 86), outline);
      canvas.restore();
    }
    final nose = Path()..moveTo(150, 69)..quadraticBezierTo(160, 64, 170, 69)..lineTo(160, 78)..close();
    canvas.drawPath(nose, Paint()..color = suitcaseInk);
    canvas.drawPath(Path()..moveTo(140, 83)..quadraticBezierTo(150, 95, 160, 78)..quadraticBezierTo(170, 95, 180, 83), outline);
    final sparkle = Paint()..color = const Color(0xDDFFFFFF);
    for (final point in [const Offset(24, 47), const Offset(289, 20)]) {
      canvas.drawPath(Path()..moveTo(point.dx, point.dy - 9)..lineTo(point.dx + 3, point.dy - 3)..lineTo(point.dx + 9, point.dy)..lineTo(point.dx + 3, point.dy + 3)..lineTo(point.dx, point.dy + 9)..lineTo(point.dx - 3, point.dy + 3)..lineTo(point.dx - 9, point.dy)..lineTo(point.dx - 3, point.dy - 3)..close(), sparkle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CatPainter oldDelegate) => false;
}
