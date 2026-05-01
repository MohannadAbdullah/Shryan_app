import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common_widgets/custom_text_field.dart';
import '../../../../core/common_widgets/custom_dropdown_field.dart';

class RegisterStepOne extends StatelessWidget {
  const RegisterStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مرحباً بك معنا',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        const Text(
          'أدخل بريدك الإلكتروني للبدء في إنشاء حسابك والمساهمة في إنقاذ الأرواح.',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 32),
        
        const Text(
          'البريد الإلكتروني',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        const CustomTextField(
          hintText: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icons.email,
        ),
        
        const SizedBox(height: 20),

        const Text(
          'كلمة المرور',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        const CustomTextField(
          hintText: '........',
          isPassword: true,
          suffixIcon: Icons.lock,
        ),
        
        const SizedBox(height: 20),

        const Text(
          'تأكيد كلمة المرور',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        const CustomTextField(
          hintText: '........',
          isPassword: true,
          suffixIcon: Icons.lock,
        ),
      ],
    );
  }
}

class RegisterStepTwo extends StatelessWidget {
  const RegisterStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الاسم الكامل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        const CustomTextField(hintText: 'الاسم كما في الهوية', suffixIcon: Icons.person),
        
        const SizedBox(height: 20),

        const Text('رقم الهاتف', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        const CustomTextField(hintText: '05X XXX XXXX', keyboardType: TextInputType.phone, suffixIcon: Icons.phone),
        
        const SizedBox(height: 20),

        const Text('فصيلة الدم', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        CustomDropdownField<String>(
          hintText: 'اختر فصيلة الدم',
          suffixIcon: Icons.bloodtype,
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),

        const SizedBox(height: 20),

        const Text('كلمة المرور', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        const CustomTextField(
          hintText: '........',
          isPassword: true,
          suffixIcon: Icons.lock,
          prefixIcon: Icon(Icons.visibility_off, color: Colors.grey),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('العمر', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  const CustomTextField(hintText: 'سنوات', keyboardType: TextInputType.number),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الجنس', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  CustomDropdownField<String>(
                    hintText: 'الجنس',
                    items: ['ذكر', 'أنثى']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RegisterStepThree extends StatelessWidget {
  const RegisterStepThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'معلومات إضافية',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'خطوتك الأخيرة لتصبح منقذاً للحياة. ساعدنا في توجيه طلبات التبرع العاجلة إليك بدقة.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 32),
        
        const Text('المحافظة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        CustomDropdownField<String>(
          hintText: 'اختر المحافظة...',
          items: ['الرياض', 'مكة المكرمة', 'المدينة المنورة', 'الشرقية']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
        
        const SizedBox(height: 20),

        const Text('المنطقة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        CustomDropdownField<String>(
          hintText: 'اختر المنطقة...',
          items: ['المنطقة ١', 'المنطقة ٢']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('تاريخ آخر تبرع بالدم', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('اختياري', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const CustomTextField(
          hintText: 'mm/dd/yyyy',
          keyboardType: TextInputType.datetime,
          suffixIcon: Icons.calendar_today,
        ),
        const SizedBox(height: 8),
        const Text(
          'يساعدنا هذا في معرفة متى ستكون مستعداً للتبرع مرة أخرى (يفضل مرور 3-4 أشهر).',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
