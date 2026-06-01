import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import '../models/diary_entry.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();

  static const _weekdays = ['일', '월', '화', '수', '목', '금', '토'];
  static const _monthNames = [
    '1월', '2월', '3월', '4월', '5월', '6월',
    '7월', '8월', '9월', '10월', '11월', '12월'
  ];

  static const _moodEmojis = {
    'happy': '😊',
    'grateful': '🙏',
    'neutral': '😌',
    'sad': '😢',
  };
  static const _moodLabels = {
    'happy': '행복',
    'grateful': '감사',
    'neutral': '평온',
    'sad': '슬픔',
  };
  static const _moodColors = {
    'happy': Color(0xFFFFD166),
    'grateful': Color(0xFF06D6A0),
    'neutral': Color(0xFF4ECDC4),
    'sad': Color(0xFF74B9FF),
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<DiaryProvider>(
        builder: (context, provider, _) {
          final monthEntries = provider.entriesForMonth(
              _focusedMonth.year, _focusedMonth.month);
          final moodCounts = <String, int>{};
          for (final e in monthEntries) {
            moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildMonthNav(),
              _buildCalendarGrid(provider),
              const Divider(height: 1, color: Color(0xFFE8E0D4)),
              Expanded(child: _buildMonthStats(monthEntries, moodCounts)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Text(
        '달력',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A6B3A),
        ),
      ),
    );
  }

  Widget _buildMonthNav() {
    final now = DateTime.now();
    final isCurrentMonth =
        _focusedMonth.year == now.year && _focusedMonth.month == now.month;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF4A6B3A)),
            onPressed: () => setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month - 1);
            }),
          ),
          Text(
            '${_focusedMonth.year}년 ${_monthNames[_focusedMonth.month - 1]}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A6B3A),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right,
                color: isCurrentMonth
                    ? Colors.grey.shade300
                    : const Color(0xFF4A6B3A)),
            onPressed: isCurrentMonth
                ? null
                : () => setState(() {
                      _focusedMonth =
                          DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                    }),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DiaryProvider provider) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    // weekday: 1=Mon..7=Sun → convert to Sunday-first offset (Sun=0)
    final startOffset = firstDay.weekday % 7;
    final totalCells = startOffset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: _weekdays.mapIndexed((i, day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: i == 0
                            ? Colors.red.shade400
                            : i == 6
                                ? Colors.blue.shade400
                                : Colors.grey.shade500,
                      ),
                    ),
                  ),
                )).toList(),
          ),
          const SizedBox(height: 6),
          for (int row = 0; row < rowCount; row++)
            Row(
              children: List.generate(7, (col) {
                final cellIdx = row * 7 + col;
                final day = cellIdx - startOffset + 1;

                if (day < 1 || day > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 48));
                }

                final date =
                    DateTime(_focusedMonth.year, _focusedMonth.month, day);
                final isToday = date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;
                final hasEntry = provider.hasEntryOnDate(date);
                final mood = hasEntry ? provider.moodForDate(date) : null;
                final isFuture = date.isAfter(now);
                final dotColor = _moodColors[mood] ?? const Color(0xFF8FBA78);

                return Expanded(
                  child: GestureDetector(
                    onTap: isFuture
                        ? null
                        : () => _showDaySheet(context, date, provider),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: hasEntry
                            ? const Color(0xFF8FBA78).withValues(alpha: 0.18)
                            : null,
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(
                                color: const Color(0xFF4A6B3A), width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isToday || hasEntry
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isFuture
                                  ? Colors.grey.shade300
                                  : col == 0
                                      ? Colors.red.shade400
                                      : col == 6
                                          ? Colors.blue.shade400
                                          : const Color(0xFF333333),
                            ),
                          ),
                          if (hasEntry)
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(height: 7),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthStats(
      List<DiaryEntry> entries, Map<String, int> moodCounts) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Text('🌿 ', style: TextStyle(fontSize: 18)),
            Text(
              '이달의 기록 ${entries.length}개',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A6B3A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (entries.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '이달에 작성된 기록이 없어요.\n오늘의 감정을 기록해 보세요! 🌱',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, height: 1.7),
              ),
            ),
          )
        else
          ..._moodLabels.keys.map((key) {
            final count = moodCounts[key] ?? 0;
            if (count == 0) return const SizedBox.shrink();
            final ratio = count / entries.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(_moodEmojis[key]!, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    child: Text(_moodLabels[key]!,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: ratio,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                            _moodColors[key] ?? const Color(0xFF8FBA78)),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$count개',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            );
          }),
      ],
    );
  }

  void _showDaySheet(
      BuildContext context, DateTime date, DiaryProvider provider) {
    final entries = provider.entriesForDate(date);
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return entries.isEmpty
            ? _QuickWriteSheet(date: date, provider: provider)
            : DraggableScrollableSheet(
                initialChildSize: 0.55,
                maxChildSize: 0.9,
                minChildSize: 0.3,
                expand: false,
                builder: (_, controller) => Column(
                  children: [
                    const SizedBox(height: 10),
                    _handle(),
                    const SizedBox(height: 14),
                    Text(
                      '${date.month}월 ${date.day}일',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entries.length}개의 기록',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 4),
                    if (isToday)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetCtx);
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24)),
                            ),
                            builder: (_) => _QuickWriteSheet(
                                date: date, provider: provider),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('추가 기록'),
                        style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF5B7A4E)),
                      ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        itemCount: entries.length,
                        itemBuilder: (_, i) {
                          final e = entries[i];
                          final hh = e.createdAt.hour
                              .toString()
                              .padLeft(2, '0');
                          final mm = e.createdAt.minute
                              .toString()
                              .padLeft(2, '0');
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F4EC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(_moodEmojis[e.mood] ?? '😌'),
                                  const SizedBox(width: 8),
                                  Text('$hh:$mm',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
                                ]),
                                const SizedBox(height: 8),
                                Text(e.content,
                                    style: const TextStyle(height: 1.5)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _handle() {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _QuickWriteSheet extends StatefulWidget {
  final DateTime date;
  final DiaryProvider provider;

  const _QuickWriteSheet({required this.date, required this.provider});

  @override
  State<_QuickWriteSheet> createState() => _QuickWriteSheetState();
}

class _QuickWriteSheetState extends State<_QuickWriteSheet> {
  final _ctrl = TextEditingController();
  String _mood = 'neutral';
  bool _saving = false;

  static const _moods = [
    ('happy', '😊', '행복'),
    ('grateful', '🙏', '감사'),
    ('neutral', '😌', '보통'),
    ('sad', '😢', '슬픔'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    final entryDate = DateTime(
        widget.date.year, widget.date.month, widget.date.day,
        now.hour, now.minute, now.second);
    await widget.provider.addEntry(text, mood: _mood, atDate: entryDate);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('💧 기록을 남겼어요!'),
          backgroundColor: const Color(0xFF8FBA78),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.date.month}월 ${widget.date.day}일 기록',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 감정 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((m) {
                final selected = _mood == m.$1;
                return GestureDetector(
                  onTap: () => setState(() => _mood = m.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF8FBA78)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6B9B5E)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(m.$2,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 2),
                        Text(
                          m.$3,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected
                                ? Colors.white
                                : Colors.grey.shade500,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            // 텍스트 입력
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F4EC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _ctrl,
                maxLines: 4,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '오늘 있었던 일을 간단히 적어보세요 🌱',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FBA78),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('💧 물 주기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _IndexedMap<T> on List<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T item) f) sync* {
    for (int i = 0; i < length; i++) {
      yield f(i, this[i]);
    }
  }
}
