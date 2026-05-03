import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double viewportHeight = constraints.maxHeight;
          final double contentHeight = viewportHeight < 844
              ? 844
              : viewportHeight;
          final double canvasWidth = constraints.maxWidth < 390
              ? constraints.maxWidth
              : 390;

          return SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: canvasWidth,
                height: contentHeight,
                child: Stack(
                  children: [
                    Positioned(
                      top: 159,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Nhập mã xác thực',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF212121),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 230,
                      left: (canvasWidth - 227) / 2,
                      child: SizedBox(
                        width: 227,
                        child: Text(
                          'Chúng tôi đã gửi mã đến số *123\nVui lòng nhập để tiếp tục.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 307,
                      left: 21,
                      right: 21,
                      child: _OtpInputRow(),
                    ),
                    Positioned(
                      top: 409,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Thời gian hiệu lực 2:00',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF212121),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 733,
                      left: 0,
                      right: 0,
                      child: _ResendText(),
                    ),
                    Positioned(
                      top: 755,
                      left: 0,
                      right: 0,
                      child: _BackAction(onTap: () => context.go('/login')),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OtpInputRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => Container(
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

class _ResendText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Bạn chưa nhận được mã? ',
        style: GoogleFonts.inter(
          color: const Color(0xFF212121),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.25,
        ),
        children: [
          TextSpan(
            text: 'Gửi lại (30s)',
            style: GoogleFonts.inter(
              color: const Color(0xFFC62828),
              decoration: TextDecoration.underline,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _BackAction extends StatelessWidget {
  const _BackAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chevron_left, color: Color(0xFFC62828), size: 14),
          Text(
            'Quay lại',
            style: GoogleFonts.inter(
              color: const Color(0xFFC62828),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
