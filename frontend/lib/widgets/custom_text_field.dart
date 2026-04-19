import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

/// Ô nhập liệu dùng chung – khớp với thiết kế Figma.
///
/// Bo góc 10px (Figma), hỗ trợ: label, clear button (✕),
/// toggle mật khẩu (👁), dropdown (readOnly + suffixIcon chevron).
///
/// ```dart
/// // Username (Figma login – có nút ✕)
/// CustomTextField(
///   label: 'Tên đăng nhập',
///   controller: _usernameCtrl,
///   showClearButton: true,
/// )
///
/// // Password (Figma login – có icon 👁)
/// CustomTextField(
///   label: 'Mật khẩu',
///   controller: _passwordCtrl,
///   obscureText: true,
///   showTogglePassword: true,
/// )
///
/// // Dropdown-like (Figma hồ sơ – readOnly + chevron)
/// CustomTextField(
///   label: 'Đơn vị hiện tại',
///   controller: _unitCtrl,
///   readOnly: true,
///   onTap: () => _showUnitPicker(),
///   suffixIcon: Icon(Icons.keyboard_arrow_down),
/// )
/// ```
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.showTogglePassword = false,
    this.showClearButton = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.borderRadius = 10,
  });

  final TextEditingController? controller;

  /// Nhãn phía trên ô nhập (Figma: "Tên đăng nhập", "Mật khẩu", …).
  final String? label;

  /// Placeholder bên trong ô.
  final String? hintText;

  /// Ghi chú phía dưới ô.
  final String? helperText;

  /// Lỗi hiển thị phía dưới ô (ưu tiên hơn [helperText]).
  final String? errorText;

  /// Icon bên trái.
  final IconData? prefixIcon;

  /// Widget bên phải tuỳ chỉnh. Bị ghi đè nếu
  /// [showTogglePassword] hoặc [showClearButton] bật.
  final Widget? suffixIcon;

  /// Ẩn ký tự (mật khẩu).
  final bool obscureText;

  /// Hiện nút bật/tắt hiện mật khẩu (Figma: icon 👁 ở ô Mật khẩu).
  final bool showTogglePassword;

  /// Hiện nút xoá nội dung ✕ (Figma: icon ✕ ở ô Tên đăng nhập).
  final bool showClearButton;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Callback khi tap vào trường (hữu ích cho dropdown / date-picker).
  final VoidCallback? onTap;

  final int maxLines;
  final int? maxLength;
  final bool enabled;

  /// Chế độ chỉ đọc (dùng cho dropdown-like trong Figma hồ sơ).
  final bool readOnly;

  final bool autofocus;
  final FocusNode? focusNode;

  /// Bo góc (mặc định 10 – khớp Figma text field).
  final double borderRadius;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  // ── Suffix logic ────────────────────────────

  Widget? _buildSuffix() {
    // Ưu tiên 1: Toggle mật khẩu
    if (widget.showTogglePassword) {
      return IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.greyMedium,
          size: 22,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    // Ưu tiên 2: Clear button (✕)
    if (widget.showClearButton && widget.controller != null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller!,
        builder: (_, value, child) {
          if (value.text.isEmpty) return const SizedBox.shrink();
          return IconButton(
            icon: const Icon(
              Icons.close,
              color: AppColors.greyMedium,
              size: 20,
            ),
            onPressed: () {
              widget.controller!.clear();
              widget.onChanged?.call('');
            },
          );
        },
      );
    }

    // Ưu tiên 3: Widget tuỳ chỉnh
    return widget.suffixIcon;
  }

  // ── Build ───────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(widget.borderRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.greyMedium,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── TextField ──
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscured,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.black),
          decoration: InputDecoration(
            hintText: widget.hintText,
            helperText: widget.errorText == null ? widget.helperText : null,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.greyMedium, size: 22)
                : null,
            suffixIcon: _buildSuffix(),
            border: OutlineInputBorder(
              borderRadius: br,
              borderSide: const BorderSide(color: AppColors.greyLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: const BorderSide(color: AppColors.greyLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
