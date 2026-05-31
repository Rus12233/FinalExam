import 'package:flutter_test/flutter_test.dart';
import 'package:green_diary/models/plant_state.dart';

void main() {
  final now = DateTime.now();

  group('PlantState 단계 계산', () {
    test('0개 → 씨앗', () {
      final s = PlantState(totalEntries: 0, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.seed);
      expect(s.stageEmoji, '🌰');
    });

    test('1개 → 새싹', () {
      final s = PlantState(totalEntries: 1, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.sprout);
    });

    test('4개 → 새싹 (경계값)', () {
      final s = PlantState(totalEntries: 4, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.sprout);
    });

    test('5개 → 어린나무 (경계값)', () {
      final s = PlantState(totalEntries: 5, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.sapling);
    });

    test('9개 → 어린나무 (경계값)', () {
      final s = PlantState(totalEntries: 9, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.sapling);
    });

    test('10개 → 나무 (경계값)', () {
      final s = PlantState(totalEntries: 10, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.tree);
    });

    test('19개 → 나무 (경계값)', () {
      final s = PlantState(totalEntries: 19, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.tree);
    });

    test('20개 → 숲 (경계값)', () {
      final s = PlantState(totalEntries: 20, waterDrops: 0, lastWatered: now);
      expect(s.stage, PlantStage.forest);
      expect(s.stageEmoji, '🌲');
    });
  });

  group('PlantState growthPercent', () {
    test('씨앗 → 0.0', () {
      final s = PlantState(totalEntries: 0, waterDrops: 0, lastWatered: now);
      expect(s.growthPercent, 0.0);
    });

    test('숲 → 1.0', () {
      final s = PlantState(totalEntries: 20, waterDrops: 0, lastWatered: now);
      expect(s.growthPercent, 1.0);
    });
  });
}
