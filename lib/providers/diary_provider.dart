import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/diary_entry.dart';
import '../models/plant_state.dart';

class DiaryProvider extends ChangeNotifier {
  Box<DiaryEntry>? _box;
  Box<dynamic>? _settingsBox;
  PlantState _plantState = PlantState(
    totalEntries: 0,
    waterDrops: 0,
    lastWatered: DateTime.now(),
  );
  bool _showWaterEffect = false;

  PlantState get plantState => _plantState;
  List<DiaryEntry> get entries {
    if (_box == null) return [];
    return _box!.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
  bool get showWaterEffect => _showWaterEffect;

  String get nickname =>
      _settingsBox?.get('nickname', defaultValue: '나의 숲 가드너') as String? ??
      '나의 숲 가드너';

  Future<void> setNickname(String name) async {
    await _settingsBox?.put('nickname', name);
    notifyListeners();
  }

  Future<void> init() async {
    _box = await Hive.openBox<DiaryEntry>('diary');
    _settingsBox = await Hive.openBox('settings');
    _updatePlantState();
  }

  void _updatePlantState() {
    _plantState = _plantState.copyWith(totalEntries: _box?.length ?? 0);
    notifyListeners();
  }

  Future<void> addEntry(String content, {String mood = 'neutral', DateTime? atDate}) async {
    if (_box == null) return;
    final entry = DiaryEntry(
      id: const Uuid().v4(),
      content: content,
      createdAt: atDate ?? DateTime.now(),
      mood: mood,
    );
    await _box!.put(entry.id, entry);

    _showWaterEffect = true;
    _plantState = _plantState.copyWith(
      totalEntries: _box!.length,
      waterDrops: _plantState.waterDrops + 1,
      lastWatered: DateTime.now(),
    );
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    _showWaterEffect = false;
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _box?.delete(id);
    _updatePlantState();
  }

  Future<void> clearAllEntries() async {
    await _box?.clear();
    _plantState = PlantState(
      totalEntries: 0,
      waterDrops: 0,
      lastWatered: DateTime.now(),
    );
    notifyListeners();
  }

  List<DiaryEntry> entriesForDate(DateTime date) {
    if (_box == null) return [];
    return _box!.values
        .where((e) =>
            e.createdAt.year == date.year &&
            e.createdAt.month == date.month &&
            e.createdAt.day == date.day)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<DiaryEntry> entriesForMonth(int year, int month) {
    if (_box == null) return [];
    return _box!.values
        .where((e) => e.createdAt.year == year && e.createdAt.month == month)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  bool hasEntryOnDate(DateTime date) {
    if (_box == null) return false;
    return _box!.values.any((e) =>
        e.createdAt.year == date.year &&
        e.createdAt.month == date.month &&
        e.createdAt.day == date.day);
  }

  String? moodForDate(DateTime date) {
    if (_box == null) return null;
    final list = entriesForDate(date);
    return list.isEmpty ? null : list.first.mood;
  }

  int get currentStreak {
    if (_box == null) return 0;
    final now = DateTime.now();
    int streak = 0;
    DateTime check = DateTime(now.year, now.month, now.day);
    while (hasEntryOnDate(check)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Map<String, int> get moodDistribution {
    if (_box == null) return {};
    final dist = <String, int>{};
    for (final e in _box!.values) {
      dist[e.mood] = (dist[e.mood] ?? 0) + 1;
    }
    return dist;
  }
}
