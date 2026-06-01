import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/diary_entry.dart';
import 'providers/diary_provider.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();
  Hive.registerAdapter(DiaryEntryAdapter());

  runApp(const GreenDiaryApp());
}

class GreenDiaryApp extends StatelessWidget {
  const GreenDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiaryProvider()..init(),
      child: MaterialApp(
        title: '나의 숲 - 감성 다이어리',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}
