import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _officerIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _officerIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double viewportHeight = constraints.maxHeight;
          final double contentHeight = viewportHeight < 844
              ? 844
              : viewportHeight;
          final double canvasWidth = constraints.maxWidth < 390
              ? constraints.maxWidth
              : 390;

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF0F8FF), Color(0xFF1E40AF)],
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: canvasWidth,
                  height: contentHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 105,
                        left: (canvasWidth - 119) / 2,
                        child: _LogoMark(),
                      ),
                      Positioned(
                        top: 237,
                        left: 0,
                        right: 0,
                        child: _LoginTitle(),
                      ),
                      Positioned(
                        top: 343,
                        left: 10,
                        right: 10,
                        child: _LoginCard(
                          officerIdController: _officerIdController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          onClearOfficerId: () => _officerIdController.clear(),
                          onTogglePassword: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onLogin: widget.onLogin,
                          onFingerprintLogin: () {
                            showDialog<void>(
                              context: context,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (_) => const _FingerprintDialog(),
                            );
                          },
                          onQrLogin: () => context.go('/login/qr'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 119,
      height: 119,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF334F90)),
      ),
    );
  }
}

class _LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF334F90), Color(0xFF0F172A)],
          stops: [0.22319, 0.85252],
        ).createShader(bounds);
      },
      child: Text(
        'Ứng dụng Quản Lí\nĐoàn Thanh niên CAND',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.officerIdController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onClearOfficerId,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onFingerprintLogin,
    required this.onQrLogin,
  });

  final TextEditingController officerIdController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onClearOfficerId;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onFingerprintLogin;
  final VoidCallback onQrLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 328,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FigmaTextField(
            controller: officerIdController,
            label: 'Số hiệu CAND',
            suffix: ValueListenableBuilder<TextEditingValue>(
              valueListenable: officerIdController,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: value.text.isEmpty ? null : onClearOfficerId,
                  icon: const Icon(Icons.close, size: 23),
                  color: const Color(0xFF64748B),
                  disabledColor: const Color(0xFF64748B),
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 13),
          _FigmaTextField(
            controller: passwordController,
            label: 'Mật khẩu',
            obscureText: obscurePassword,
            suffix: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
              ),
              color: const Color(0xFF64748B),
              splashRadius: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 34,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF343B53), Color(0xFF1E40AF)],
                ),
              ),
              child: ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size.fromHeight(34),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Đăng nhập',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 18),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              child: const Text('Quên mật khẩu?'),
            ),
          ),
          const SizedBox(height: 12),
          _AlternateLoginAction(
            icon: Icons.fingerprint,
            label: 'Đăng nhập bằng vân tay',
            iconSize: 34,
            onTap: onFingerprintLogin,
          ),
          const SizedBox(height: 10),
          _AlternateLoginAction(
            icon: Icons.qr_code_2,
            label: 'Đăng nhập bằng mã QR',
            iconSize: 31,
            onTap: onQrLogin,
          ),
        ],
      ),
    );
  }
}

class _FigmaTextField extends StatelessWidget {
  const _FigmaTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF0F172A),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              suffixIcon: suffix,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFF334F90)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AlternateLoginAction extends StatelessWidget {
  const _AlternateLoginAction({
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Icon(icon, color: const Color(0xFF0F172A), size: iconSize),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF0F172A),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FingerprintDialog extends StatelessWidget {
  const _FingerprintDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 58.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      shadowColor: const Color(0x40000000),
      backgroundColor: AppColors.white,
      child: SizedBox(
        width: 273,
        height: 328,
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 7,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 24),
                color: const Color(0xFF64748B),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 40,
                ),
                splashRadius: 18,
              ),
            ),
            Positioned(
              top: 63,
              left: 0,
              right: 0,
              child: Text(
                'Chạm vào vân tay để xác thực',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ),
            const Center(
              child: Icon(
                Icons.fingerprint,
                color: Color(0xFF1E40AF),
                size: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
