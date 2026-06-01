import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/diary_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<DiaryProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            children: [
              _buildHeader(context, provider),
              const SizedBox(height: 24),
              _buildStatsRow(provider),
              const SizedBox(height: 20),
              _buildPlantProgress(provider),
              const SizedBox(height: 20),
              _buildMoodSection(provider),
              const SizedBox(height: 20),
              _buildAchievements(provider),
              const SizedBox(height: 20),
              _buildSettings(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DiaryProvider provider) {
    final auth = context.watch<AuthProvider>();
    final displayName = auth.isGuest
        ? '게스트'
        : (auth.user?.nickname ?? provider.nickname);
    final email = auth.user?.email;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '프로필',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A6B3A),
              ),
            ),
            if (!auth.isGuest)
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: Color(0xFF5B7A4E)),
                onPressed: () => _showNicknameDialog(context, provider),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E3),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8FBA78), width: 3),
          ),
          child: Center(
            child: Text(
              auth.isGuest ? '🌱' : provider.plantState.stageEmoji,
              style: const TextStyle(fontSize: 44),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A6B3A),
          ),
        ),
        if (email != null) ...[
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
        const SizedBox(height: 6),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF8FBA78).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${provider.plantState.stageEmoji} ${provider.plantState.stageLabel} 단계',
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4A6B3A),
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(DiaryProvider provider) {
    return Row(
      children: [
        _statBox('총 기록', '${provider.plantState.totalEntries}개', '📖'),
        const SizedBox(width: 10),
        _statBox('연속 기록', '${provider.currentStreak}일', '🔥'),
        const SizedBox(width: 10),
        _statBox('오늘 물방울', '${provider.plantState.waterDrops}개', '💧'),
      ],
    );
  }

  Widget _statBox(String label, String value, String emoji) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantProgress(DiaryProvider provider) {
    final total = provider.plantState.totalEntries;
    const stages = [
      ('🌰', '씨앗', 0),
      ('🌱', '새싹', 1),
      ('🌿', '어린나무', 5),
      ('🌳', '나무', 10),
      ('🌲', '숲', 20),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF6E3), Color(0xFFF2FAF0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '나의 식물 성장 여정',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6B3A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stages.map((s) {
              final reached = total >= s.$3;
              final isCurrent =
                  provider.plantState.stageLabel == s.$2;
              return Column(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: reached
                          ? const Color(0xFF8FBA78).withValues(alpha: 0.28)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(
                              color: const Color(0xFF4A6B3A), width: 2.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        s.$1,
                        style: TextStyle(
                          fontSize: 22,
                          color: reached ? null : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    s.$2,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCurrent
                          ? const Color(0xFF4A6B3A)
                          : Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    s.$3 == 0 ? '시작' : '${s.$3}개+',
                    style: TextStyle(
                        fontSize: 9, color: Colors.grey.shade400),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection(DiaryProvider provider) {
    final dist = provider.moodDistribution;
    final total = dist.values.fold(0, (a, b) => a + b);

    const moods = [
      ('happy', '행복', '😊', Color(0xFFFFD166)),
      ('grateful', '감사', '🙏', Color(0xFF06D6A0)),
      ('neutral', '평온', '😌', Color(0xFF4ECDC4)),
      ('sad', '슬픔', '😢', Color(0xFF74B9FF)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8FBA78).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정 분포',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6B3A),
            ),
          ),
          const SizedBox(height: 14),
          if (total == 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '기록을 남기면 감정 분포를 볼 수 있어요 🌱',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
            )
          else
            ...moods.map((m) {
              final count = dist[m.$1] ?? 0;
              if (count == 0) return const SizedBox.shrink();
              final ratio = count / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text(m.$3, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 34,
                      child: Text(m.$2,
                          style: const TextStyle(fontSize: 12)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: ratio,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation(m.$4),
                          minHeight: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(ratio * 100).round()}%',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildAchievements(DiaryProvider provider) {
    final total = provider.plantState.totalEntries;
    final streak = provider.currentStreak;

    final items = [
      ('첫 기록', '첫 일기를 작성했어요', '🌱', total >= 1),
      ('꾸준함', '5개의 기록을 남겼어요', '📝', total >= 5),
      ('성장 중', '10개의 기록을 남겼어요', '🌿', total >= 10),
      ('숲의 주인', '20개의 기록을 남겼어요', '🌲', total >= 20),
      ('3일 연속', '3일 연속으로 기록했어요', '🔥', streak >= 3),
      ('일주일', '7일 연속으로 기록했어요', '⭐', streak >= 7),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8FBA78).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '업적',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6B3A),
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
            children: items.map((a) {
              return Tooltip(
                message: a.$2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: a.$4
                        ? const Color(0xFFE8F5E3)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: a.$4
                          ? const Color(0xFF8FBA78)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        a.$3,
                        style: TextStyle(
                          fontSize: 28,
                          color: a.$4 ? null : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a.$1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: a.$4
                              ? const Color(0xFF4A6B3A)
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context, DiaryProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8FBA78).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _tile(
            icon: Icons.badge_outlined,
            label: '닉네임 변경',
            onTap: () => _showNicknameDialog(context, provider),
          ),
          const Divider(height: 1, indent: 54),
          _tile(
            icon: Icons.info_outline,
            label: '앱 버전',
            trailing: Text('1.0.0',
                style:
                    TextStyle(color: Colors.grey.shade400, fontSize: 13)),
            onTap: null,
          ),
          const Divider(height: 1, indent: 54),
          _tile(
            icon: Icons.delete_outline,
            label: '전체 기록 삭제',
            color: Colors.red.shade400,
            onTap: () => _showClearDialog(context, provider),
          ),
          const Divider(height: 1, indent: 54),
          _tile(
            icon: Icons.logout,
            label: '로그아웃',
            color: Colors.red.shade400,
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    final c = color ?? const Color(0xFF444444);
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: TextStyle(fontSize: 14, color: c)),
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right,
                  size: 18, color: Colors.grey.shade400)
              : null),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }

  void _showNicknameDialog(BuildContext context, DiaryProvider provider) {
    final ctrl = TextEditingController(text: provider.nickname);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('닉네임 변경'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLength: 15,
          decoration: InputDecoration(
            hintText: '새 닉네임을 입력하세요',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) provider.setNickname(name);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8FBA78),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('로그아웃'),
        content: const Text(
          '로그아웃 하시겠어요?\n다시 로그인하면 데이터는 유지됩니다.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, DiaryProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('전체 기록 삭제'),
        content: const Text(
          '모든 일기 기록이 삭제됩니다.\n이 작업은 되돌릴 수 없어요.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearAllEntries();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
