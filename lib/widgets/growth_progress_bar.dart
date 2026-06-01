import 'package:flutter/material.dart';
import '../models/plant_state.dart';

class GrowthProgressBar extends StatelessWidget {
  final PlantState plantState;

  const GrowthProgressBar({super.key, required this.plantState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '성장도',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5B7A4E),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${plantState.totalEntries}개 기록',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: plantState.growthPercent),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          builder: (context, value, _) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: const Color(0xFFD8EDCA),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF8FBA78)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _nextStageHint(),
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  String _nextStageHint() {
    switch (plantState.stage) {
      case PlantStage.seed:
        return '일기 1개 쓰면 새싹이 돼요 🌱';
      case PlantStage.sprout:
        return '${5 - plantState.totalEntries}개 더 쓰면 어린나무가 돼요 🌿';
      case PlantStage.sapling:
        return '${10 - plantState.totalEntries}개 더 쓰면 나무가 돼요 🌳';
      case PlantStage.tree:
        return '${20 - plantState.totalEntries}개 더 쓰면 숲이 돼요 🌲';
      case PlantStage.forest:
        return '당신의 숲이 완성됐어요! 🎉';
    }
  }
}
