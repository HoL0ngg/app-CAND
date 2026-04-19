import 'package:flutter/material.dart';
import '../theme.dart';

/// Kiểu hiển thị của [CustomButton].
enum ButtonVariant { filled, outlined, text }

/// Nút bấm dùng chung – khớp với thiết kế Figma.
///
/// Mặc định: bo góc viên thuốc (25px), nền xanh primary, chữ trắng.
///
/// ```dart
/// // Nút "Đăng nhập" (Figma login)
/// CustomButton(label: 'Đăng nhập', onPressed: () {})
///
/// // Nút "Lịch sử đơn vị" (Figma hồ sơ – nền đỏ)
/// CustomButton(
///   label: 'Lịch sử đơn vị',
///   backgroundColor: AppColors.red,
///   onPressed: () {},
/// )
///
/// // Nút "Mã QR của tôi" (Figma – viền vàng)
/// CustomButton(
///   label: 'Mã QR của tôi',
///   variant: ButtonVariant.outlined,
///   foregroundColor: AppColors.primary,
///   borderColor: AppColors.yellow,
///   onPressed: () {},
/// )
/// ```
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
    this.borderRadius = 25,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.fontSize,
    this.expand = false,
  });

  /// Nhãn hiển thị trên nút.
  final String label;

  /// Callback khi nhấn. Truyền `null` để disable.
  final VoidCallback? onPressed;

  /// Kiểu nút: filled (mặc định), outlined, text.
  final ButtonVariant variant;

  /// Hiển thị loading spinner thay vì label.
  final bool isLoading;

  /// Icon tuỳ chọn bên trái label.
  final IconData? icon;

  /// Chiều rộng cố định. `null` = co giãn theo parent.
  final double? width;

  /// Chiều cao (mặc định 48 – khớp Figma).
  final double height;

  /// Bo góc (mặc định 25 – dạng viên thuốc khớp Figma).
  final double borderRadius;

  /// Ghi đè màu nền (filled) hoặc màu chữ (outlined/text).
  final Color? backgroundColor;

  /// Ghi đè màu chữ / icon.
  final Color? foregroundColor;

  /// Ghi đè màu viền (chỉ dùng cho outlined). Mặc định theo foreground.
  final Color? borderColor;

  /// Ghi đè cỡ chữ.
  final double? fontSize;

  /// `true` = chiếm hết chiều ngang (double.infinity).
  final bool expand;

  // ── Helpers ──────────────────────────────────

  bool get _disabled => onPressed == null || isLoading;

  Color get _bg => backgroundColor ?? AppColors.primary;
  Color get _fg => foregroundColor ?? AppColors.white;

  OutlinedBorder get _shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.filled ? _fg : _bg,
          ),
        ),
      );
    }

    final textWidget = Text(
      label,
      style: TextStyle(fontSize: fontSize ?? 16, fontWeight: FontWeight.w600),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 20), const SizedBox(width: 8), textWidget],
      );
    }
    return textWidget;
  }

  // ── Build ───────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();
    final effectiveWidth = expand ? double.infinity : width;

    Widget button;

    switch (variant) {
      case ButtonVariant.filled:
        button = ElevatedButton(
          onPressed: _disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _bg,
            foregroundColor: _fg,
            disabledBackgroundColor: _bg.withAlpha(100),
            disabledForegroundColor: _fg.withAlpha(150),
            elevation: 0,
            shape: _shape,
            minimumSize: Size(0, height),
            padding: const EdgeInsets.symmetric(horizontal: 32),
          ),
          child: child,
        );
        break;

      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: _disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? _bg,
            side: BorderSide(
              color: _disabled
                  ? AppColors.greyLight
                  : (borderColor ?? foregroundColor ?? _bg),
            ),
            shape: _shape,
            minimumSize: Size(0, height),
            padding: const EdgeInsets.symmetric(horizontal: 32),
          ),
          child: child,
        );
        break;

      case ButtonVariant.text:
        button = TextButton(
          onPressed: _disabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? _bg,
            shape: _shape,
            minimumSize: Size(0, height),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
        break;
    }

    if (effectiveWidth != null) {
      return SizedBox(width: effectiveWidth, child: button);
    }
    return button;
  }
}
