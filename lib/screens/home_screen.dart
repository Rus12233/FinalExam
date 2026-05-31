import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import '../widgets/plant_widget.dart';
import '../widgets/growth_progress_bar.dart';
import 'write_screen.dart';
import 'diary_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      body: SafeArea(
        child: Consumer<DiaryProvider>(
          builder: (context, provider, _) {
            final plant = provider.plantState;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '나의 숲',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6B3A),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiaryListScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.menu_book_rounded,
                            color: Color(0xFF5B7A4E)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 화분 메인 영역
                  SizedBox(
                    height: 260,
                    child: PlantWidget(
                      plantState: plant,
                      showWaterEffect: provider.showWaterEffect,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 성장 바
                  GrowthProgressBar(plantState: plant),
                  const SizedBox(height: 16),

                  // 통계
                  _buildStats(plant.totalEntries, plant.waterDrops),
                  const Spacer(),

                  // 일기 쓰기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WriteScreen()),
                      ),
                      icon: const Text('✍️'),
                      label: const Text(
                        '오늘의 기록 남기기',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FBA78),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStats(int total, int today) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statCard('전체 기록', '$total개', '📖'),
        _statCard('오늘 물방울', '$today개', '💧'),
      ],
    );
  }

  Widget _statCard(String label, String value, String emoji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
