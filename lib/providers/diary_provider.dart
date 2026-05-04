import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/diary_entry.dart';
import '../models/plant_state.dart';

class DiaryProvider extends ChangeNotifier {
  late Box<DiaryEntry> _box;
  PlantState _plantState = PlantState(
    totalEntries: 0,
    waterDrops: 0,
    lastWatered: DateTime.now(),
  );
  bool _showWaterEffect = false;

  PlantState get plantState => _plantState;
  List<DiaryEntry> get entries => _box.values.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  bool get showWaterEffect => _showWaterEffect;

  Future<void> init() async {
    _box = await Hive.openBox<DiaryEntry>('diary');
    _updatePlantState();
  }

  void _updatePlantState() {
    _plantState = _plantState.copyWith(totalEntries: _box.length);
    notifyListeners();
  }

  Future<void> addEntry(String content, {String mood = 'neutral'}) async {
    final entry = DiaryEntry(
      id: const Uuid().v4(),
      content: content,
      createdAt: DateTime.now(),
      mood: mood,
    );
    await _box.put(entry.id, entry);

    // 물방울 파티클 트리거
    _showWaterEffect = true;
    _plantState = _plantState.copyWith(
      totalEntries: _box.length,
      waterDrops: _plantState.waterDrops + 1,
      lastWatered: DateTime.now(),
    );
    notifyListeners();

    // 효과 초기화
    await Future.delayed(const Duration(milliseconds: 1500));
    _showWaterEffect = false;
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
    _updatePlantState();
  }
}
