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
  String _selectedMood = 'neutral';
  bool _isSaving = false;

  final _moods = [
    {'key': 'happy', 'emoji': '😊', 'label': '행복'},
    {'key': 'grateful', 'emoji': '🙏', 'label': '감사'},
    {'key': 'neutral', 'emoji': '😌', 'label': '평온'},
    {'key': 'sad', 'emoji': '😢', 'label': '슬픔'},
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
          backgroundColor: Colors.green.shade400,
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
      backgroundColor: const Color(0xFFF0F7EC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.green.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '오늘의 기록',
          style: TextStyle(
              color: Colors.green.shade800, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: Text(
              '물주기 💧',
              style: TextStyle(
                color: Colors.green.shade600,
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
            // 기분 선택
            Text('오늘 기분은?',
                style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['key'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood['key']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green.shade400
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(mood['emoji']!,
                            style: const TextStyle(fontSize: 24)),
                        Text(mood['label']!,
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 일기 입력
            Text('오늘 있었던 일을 적어보세요 🌱',
                style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
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
