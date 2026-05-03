import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme.dart';

class QrLoginScreen extends StatelessWidget {
  const QrLoginScreen({super.key});

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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 132,
                      left: 10,
                      right: 10,
                    ),
                    child: Container(
                      height: 580,
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
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            left: 8,
                            child: _BackAction(
                              onTap: () => context.go('/login'),
                            ),
                          ),
                          const Positioned(
                            top: 110,
                            left: 0,
                            right: 0,
                            child: Center(child: _QrGraphic()),
                          ),
                          Positioned(
                            top: 374,
                            left: 39,
                            right: 39,
                            child: _SecurityTimer(),
                          ),
                        ],
                      ),
                    ),
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

class _BackAction extends StatelessWidget {
  const _BackAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 28,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_left, color: Color(0xFF0F172A), size: 16),
            Text(
              'Quay lại',
              style: GoogleFonts.inter(
                color: const Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF343B53), Color(0xFF1E40AF)],
        ),
      ),
      child: Text(
        'Mã bảo mật sẽ làm mới sau: 00:59s',
        style: GoogleFonts.inter(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.25,
        ),
      ),
    );
  }
}

class _QrGraphic extends StatelessWidget {
  const _QrGraphic();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 246,
      height: 245,
      child: CustomPaint(painter: _QrPainter()),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter();

  static const int _count = 29;
  static const List<String> _rows = [
    '11111110010110011100111111100',
    '10000010001110001000100000100',
    '10111010011100111010101110100',
    '10111010000110101000101110100',
    '10111010110111101110101110100',
    '10000010100100100010100000100',
    '11111110101010101010111111100',
    '00000000111001110010000000000',
    '10111011110011101111111011100',
    '00100000011100101001001000100',
    '11101111100011011101111110100',
    '11111001010111100111010000100',
    '00011110111100011101000111100',
    '01100101000110100011101100100',
    '11111110011111101110111110100',
    '10000000110100111000001000100',
    '10111011100111101011101111100',
    '10111010010010001110100100100',
    '10111010111011110100111110100',
    '10000010001000101011100000100',
    '11111110111110101100111111100',
    '00000000100000100010100000000',
    '11100011101111101111101111100',
    '00111000001001000000101000100',
    '11111110111101111110101110100',
    '10000010100111000110101010100',
    '10111010111100111110101110100',
    '10000010001011100010100000100',
    '11111110111000101110111111100',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.black;
    final double cell = size.shortestSide / _count;
    final double left = (size.width - cell * _count) / 2;
    final double top = (size.height - cell * _count) / 2;

    for (int y = 0; y < _rows.length; y++) {
      for (int x = 0; x < _rows[y].length; x++) {
        if (_rows[y][x] == '1') {
          canvas.drawRect(
            Rect.fromLTWH(left + x * cell, top + y * cell, cell, cell),
            paint,
          );
        }
      }
    }

    _drawFinder(canvas, paint, left, top, cell, 0, 0);
    _drawFinder(canvas, paint, left, top, cell, 22, 0);
    _drawFinder(canvas, paint, left, top, cell, 0, 22);
  }

  void _drawFinder(
    Canvas canvas,
    Paint paint,
    double left,
    double top,
    double cell,
    int x,
    int y,
  ) {
    final Paint white = Paint()..color = Colors.white;
    final Offset origin = Offset(left + x * cell, top + y * cell);

    canvas.drawRect(origin & Size(cell * 7, cell * 7), paint);
    canvas.drawRect(
      origin.translate(cell, cell) & Size(cell * 5, cell * 5),
      white,
    );
    canvas.drawRect(
      origin.translate(cell * 2, cell * 2) & Size(cell * 3, cell * 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
