import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginEmailCtrl = TextEditingController();
  final _loginPwCtrl = TextEditingController();
  final _regNicknameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPwCtrl = TextEditingController();

  bool _obscureLogin = true;
  bool _obscureReg = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() => _errorMsg = null));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPwCtrl.dispose();
    _regNicknameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B3A0E), Color(0xFF4A6B3A), Color(0xFF8FBA78)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTabBar(),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLoginForm(),
                            _buildRegisterForm(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.6, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text('🌲', style: TextStyle(fontSize: 46)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '나의 숲',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '매일의 기록이 숲이 됩니다',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF4A6B3A),
          borderRadius: BorderRadius.circular(11),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        tabs: const [Tab(text: '로그인'), Tab(text: '회원가입')],
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _field(
            controller: _loginEmailCtrl,
            hint: '이메일',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _field(
            controller: _loginPwCtrl,
            hint: '비밀번호',
            icon: Icons.lock_outline,
            obscure: _obscureLogin,
            toggleObscure: () =>
                setState(() => _obscureLogin = !_obscureLogin),
          ),
          if (_errorMsg != null && _tabController.index == 0) ...[
            const SizedBox(height: 12),
            _errorBanner(_errorMsg!),
          ],
          const SizedBox(height: 20),
          _primaryButton('로그인', _onLogin),
          const SizedBox(height: 20),
          _divider('또는'),
          const SizedBox(height: 14),
          _guestButton(),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _field(
            controller: _regNicknameCtrl,
            hint: '닉네임 (나의 숲 이름)',
            icon: Icons.forest_outlined,
          ),
          const SizedBox(height: 12),
          _field(
            controller: _regEmailCtrl,
            hint: '이메일',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _field(
            controller: _regPwCtrl,
            hint: '비밀번호 (6자 이상)',
            icon: Icons.lock_outline,
            obscure: _obscureReg,
            toggleObscure: () =>
                setState(() => _obscureReg = !_obscureReg),
          ),
          if (_errorMsg != null && _tabController.index == 1) ...[
            const SizedBox(height: 12),
            _errorBanner(_errorMsg!),
          ],
          const SizedBox(height: 20),
          _primaryButton('회원가입', _onRegister),
          const SizedBox(height: 20),
          _divider('또는'),
          const SizedBox(height: 14),
          _guestButton(),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    VoidCallback? toggleObscure,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF8FBA78), size: 20),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
                onPressed: toggleObscure,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF8FBA78), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onPressed) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) => ElevatedButton(
        onPressed: auth.isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6B3A),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF8FBA78),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _divider(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade200)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text,
              style:
                  TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade200)),
      ],
    );
  }

  Widget _guestButton() {
    return OutlinedButton.icon(
      onPressed: () => context.read<AuthProvider>().loginAsGuest(),
      icon: const Text('🌱', style: TextStyle(fontSize: 16)),
      label: const Text('게스트로 시작하기'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF5B7A4E),
        side: const BorderSide(color: Color(0xFF8FBA78), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _errorBanner(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(msg,
                style: TextStyle(
                    color: Colors.red.shade600, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Future<void> _onLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final pw = _loginPwCtrl.text;
    if (email.isEmpty || pw.isEmpty) {
      setState(() => _errorMsg = '이메일과 비밀번호를 입력해주세요.');
      return;
    }
    final error = await context.read<AuthProvider>().login(email, pw);
    if (error != null && mounted) {
      setState(() => _errorMsg = error);
    }
  }

  Future<void> _onRegister() async {
    final nickname = _regNicknameCtrl.text.trim();
    final email = _regEmailCtrl.text.trim();
    final pw = _regPwCtrl.text;
    if (nickname.isEmpty || email.isEmpty || pw.isEmpty) {
      setState(() => _errorMsg = '모든 항목을 입력해주세요.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _errorMsg = '올바른 이메일 형식을 입력해주세요.');
      return;
    }
    if (pw.length < 6) {
      setState(() => _errorMsg = '비밀번호는 6자 이상이어야 합니다.');
      return;
    }
    final error =
        await context.read<AuthProvider>().register(email, pw, nickname);
    if (error != null && mounted) {
      setState(() => _errorMsg = error);
    }
  }
}
