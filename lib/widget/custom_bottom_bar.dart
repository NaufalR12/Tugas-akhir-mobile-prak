import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:GoShipp/pages/dashboard.dart';
import 'package:GoShipp/pages/cekOngkir.dart';
import 'package:GoShipp/pages/pengaturan.dart';
import 'package:GoShipp/pages/profil_view.dart';

class CustomBottomBar extends StatelessWidget {
  final int activeIndex;
  const CustomBottomBar({Key? key, required this.activeIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = [
      _NavItem(icon: Icons.home, label: 'Home', page: Dashboard()),
      _NavItem(
          icon: Icons.price_change_outlined,
          label: 'Cek Ongkir',
          page: CekOngkir()),
      _NavItem(icon: Icons.settings, label: 'Pengaturan', page: Pengaturan()),
      _NavItem(icon: Icons.person, label: 'Akun Anda', page: ProfilView()),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Color(0xFFB6E5F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == activeIndex;
          return Expanded(
            child: InkWell(
              onTap: () {
                if (!isActive) {
                  Get.offAll(() => item.page);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF00C3D4)
                          : Colors.white,
                      size: 28,
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color(0xFF00C3D4)
                            : Colors.white,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Widget page;
  _NavItem({required this.icon, required this.label, required this.page});
}
