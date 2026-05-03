import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

const _bg = Color(0xFFF1F5F9);
const _navStart = Color(0xFF0D1B49);
const _navEnd = Color(0xFF1E40AF);
const _text = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);
const _border = Color(0xFFE2E8F0);
const _field = Color(0xFFF8FAFC);
const _danger = Color(0xFFC62828);
const _warning = Color(0xFFDC6803);

class AppBottomNavScaffold extends StatelessWidget {
  const AppBottomNavScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
    this.onLogout,
  });

  final int currentIndex;
  final Widget child;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: child,
      bottomNavigationBar: Container(
        height: 45,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [_navStart, _navEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIcon(
              icon: Icons.account_circle_outlined,
              selectedIcon: Icons.account_circle,
              selected: currentIndex == 0,
              onTap: () => context.go('/app/profile'),
            ),
            _NavIcon(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              selected: currentIndex == 1,
              onTap: () => context.go('/app'),
            ),
            _NavIcon(
              icon: Icons.qr_code_2,
              selectedIcon: Icons.qr_code_2,
              selected: currentIndex == 2,
              onTap: () => context.go('/app/qr'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomNavScaffold(
      currentIndex: 0,
      child: _Canvas(
        minHeight: 1258,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TopTitle('Hồ sơ', fontSize: 24),
            const SizedBox(height: 68),
            _ProfileHeroCard(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _SectionTitle('Thông tin cá nhân'),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => context.go('/app/profile/edit'),
                    child: const Icon(Icons.edit_outlined, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            _InfoCard(
              children: const [
                _InfoGridRow([_InfoItem('Họ tên', 'Nguyễn Văn A')]),
                _InfoGridRow([
                  _InfoItem('Ngày sinh', '11/11/2004'),
                  _InfoItem('Giới tính', 'Nam'),
                ]),
                _InfoGridRow([
                  _InfoItem('CCCD', '078912345'),
                  _InfoItem('Số điện thoại', '789456123'),
                ]),
                _InfoGridRow([_InfoItem('Quê quán', 'Thành Phố Hồ Chí Minh')]),
                _InfoGridRow([_InfoItem('Đơn vị', 'Phòng an ninh mạng')]),
                _InfoGridRow([
                  _InfoItem('Cấp bậc', 'Trung úy'),
                  _InfoItem('Chức vụ', 'Phó đội trưởng'),
                ]),
                _InfoGridRow([_InfoItem('Email', 'nguyenvana@gmail.com')]),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _SectionTitle('Đơn vị'),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.go('/app/profile/transfer'),
                    child: Row(
                      children: [
                        Text(
                          'Chuyển sinh hoạt',
                          style: _inter(
                            color: _muted,
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: _muted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            _InfoCard(
              children: [
                const _InfoGridRow([_InfoItem('Đơn vị', 'Phòng an ninh mạng')]),
                const _InfoGridRow([_InfoItem('Mã đơn vị', 'DV123')]),
                const _InfoGridRow([
                  _InfoItem('Đơn vị cấp trên', 'Công an TP.HCM'),
                ]),
                const _InfoGridRow([_InfoItem('Cấp đơn vị', 'Cấp 2')]),
                const SizedBox(height: 4),
                _PillButton(
                  label: 'Xem lịch sử chuyển sinh hoạt',
                  onTap: () => context.go('/app/profile/transfer-history'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomNavScaffold(
      currentIndex: 0,
      child: _Canvas(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppHeader(
              title: 'Chỉnh sửa thông tin',
              onBack: () => context.go('/app/profile'),
            ),
            const SizedBox(height: 119),
            _Panel(
              padding: const EdgeInsets.fromLTRB(12, 15, 12, 31),
              child: Column(
                children: [
                  const _EditField(label: 'Họ tên', value: 'Nguyễn Văn A'),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: _EditField(
                          label: 'Ngày sinh',
                          value: '11/11/2004',
                          width: 90,
                        ),
                      ),
                      SizedBox(width: 88),
                      Expanded(
                        child: _EditField(
                          label: 'Giới tính',
                          value: 'Nam',
                          dropdown: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: _EditField(
                          label: 'CCCD',
                          value: '078912345',
                          disabled: true,
                        ),
                      ),
                      SizedBox(width: 84),
                      Expanded(
                        child: _EditField(
                          label: 'Số điện thoại',
                          value: '789456123',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const _EditField(
                    label: 'Quê quán',
                    value: 'Thành Phố Hồ Chí Minh',
                    dropdown: true,
                  ),
                  const SizedBox(height: 8),
                  const _EditField(
                    label: 'Đơn vị',
                    value: 'Phòng an ninh mạng',
                    dropdown: true,
                    disabled: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: _EditField(
                          label: 'Cấp bậc',
                          value: 'Trung úy',
                          dropdown: true,
                          disabled: true,
                        ),
                      ),
                      SizedBox(width: 86),
                      Expanded(
                        child: _EditField(
                          label: 'Chức vụ',
                          value: 'Phó đội trưởng',
                          dropdown: true,
                          disabled: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const _EditField(
                    label: 'Email',
                    value: 'nguyenvana@gmail.com',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: _PrimaryButton(label: 'Lưu', width: 134, onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferActivityScreen extends StatelessWidget {
  const TransferActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomNavScaffold(
      currentIndex: 0,
      child: _Canvas(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppHeader(
              title: 'Chuyển sinh hoạt',
              onBack: () => context.go('/app/profile'),
            ),
            const SizedBox(height: 77),
            _Panel(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
              child: const _InfoGridRow([
                _InfoItem(
                  'Đơn vị hiện tại',
                  'Phòng an ninh mạng - Công an TP.HCM',
                  labelColor: _text,
                ),
              ]),
            ),
            const SizedBox(height: 15),
            _Panel(
              padding: const EdgeInsets.fromLTRB(12, 13, 12, 24),
              child: Column(
                children: const [
                  _EditField(
                    label: 'Đơn vị chuyển tới',
                    value: 'Phòng an ninh mạng',
                    dropdown: true,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _EditField(
                          label: 'Mã đơn vị',
                          value: 'DV123',
                          dropdown: true,
                        ),
                      ),
                      SizedBox(width: 44),
                      Expanded(
                        child: _EditField(
                          label: 'Cấp đơn vị',
                          value: 'Cấp 2',
                          dropdown: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _EditField(
                    label: 'Đơn vị cấp trên',
                    value: 'Công an TP.HCM',
                    dropdown: true,
                  ),
                  SizedBox(height: 8),
                  _EditField(
                    label: 'Lí do',
                    value:
                        'Luân chuyển công tác theo quyết định điều động\nnội bộ',
                    height: 112,
                    alignTop: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _Panel(
              height: 89,
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Tài liệu đính kèm',
                        style: _inter(size: 12, weight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.upload_outlined, size: 16),
                    ],
                  ),
                  Text(
                    'Quyết định đồng điệu số 23/QĐ-CAT',
                    style: _inter(color: _muted, size: 10),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Ngày đề nghị',
                    style: _inter(size: 12, weight: FontWeight.w500),
                  ),
                  Text('22/4/2026', style: _inter(color: _muted, size: 10)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: _PrimaryButton(
                label: 'Gửi yêu cầu',
                width: 158,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferHistoryScreen extends StatelessWidget {
  const TransferHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomNavScaffold(
      currentIndex: 0,
      child: _Canvas(
        child: Column(
          children: [
            _AppHeader(
              title: 'Lịch sử chuyển sinh hoạt',
              onBack: () => context.go('/app/profile'),
            ),
            const SizedBox(height: 84),
            _HistoryCard(
              status: 'Chưa được duyệt',
              statusColor: _danger,
              statusBg: const Color(0xFFFDE1E1),
              onTap: () => context.go('/app/profile/transfer-history/detail'),
            ),
            const SizedBox(height: 25),
            _HistoryCard(
              status: 'Đã được duyệt',
              statusColor: _warning,
              statusBg: const Color(0xFFFCF0DB),
              onTap: () => context.go('/app/profile/transfer-history/detail'),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferHistoryDetailScreen extends StatelessWidget {
  const TransferHistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomNavScaffold(
      currentIndex: 0,
      child: _Canvas(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppHeader(
              title: 'Chi tiết lịch sử chuyển sinh hoạt',
              fontSize: 18,
              onBack: () => context.go('/app/profile/transfer-history'),
            ),
            const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trạng thái', style: _inter(color: _muted, size: 10)),
                  Text(
                    'Đã được duyệt',
                    style: _inter(
                      color: _warning,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            _Panel(
              height: 99,
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 12),
              child: const Column(
                children: [
                  _InfoGridRow([
                    _InfoItem(
                      'Người duyệt',
                      'Bí thư Nguyễn Văn B',
                      labelColor: _text,
                    ),
                  ]),
                  SizedBox(height: 6),
                  _InfoGridRow([
                    _InfoItem('Ngày duyệt', '25/4/2026', labelColor: _text),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Panel(
              padding: const EdgeInsets.fromLTRB(20, 23, 20, 28),
              child: const Column(
                children: [
                  _InfoGridRow([
                    _InfoItem(
                      'Đơn vị cũ',
                      'Phòng an ninh mạng - Công an TP.HCM',
                    ),
                  ]),
                  _InfoGridRow([
                    _InfoItem('Đơn vị chuyển tới', 'Phòng an ninh mạng'),
                  ]),
                  _InfoGridRow([
                    _InfoItem('Mã đơn vị', 'DV123'),
                    _InfoItem('Cấp đơn vị', 'Cấp 2'),
                  ]),
                  _InfoGridRow([
                    _InfoItem('Đơn vị cấp trên', 'Công an TP.HCM'),
                  ]),
                  _InfoGridRow([
                    _InfoItem(
                      'Lí do',
                      'Luân chuyển công tác theo quyết định điều động\nnội bộ',
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Panel(
              height: 89,
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tài liệu đính kèm',
                    style: _inter(size: 12, weight: FontWeight.w500),
                  ),
                  Text(
                    'Quyết định đồng điệu số 23/QĐ-CAT',
                    style: _inter(color: _muted, size: 10),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Ngày đề nghị',
                    style: _inter(size: 12, weight: FontWeight.w500),
                  ),
                  Text('22/4/2026', style: _inter(color: _muted, size: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Canvas extends StatelessWidget {
  const _Canvas({required this.child, this.minHeight = 799});

  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 390 ? constraints.maxWidth : 390.0;
        final height = constraints.maxHeight > minHeight
            ? constraints.maxHeight
            : minHeight;

        return SingleChildScrollView(
          child: Center(
            child: SizedBox(width: width, height: height, child: child),
          ),
        );
      },
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({
    required this.title,
    required this.onBack,
    this.fontSize = 20,
  });

  final String title;
  final VoidCallback onBack;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      color: AppColors.white,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 18,
            child: InkWell(
              onTap: onBack,
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.chevron_left, size: 32, color: _text),
              ),
            ),
          ),
          Positioned.fill(
            top: 10,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                title,
                style: _poppins(size: fontSize, weight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTitle extends StatelessWidget {
  const _TopTitle(this.title, {this.fontSize = 20});

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      color: AppColors.white,
      alignment: Alignment.center,
      child: Text(
        title,
        style: _poppins(size: fontSize, weight: FontWeight.w700),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.only(top: 40),
          decoration: _cardDecoration(),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Xin chào! Trung úy',
                  style: _poppins(size: 18, weight: FontWeight.w400),
                ),
                Text(
                  'Văn A',
                  style: _poppins(size: 24, weight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -44,
          child: Container(
            width: 105,
            height: 105,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_circle, color: _text, size: 96),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 13),
      child: Column(children: children),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.height,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double? height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: padding,
      decoration: _cardDecoration(),
      child: child,
    );
  }
}

class _InfoGridRow extends StatelessWidget {
  const _InfoGridRow(this.items);

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: items[i]),
            if (i != items.length - 1) const SizedBox(width: 22),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem(this.label, this.value, {this.labelColor = _muted});

  final String label;
  final String value;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _inter(color: labelColor, size: 12, weight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(value, style: _inter(size: 14)),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.value,
    this.dropdown = false,
    this.disabled = false,
    this.height = 34,
    this.width,
    this.alignTop = false,
  });

  final String label;
  final String value;
  final bool dropdown;
  final bool disabled;
  final double height;
  final double? width;
  final bool alignTop;

  @override
  Widget build(BuildContext context) {
    final color = disabled ? _text.withValues(alpha: 0.5) : _text;
    final labelColor = disabled ? _muted.withValues(alpha: 0.5) : _muted;
    final fieldColor = disabled ? _field.withValues(alpha: 0.5) : _field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _inter(color: labelColor, size: 12, weight: FontWeight.w500),
        ),
        const SizedBox(height: 3),
        Container(
          width: width,
          height: height,
          padding: EdgeInsets.fromLTRB(7, alignTop ? 12 : 0, 7, 0),
          alignment: alignTop ? Alignment.topLeft : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: _border),
          ),
          child: Row(
            crossAxisAlignment: alignTop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(value, style: _inter(color: color, size: 14)),
              ),
              if (dropdown)
                const Icon(Icons.keyboard_arrow_down, size: 20, color: _muted),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.onTap,
  });

  final String status;
  final Color statusColor;
  final Color statusBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: _Panel(
        height: 115,
        padding: const EdgeInsets.fromLTRB(20, 10, 8, 9),
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 0,
              child: _HistoryUnitBlock(title: 'Đơn vị cũ'),
            ),
            const Positioned(
              left: 0,
              top: 40,
              child: _HistoryUnitBlock(title: 'Đơn vị mới'),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text('22/4/2026', style: _inter(size: 10)),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Row(
                children: [
                  Text(
                    'Chi tiết',
                    style: _inter(
                      color: _muted,
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: _muted),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  status,
                  style: _poppins(
                    color: statusColor,
                    size: 12,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryUnitBlock extends StatelessWidget {
  const _HistoryUnitBlock({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 245,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _inter(size: 12, weight: FontWeight.w500)),
          Text(
            'Phòng an ninh mạng - Công an TP.HCM',
            style: _inter(size: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(selected ? selectedIcon : icon),
      color: AppColors.white,
      iconSize: 32,
      padding: EdgeInsets.zero,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _poppins(size: 18, weight: FontWeight.w700));
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFDCEDFC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: _poppins(
            color: const Color(0xFF1465B4),
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.width,
    required this.onTap,
  });

  final String label;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: width,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF343B53), _navEnd],
          ),
        ),
        child: Text(
          label,
          style: _poppins(
            color: AppColors.white,
            size: 16,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 4)),
    ],
  );
}

TextStyle _inter({
  Color color = _text,
  double size = 14,
  FontWeight weight = FontWeight.w400,
}) {
  return GoogleFonts.inter(
    color: color,
    fontSize: size,
    fontWeight: weight,
    height: 1.25,
  );
}

TextStyle _poppins({
  Color color = _text,
  double size = 14,
  FontWeight weight = FontWeight.w600,
}) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: size,
    fontWeight: weight,
    height: 1.35,
  );
}
