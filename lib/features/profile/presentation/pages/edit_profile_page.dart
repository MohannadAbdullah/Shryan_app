import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_text_field.dart';
import '../../../../core/common_widgets/custom_dropdown_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'عبدالله القحطاني');
  final TextEditingController _phoneController = TextEditingController(text: '780418203');
  final TextEditingController _ageController = TextEditingController(text: '23');

  String _selectedGender = 'ذكر';
  String _selectedGov = 'تعز';
  String _selectedDistrict = 'المظفر';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'تعديل المعلومات',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar section
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryColor, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            const Text('الاسم الكامل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'الاسم',
              controller: _nameController,
              suffixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            const Text('رقم الهاتف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'رقم الهاتف',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              suffixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('العمر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'سنوات',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الجنس', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      CustomDropdownField<String>(
                        hintText: 'اختر',
                        value: _selectedGender,
                        items: ['ذكر', 'أنثى'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGender = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text('المحافظة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            CustomDropdownField<String>(
              hintText: 'اختر المحافظة',
              value: _selectedGov,
              items: ['تعز', 'صنعاء', 'عدن', 'إب', 'الحديدة'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedGov = val);
              },
            ),
            const SizedBox(height: 16),

            const Text('المديرية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            CustomDropdownField<String>(
              hintText: 'اختر المديرية',
              value: _selectedDistrict,
              items: ['المظفر', 'القاهرة', 'صالة'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDistrict = val);
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            CustomButton(
              text: 'حفظ التعديلات',
              icon: Icons.save,
              onPressed: () {
                // Return back after saving
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ التعديلات بنجاح!', style: TextStyle(fontFamily: 'Cairo')),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
