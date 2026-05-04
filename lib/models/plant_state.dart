enum PlantStage {
  seed,      // 씨앗 (0개)
  sprout,    // 새싹 (1~4개)
  sapling,   // 어린나무 (5~9개)
  tree,      // 나무 (10~19개)
  forest,    // 숲 (20개+)
}

class PlantState {
  final int totalEntries;
  final int waterDrops; // 오늘 획득한 물방울
  final DateTime lastWatered;

  const PlantState({
    required this.totalEntries,
    required this.waterDrops,
    required this.lastWatered,
  });

  PlantStage get stage {
    if (totalEntries == 0) return PlantStage.seed;
    if (totalEntries < 5) return PlantStage.sprout;
    if (totalEntries < 10) return PlantStage.sapling;
    if (totalEntries < 20) return PlantStage.tree;
    return PlantStage.forest;
  }

  double get growthPercent {
    switch (stage) {
      case PlantStage.seed:
        return 0.0;
      case PlantStage.sprout:
        return totalEntries / 5.0;
      case PlantStage.sapling:
        return (totalEntries - 5) / 5.0;
      case PlantStage.tree:
        return (totalEntries - 10) / 10.0;
      case PlantStage.forest:
        return 1.0;
    }
  }

  String get stageLabel {
    switch (stage) {
      case PlantStage.seed:
        return '씨앗';
      case PlantStage.sprout:
        return '새싹';
      case PlantStage.sapling:
        return '어린나무';
      case PlantStage.tree:
        return '나무';
      case PlantStage.forest:
        return '숲';
    }
  }

  String get stageEmoji {
    switch (stage) {
      case PlantStage.seed:
        return '🌰';
      case PlantStage.sprout:
        return '🌱';
      case PlantStage.sapling:
        return '🌿';
      case PlantStage.tree:
        return '🌳';
      case PlantStage.forest:
        return '🌲';
    }
  }

  PlantState copyWith({int? totalEntries, int? waterDrops, DateTime? lastWatered}) {
    return PlantState(
      totalEntries: totalEntries ?? this.totalEntries,
      waterDrops: waterDrops ?? this.waterDrops,
      lastWatered: lastWatered ?? this.lastWatered,
    );
  }
}
