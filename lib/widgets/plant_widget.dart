import 'dart:math';
import 'package:flutter/material.dart';
import '../models/plant_state.dart';

class PlantWidget extends StatefulWidget {
  final PlantState plantState;
  final bool showWaterEffect;

  const PlantWidget({
    super.key,
    required this.plantState,
    this.showWaterEffect = false,
  });

  @override
  State<PlantWidget> createState() => _PlantWidgetState();
}

class _PlantWidgetState extends State<PlantWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _particleController;
  late Animation<double> _floatAnim;
  final List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _spawnParticles();
  }

  void _spawnParticles() {
    _particles.clear();
    for (int i = 0; i < 22; i++) {
      _particles.add(_Particle(
        xOffset: (_rng.nextDouble() * 2 - 1) * 60,
        // 스택 260px 기준: 위 10~15% → 식물이 있는 55~78% 지점까지 낙하
        startYRatio: 0.06 + _rng.nextDouble() * 0.10,
        endYRatio: 0.55 + _rng.nextDouble() * 0.23,
        radius: 3.5 + _rng.nextDouble() * 5.5,
        delay: _rng.nextDouble() * 0.36,
        color: _pastelDropColor(),
      ));
    }
  }

  Color _pastelDropColor() {
    const options = [
      Color(0xBBAED6F1),
      Color(0xBBB5EAD7),
      Color(0xBBC7ECEE),
      Color(0xBBD6EAF8),
      Color(0xBBA9CCE3),
      Color(0xBBACDDC8),
    ];
    return options[_rng.nextInt(options.length)];
  }

  @override
  void didUpdateWidget(PlantWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showWaterEffect && !oldWidget.showWaterEffect) {
      _spawnParticles();
      _particleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildPot(),
        // Positioned must be a direct Stack child — AnimatedBuilder wraps Transform inside it
        Positioned(
          bottom: 58,
          child: AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: child,
            ),
            child: Text(
              widget.plantState.stageEmoji,
              style: TextStyle(fontSize: _emojiSize()),
            ),
          ),
        ),
        if (widget.showWaterEffect)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) => CustomPaint(
                painter:
                    _ParticlePainter(_particles, _particleController.value),
              ),
            ),
          ),
        Positioned(
          bottom: 8,
          child: _buildStageLabel(),
        ),
      ],
    );
  }

  Widget _buildPot() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4A574), Color(0xFFC09060)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(22),
            top: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA07040).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 9, left: 9, right: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF7A5030).withValues(alpha: 0.18),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ),
    );
  }

  double _emojiSize() {
    switch (widget.plantState.stage) {
      case PlantStage.seed:
        return 32;
      case PlantStage.sprout:
        return 48;
      case PlantStage.sapling:
        return 64;
      case PlantStage.tree:
        return 80;
      case PlantStage.forest:
        return 96;
    }
  }

  Widget _buildStageLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFD8EDCA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8FBA78).withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.plantState.stageLabel,
        style: const TextStyle(
          color: Color(0xFF4A6B3A),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Particle {
  final double xOffset;
  final double startYRatio;
  final double endYRatio;
  final double radius;
  final double delay;
  final Color color;

  const _Particle({
    required this.xOffset,
    required this.startYRatio,
    required this.endYRatio,
    required this.radius,
    required this.delay,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    for (final p in particles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final curve = Curves.easeIn.transform(t);
      final x = cx + p.xOffset;
      final y = size.height * p.startYRatio +
          (size.height * p.endYRatio - size.height * p.startYRatio) * curve;
      final opacity = (1.0 - t * t).clamp(0.0, 1.0);

      _drawDroplet(canvas, x, y, p.radius, p.color, opacity);
    }
  }

  void _drawDroplet(
      Canvas canvas, double x, double y, double r, Color color, double opacity) {
    final paint = Paint()
      ..color = color.withValues(alpha: color.a * opacity)
      ..style = PaintingStyle.fill;

    // Teardrop: oval body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: r * 1.3, height: r * 2.0),
      paint,
    );

    // Highlight glint
    final glintPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(x - r * 0.22, y - r * 0.35),
        width: r * 0.42,
        height: r * 0.55,
      ),
      glintPaint,
    );
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
