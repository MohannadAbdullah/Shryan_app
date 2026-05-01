import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
        title: const Text('الإعدادات', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150'),
              radius: 16,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تفضيلات التطبيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildListTile(title: 'اللغة', trailingText: 'العربية', icon: Icons.language),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('إشعارات الطوارئ', style: TextStyle(fontSize: 14)),
                    secondary: const Icon(Icons.notifications_active_outlined, color: AppTheme.primaryColor),
                    value: _notificationsEnabled,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildListTile(title: 'المظهر', trailingText: 'فاتح', icon: Icons.dark_mode_outlined),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('الحساب والأمان', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: _buildListTile(title: 'تغيير كلمة المرور', icon: Icons.lock_reset, iconColor: AppTheme.primaryColor),
            ),
            const SizedBox(height: 32),

            const Text('منطقة الخطر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: AppTheme.primaryColor),
                title: const Text('حذف الحساب', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'سيؤدي حذف حسابك إلى إزالة كافة البيانات المرتبطة بملفك الشخصي وسجلات التبرع بشكل دائم.',
              style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required String title, String? trailingText, required IconData icon, Color iconColor = Colors.black87}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          if (trailingText != null) const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
