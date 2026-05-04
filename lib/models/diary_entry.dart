import 'package:hive/hive.dart';

part 'diary_entry.g.dart';

@HiveType(typeId: 0)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String mood; // 'happy', 'neutral', 'sad', 'grateful'

  DiaryEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    this.mood = 'neutral',
  });
}
