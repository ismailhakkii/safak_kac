import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/constants.dart';

class ConfettiWidget extends StatefulWidget {
  final List<Color> colors;
  final int count;
  final bool play;

  const ConfettiWidget({
    Key? key,
    this.colors = AppConstants.confettiColors,
    this.count = 50,
    this.play = true,
  }) : super(key: key);

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.longAnimationDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    
    if (widget.play) {
      _controller.repeat(reverse: false);
    }
  }
  
  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.play != oldWidget.play) {
      if (widget.play) {
        _controller.repeat(reverse: false);
      } else {
        _controller.stop();
      }
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
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: 200,
          width: double.infinity,
          child: CustomPaint(
            painter: ConfettiPainter(
              colors: widget.colors,
              count: widget.count,
              progress: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

class _Confetti {
  final Color color;
  final Offset position;
  final double size;
  final double angle;
  final int shape;
  final double speed;

  _Confetti({
    required this.color,
    required this.position,
    required this.size,
    required this.angle,
    required this.shape,
    required this.speed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<Color> colors;
  final int count;
  final double progress;
  final List<_Confetti> confetti = [];
  final math.Random random = math.Random();

  ConfettiPainter({
    required this.colors,
    required this.count,
    required this.progress,
  }) {
    if (confetti.isEmpty) {
      for (int i = 0; i < count; i++) {
        confetti.add(_Confetti(
          color: colors[random.nextInt(colors.length)],
          position: Offset(
            random.nextDouble() * 400 - 50,
            random.nextDouble() * -200 - 50,
          ),
          size: random.nextDouble() * 10 + 5,
          angle: random.nextDouble() * 2 * math.pi,
          shape: random.nextInt(3),
          speed: random.nextDouble() * 3 + 1,
        ));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in confetti) {
      final paint = Paint()..color = particle.color.withOpacity(math.max(0, 1 - progress * 0.7));
      
      // Yeni pozisyon hesapla (aşağı doğru düşüş + yatay hareket)
      final newY = particle.position.dy + progress * 400 * particle.speed;
      final newX = particle.position.dx + math.sin(progress * 10 + particle.angle) * 20;
      
      // Dönüş açısı
      final rotationAngle = particle.angle + progress * 5;
      
      canvas.save();
      canvas.translate(newX, newY);
      canvas.rotate(rotationAngle);
      
      // Çeşitli şekiller çiz
      switch (particle.shape) {
        case 0:
          // Dikdörtgen
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero, 
              width: particle.size, 
              height: particle.size / 2
            ),
            paint,
          );
          break;
        case 1:
          // Daire
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
          break;
        case 2:
          // Üçgen
          final path = Path();
          path.moveTo(0, -particle.size / 2);
          path.lineTo(particle.size / 2, particle.size / 2);
          path.lineTo(-particle.size / 2, particle.size / 2);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}