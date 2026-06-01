import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserModel {
  final String email;
  final String nickname;

  const UserModel({required this.email, required this.nickname});
}

class AuthProvider extends ChangeNotifier {
  Box<dynamic>? _box;
  UserModel? _user;
  bool _isGuest = false;
  bool _isLoading = false;

  bool get isLoggedIn => _user != null || _isGuest;
  bool get isGuest => _isGuest;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _box = await Hive.openBox('auth');
    final isGuest = _box!.get('session_is_guest', defaultValue: false) as bool;
    final email = _box!.get('session_email') as String?;

    if (isGuest) {
      _isGuest = true;
    } else if (email != null) {
      final nickname = _box!.get('user_${email}_nickname') as String?;
      if (nickname != null) {
        _user = UserModel(email: email, nickname: nickname);
      }
    }
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final storedHash = _box!.get('user_${email}_pw') as int?;
    if (storedHash == null) {
      _isLoading = false;
      notifyListeners();
      return '등록되지 않은 이메일입니다.';
    }
    if (storedHash != password.hashCode) {
      _isLoading = false;
      notifyListeners();
      return '비밀번호가 올바르지 않습니다.';
    }

    final nickname = _box!.get('user_${email}_nickname') as String;
    _user = UserModel(email: email, nickname: nickname);
    _isGuest = false;
    await _box!.put('session_email', email);
    await _box!.put('session_is_guest', false);

    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> register(String email, String password, String nickname) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (_box!.get('user_${email}_pw') != null) {
      _isLoading = false;
      notifyListeners();
      return '이미 사용 중인 이메일입니다.';
    }

    await _box!.put('user_${email}_pw', password.hashCode);
    await _box!.put('user_${email}_nickname', nickname);
    await _box!.put('session_email', email);
    await _box!.put('session_is_guest', false);

    _user = UserModel(email: email, nickname: nickname);
    _isGuest = false;
    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<void> loginAsGuest() async {
    _isGuest = true;
    _user = null;
    await _box!.put('session_is_guest', true);
    await _box!.delete('session_email');
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _isGuest = false;
    await _box!.delete('session_email');
    await _box!.put('session_is_guest', false);
    notifyListeners();
  }
}
