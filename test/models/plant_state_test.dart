import 'package:flutter_test/flutter_test.dart';
import 'package:green_diary/models/plant_state.dart';

void main() {
  final now = DateTime.now();

  PlantState make(int entries) =>
      PlantState(totalEntries: entries, waterDrops: 0, lastWatered: now);

  group('PlantState — 단계 계산 (경계값)', () {
    test('0개 → seed', () => expect(make(0).stage, PlantStage.seed));
    test('1개 → sprout', () => expect(make(1).stage, PlantStage.sprout));
    test('4개 → sprout', () => expect(make(4).stage, PlantStage.sprout));
    test('5개 → sapling', () => expect(make(5).stage, PlantStage.sapling));
    test('9개 → sapling', () => expect(make(9).stage, PlantStage.sapling));
    test('10개 → tree', () => expect(make(10).stage, PlantStage.tree));
    test('19개 → tree', () => expect(make(19).stage, PlantStage.tree));
    test('20개 → forest', () => expect(make(20).stage, PlantStage.forest));
    test('100개 → forest', () => expect(make(100).stage, PlantStage.forest));
  });

  group('PlantState — stageEmoji', () {
    test('seed → 🌰', () => expect(make(0).stageEmoji, '🌰'));
    test('sprout → 🌱', () => expect(make(1).stageEmoji, '🌱'));
    test('sapling → 🌿', () => expect(make(5).stageEmoji, '🌿'));
    test('tree → 🌳', () => expect(make(10).stageEmoji, '🌳'));
    test('forest → 🌲', () => expect(make(20).stageEmoji, '🌲'));
  });

  group('PlantState — stageLabel', () {
    test('0개 → 씨앗', () => expect(make(0).stageLabel, '씨앗'));
    test('1개 → 새싹', () => expect(make(1).stageLabel, '새싹'));
    test('5개 → 어린나무', () => expect(make(5).stageLabel, '어린나무'));
    test('10개 → 나무', () => expect(make(10).stageLabel, '나무'));
    test('20개 → 숲', () => expect(make(20).stageLabel, '숲'));
  });

  group('PlantState — growthPercent', () {
    test('씨앗(0) → 0.0', () => expect(make(0).growthPercent, 0.0));
    test('새싹(2) → 0.4 (2/5)', () =>
        expect(make(2).growthPercent, closeTo(0.4, 0.001)));
    test('어린나무(7) → 0.4 (2/5)', () =>
        expect(make(7).growthPercent, closeTo(0.4, 0.001)));
    test('나무(15) → 0.5 (5/10)', () =>
        expect(make(15).growthPercent, closeTo(0.5, 0.001)));
    test('숲(20) → 1.0', () => expect(make(20).growthPercent, 1.0));
  });

  group('PlantState — copyWith', () {
    test('totalEntries만 변경', () {
      final original = make(5);
      final updated = original.copyWith(totalEntries: 10);
      expect(updated.totalEntries, 10);
      expect(updated.waterDrops, original.waterDrops);
    });

    test('waterDrops 증가', () {
      final s = make(3).copyWith(waterDrops: 2);
      expect(s.waterDrops, 2);
    });
  });
}
