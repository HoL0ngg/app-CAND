import 'package:flutter/material.dart';
import '../theme.dart';

/// Loading spinner dùng chung, lấy màu từ [AppColors].
///
/// ```dart
/// // Spinner mặc định
/// const LoadingIndicator()
///
/// // Toàn màn hình với overlay mờ
/// LoadingIndicator.overlay()
/// ```
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.strokeWidth = 3.5,
    this.color,
    this.message,
  }) : _overlay = false;

  /// Hiển thị spinner giữa màn hình với nền mờ.
  const LoadingIndicator.overlay({
    super.key,
    this.size = 48,
    this.strokeWidth = 3.5,
    this.color,
    this.message,
  }) : _overlay = true;

  /// Kích thước spinner (mặc định 40).
  final double size;

  /// Độ dày nét vẽ (mặc định 3.5).
  final double strokeWidth;

  /// Ghi đè màu spinner (mặc định [AppColors.primary]).
  final Color? color;

  /// Thông báo hiển thị bên dưới spinner (tuỳ chọn).
  final String? message;

  final bool _overlay;

  @override
  Widget build(BuildContext context) {
    final spinnerColor = color ?? AppColors.primary;

    final spinner = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _overlay ? AppColors.white : AppColors.greyMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!_overlay) {
      return Center(child: spinner);
    }

    // ── Full-screen overlay ──
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(220),
            borderRadius: BorderRadius.circular(16),
          ),
          child: spinner,
        ),
      ),
    );
  }
}
