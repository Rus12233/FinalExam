import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/plant_state.dart';

class PlantWidget extends StatelessWidget {
  final PlantState plantState;
  final bool showWaterEffect;

  const PlantWidget({
    super.key,
    required this.plantState,
    this.showWaterEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 화분 배경
        _buildPot(),
        // 식물 이미지 (단계별)
        _buildPlant(),
        // 물방울 파티클
        if (showWaterEffect) _buildWaterParticles(),
        // 성장 라벨
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
          color: const Color(0xFFB5651D),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
            top: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6B4423).withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ),
    );
  }

  Widget _buildPlant() {
    final size = _plantSizeByStage();
    return Positioned(
      bottom: 60,
      child: Text(
        plantState.stageEmoji,
        style: TextStyle(fontSize: size),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .moveY(begin: 0, end: -4, duration: 2000.ms, curve: Curves.easeInOut),
    );
  }

  double _plantSizeByStage() {
    switch (plantState.stage) {
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

  Widget _buildWaterParticles() {
    return Positioned(
      top: 0,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          children: List.generate(8, (i) {
            final angle = (i / 8) * 3.14159 * 2;
            final dx = 60 * (0.5 - (i % 3) * 0.3);
            final dy = -40.0 - (i * 10);
            return Positioned(
              left: 80 + dx,
              top: 80,
              child: Text('💧', style: const TextStyle(fontSize: 14))
                  .animate()
                  .moveX(begin: 0, end: dx * 2, duration: 1000.ms)
                  .moveY(begin: 0, end: dy, duration: 1000.ms)
                  .fadeOut(duration: 1000.ms),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStageLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        plantState.stageLabel,
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
