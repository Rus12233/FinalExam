import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import '../widgets/plant_widget.dart';
import '../widgets/growth_progress_bar.dart';
import 'write_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedMonth = DateTime.now();

  static const _monthNames = [
    '1월', '2월', '3월', '4월', '5월', '6월',
    '7월', '8월', '9월', '10월', '11월', '12월',
  ];

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth.year == now.year &&
        _selectedMonth.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<DiaryProvider>(
        builder: (context, provider, _) {
          final plant = provider.plantState;
          final monthCount = provider
              .entriesForMonth(_selectedMonth.year, _selectedMonth.month)
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 헤더
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '나의 숲',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6B3A),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 화분
                SizedBox(
                  height: 260,
                  child: PlantWidget(
                    plantState: plant,
                    showWaterEffect: provider.showWaterEffect,
                  ),
                ),
                const SizedBox(height: 32),

                GrowthProgressBar(plantState: plant),
                const SizedBox(height: 16),

                // 통계
                _buildStats(monthCount, plant.waterDrops),
                const SizedBox(height: 20),

                // 오늘 기록 유도 카드
                _buildTodayCard(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStats(int monthCount, int todayDrops) {
    return Column(
      children: [
        // 월 네비게이션
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFF5B7A4E)),
              onPressed: () => setState(() {
                _selectedMonth = DateTime(
                    _selectedMonth.year, _selectedMonth.month - 1);
              }),
            ),
            Text(
              '${_selectedMonth.year}년 ${_monthNames[_selectedMonth.month - 1]}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A6B3A),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: _isCurrentMonth
                    ? Colors.grey.shade300
                    : const Color(0xFF5B7A4E),
              ),
              onPressed: _isCurrentMonth
                  ? null
                  : () => setState(() {
                        _selectedMonth = DateTime(
                            _selectedMonth.year, _selectedMonth.month + 1);
                      }),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statCard(
              '이달 기록',
              '$monthCount개',
              '📖',
              _isCurrentMonth ? null : const Color(0xFFEEF4EA),
            ),
            _statCard('총 물방울', '$todayDrops개', '💧', null),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayCard(BuildContext context, DiaryProvider provider) {
    final today = DateTime.now();
    final todayEntries = provider.entriesForDate(today);

    if (todayEntries.isEmpty) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WriteScreen()),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8FBA78).withValues(alpha: 0.18),
                const Color(0xFFD8EDCA).withValues(alpha: 0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8FBA78).withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              const Text('🌱', style: TextStyle(fontSize: 30)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오늘의 기록을 남겨보세요',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A6B3A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '한 줄이라도 괜찮아요 🙂',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B9B5E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '기록하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4EA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8FBA78).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Text('✅', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '오늘 ${todayEntries.length}개 기록 완료!',
              style: const TextStyle(
                color: Color(0xFF4A6B3A),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WriteScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF8FBA78).withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '+ 추가',
                style: TextStyle(
                  color: Color(0xFF4A6B3A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, String emoji, Color? bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: bg ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8FBA78).withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label,
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
