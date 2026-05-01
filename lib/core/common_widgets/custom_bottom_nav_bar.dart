import 'package:flutter/material.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/features/auth/presentation/pages/login_page.dart';
import 'package:sharyan/features/more/presentation/pages/settings_page.dart';
import 'package:sharyan/features/more/presentation/pages/report_issue_page.dart';
import 'package:sharyan/features/more/presentation/pages/about_app_page.dart';
import 'package:sharyan/features/more/presentation/pages/contact_us_page.dart';
import 'package:sharyan/features/more/presentation/pages/invite_friend_page.dart';

Widget buildBottomNavigationBar({
  required BuildContext context,
  required int currentIndex,
  required Function(int) onTap,
}) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) {
      if (index == 3) {
        _showMoreBottomSheet(context);
      } else {
        onTap(index);
      }
    },
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    selectedItemColor: AppTheme.primaryColor,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'السجل'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'المزيد'),
    ],
  );
}

void _showMoreBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              'المزيد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'الإعدادات والمعلومات الإضافية',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            
            // Options list
            _buildMoreMenuItem(
              icon: Icons.info_outline,
              title: 'عن التطبيق',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutAppPage()));
              },
            ),
            _buildMoreMenuItem(
              icon: Icons.settings_outlined,
              title: 'إعدادات',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
              },
            ),
            _buildMoreMenuItem(
              icon: Icons.report_problem_outlined,
              title: 'إرسال بلاغ',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportIssuePage()));
              },
            ),
            _buildMoreMenuItem(
              icon: Icons.help_outline,
              title: 'تواصل معنا',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactUsPage()));
              },
            ),
            _buildMoreMenuItem(
              icon: Icons.description_outlined,
              title: 'الشروط والأحكام',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildMoreMenuItem(
              icon: Icons.share_outlined,
              title: 'دعوة صديق',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InviteFriendPage()));
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(height: 1),
            ),
            const SizedBox(height: 12),
            _buildMoreMenuItem(
              icon: Icons.logout,
              title: 'تسجيل خروج',
              isDestructive: true,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMoreMenuItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDestructive ? AppTheme.primaryColor : Colors.black87,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDestructive ? AppTheme.primaryColor : Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isDestructive ? AppTheme.primaryColor.withOpacity(0.5) : Colors.grey.shade400,
          ),
        ],
      ),
    ),
  );
}