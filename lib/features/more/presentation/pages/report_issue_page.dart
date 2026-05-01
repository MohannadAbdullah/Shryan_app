import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/custom_dropdown_field.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
        title: const Text('شريان', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
            const Text('إرسال بلاغ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'نحن هنا لنسمعك. يرجى تزويدنا بتفاصيل المشكلة لنتمكن من مساعدتك بأفضل شكل ممكن.',
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نوع البلاغ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  CustomDropdownField<String>(
                    hintText: 'اختر نوع البلاغ',
                    items: ['مشكلة تقنية', 'اقتراح', 'شكوى'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Text('تفاصيل المشكلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'يرجى وصف المشكلة التي تواجهها بالتفصيل...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.security, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('نظام آمن', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 12)),
                              Text('يتم التعامل مع بلاغك بسرية تامة من قبل فريقنا المختص.', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'إرسال',
              icon: Icons.send,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
