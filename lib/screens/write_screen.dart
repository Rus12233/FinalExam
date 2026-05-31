import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final _controller = TextEditingController();
  bool _isSaving = false;
  String _selectedMood = 'neutral';

  static const _moods = [
    ('happy', '😊', '행복'),
    ('grateful', '🙏', '감사'),
    ('neutral', '😌', '보통'),
    ('sad', '😢', '슬픔'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _isSaving = true);

    await context
        .read<DiaryProvider>()
        .addEntry(_controller.text.trim(), mood: _selectedMood);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('💧 화분에 물을 줬어요! 잘 자라고 있어요'),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF4A6B3A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '오늘의 기록',
          style: TextStyle(
              color: Color(0xFF4A6B3A), fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: const Text(
              '물주기 💧',
              style: TextStyle(
                color: Color(0xFF6B9B5E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 감정 선택
            const Text('오늘 기분이 어때요?',
                style: TextStyle(
                    color: Color(0xFF5B7A4E),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((m) {
                final isSelected = _selectedMood == m.$1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = m.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8FBA78)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6B9B5E)
                            : const Color(0xFFD8EDCA),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF8FBA78)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(m.$2,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 2),
                        Text(
                          m.$3,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade500,
                            fontWeight: isSelected
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
            const SizedBox(height: 20),

            // 일기 입력
            const Text('오늘 있었던 일을 적어보세요 🌱',
                style: TextStyle(
                    color: Color(0xFF5B7A4E),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8FBA78).withValues(alpha: 0.10),
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: '오늘 감사한 일, 느낀 점, 일어난 일...\n자유롭게 적어보세요 :)',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
