import 'package:flutter_test/flutter_test.dart';
import 'package:green_diary/models/diary_entry.dart';

void main() {
  group('DiaryEntry — 생성', () {
    test('필드가 올바르게 설정된다', () {
      final now = DateTime(2026, 5, 31, 12, 0);
      final entry = DiaryEntry(
        id: 'test-uuid-001',
        content: '오늘 좋은 일이 있었다',
        createdAt: now,
        mood: 'happy',
      );

      expect(entry.id, 'test-uuid-001');
      expect(entry.content, '오늘 좋은 일이 있었다');
      expect(entry.createdAt, now);
      expect(entry.mood, 'happy');
    });

    test('기본 mood는 neutral이다', () {
      final entry = DiaryEntry(
        id: 'test-id',
        content: '내용',
        createdAt: DateTime.now(),
      );
      expect(entry.mood, 'neutral');
    });

    test('빈 content도 객체 생성은 가능하다', () {
      final entry = DiaryEntry(
        id: 'test-id',
        content: '',
        createdAt: DateTime.now(),
      );
      expect(entry.content, '');
    });
  });

  group('DiaryEntry — mood 값', () {
    final moods = ['happy', 'neutral', 'sad', 'grateful'];

    for (final mood in moods) {
      test('mood=$mood 로 생성 가능', () {
        final entry = DiaryEntry(
          id: 'id-$mood',
          content: '내용',
          createdAt: DateTime.now(),
          mood: mood,
        );
        expect(entry.mood, mood);
      });
    }
  });
}
