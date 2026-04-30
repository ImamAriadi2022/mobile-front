import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'dart:ui';

const String _cdnBaseUrl = 'https://storage.googleapis.com/parkfinderbucket';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget>
    with SingleTickerProviderStateMixin {
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  final _noKendCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _isDark = true;

  // Focus nodes untuk neon glow effect
  final _namaFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _telFocus = FocusNode();
  final _kendFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  late final AnimationController _animCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();

    // Rebuild on focus change untuk glow effect
    for (final fn in [
      _namaFocus, _emailFocus, _telFocus,
      _kendFocus, _passFocus, _confirmFocus
    ]) {
      fn.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _noKendCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _namaFocus.dispose();
    _emailFocus.dispose();
    _telFocus.dispose();
    _kendFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _doRegister() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1A2D47),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              const Text(
                'Selamat!\nAkun Berhasil Dibuat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBg,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Silakan Masuk',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    final imageUrl = _isDark
        ? '$_cdnBaseUrl/background/bg-wellcome-dark.png'
        : '$_cdnBaseUrl/background/bg-wellcome-light.png';

    final fallbackGradient = _isDark
        ? const LinearGradient(
            colors: [Color(0xFF2C3E6B), Color(0xFF0D1628)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [Color(0xFF87CEEB), Color(0xFFB0D9F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    return SizedBox.expand(
      child: Stack(
        children: [
          // ── Layer 1: Background image full ─────────────────────
          Positioned.fill(
            child: Image.network(
              imageUrl,
              key: ValueKey(imageUrl),
              fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                    decoration: BoxDecoration(gradient: fallbackGradient));
              },
              errorBuilder: (_, __, ___) =>
                  Container(decoration: BoxDecoration(gradient: fallbackGradient)),
            ),
          ),

          // ── Layer 2: Dark overlay ringan ───────────────────────
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.30)),
          ),

          // ── Layer 3: Scrollable glassmorphism card ─────────────
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, topPad + 60, 20, 32),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ── Header ──────────────────────────
                            const Text(
                              'ParkFinder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Silahkan daftarkan akun anda',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.60),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Fields ───────────────────────────
                            _NeonField(
                              controller: _namaCtrl,
                              focusNode: _namaFocus,
                              hintText: 'Nama Pengguna',
                              glowColor: const Color(0xFF00E676), // green
                            ),
                            const SizedBox(height: 10),
                            _NeonField(
                              controller: _emailCtrl,
                              focusNode: _emailFocus,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              glowColor: const Color(0xFFFF5252), // red
                            ),
                            const SizedBox(height: 10),
                            _NeonField(
                              controller: _teleponCtrl,
                              focusNode: _telFocus,
                              hintText: 'Nomor Telpon',
                              keyboardType: TextInputType.phone,
                              glowColor: const Color(0xFF40C4FF), // cyan
                            ),
                            const SizedBox(height: 10),
                            _NeonField(
                              controller: _noKendCtrl,
                              focusNode: _kendFocus,
                              hintText: 'Nomor Kendaraan',
                              glowColor: const Color(0xFFFF5252), // red
                            ),
                            const SizedBox(height: 10),
                            _NeonField(
                              controller: _passCtrl,
                              focusNode: _passFocus,
                              hintText: 'Kata Sandi',
                              obscureText: _obscurePass,
                              glowColor: const Color(0xFF00E676), // green
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white60,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePass = !_obscurePass),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _NeonField(
                              controller: _confirmPassCtrl,
                              focusNode: _confirmFocus,
                              hintText: 'Ulang Kata Sandi',
                              obscureText: _obscureConfirm,
                              glowColor: const Color(0xFF00E676), // green
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white60,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // ── Daftar button ────────────────────
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _doRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.black54,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Daftar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── Login link ───────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sudah Punya Akun? Silahkan ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, AppRoutes.login),
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Layer 4: Theme toggle ──────────────────────────────
          Positioned(
            top: topPad + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => setState(() => _isDark = !_isDark),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isDark ? 'Terang' : 'Gelap',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _isDark ? Icons.wb_sunny : Icons.nightlight_round,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Input field dengan neon glow effect saat fokus
class _NeonField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Color glowColor;

  const _NeonField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.glowColor,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: glowColor.withOpacity(0.55),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.40), fontSize: 14),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.09),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: glowColor.withOpacity(0.35),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: glowColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
