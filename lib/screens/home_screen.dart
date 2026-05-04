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
      backgroundColor: const Color(0xFFF0F7EC),
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
                      Text(
                        '나의 숲',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiaryListScreen(),
                          ),
                        ),
                        icon: Icon(Icons.menu_book_rounded,
                            color: Colors.green.shade700),
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
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
