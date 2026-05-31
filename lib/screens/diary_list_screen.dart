import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/diary_provider.dart';
import '../models/diary_entry.dart';

class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7EC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('나의 기록들',
            style: TextStyle(
                color: Colors.green.shade800, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, provider, _) {
          final entries = provider.entries;
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('첫 번째 기록을 남겨보세요!',
                      style: TextStyle(
                          color: Colors.green.shade600, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, i) => _EntryCard(
              entry: entries[i],
              onDelete: () => provider.deleteEntry(entries[i].id),
            ),
          );
        },
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;

  const _EntryCard({required this.entry, required this.onDelete});

  String _moodEmoji(String mood) {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'grateful':
        return '🙏';
      case 'sad':
        return '😢';
      default:
        return '😌';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy.MM.dd HH:mm').format(entry.createdAt),
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500),
                ),
                Text(_moodEmoji(entry.mood),
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.content,
              style: const TextStyle(fontSize: 15, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
