import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:sharyan/shared/widgets/custom_dropdown_field.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _formKey      = GlobalKey<FormState>();
  final _detailsCtrl  = TextEditingController();
  String? _issueType;
  bool _isSending = false;

  static const _issueTypes = [
    'مشكلة تقنية',
    'اقتراح تحسين',
    'شكوى',
    'بلاغ عن محتوى مسيء',
    'أخرى',
  ];

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSending = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      await FirebaseFirestore.instance.collection('reports').add({
        'uid':       uid,
        'issueType': _issueType,
        'details':   _detailsCtrl.text.trim(),
        'status':    'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // نجاح
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Text('تم إرسال بلاغك بنجاح، سنتواصل معك قريباً'),
        ]),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ));

      // إعادة تعيين النموذج
      _formKey.currentState?.reset();
      _detailsCtrl.clear();
      setState(() {
        _issueType = null;
        _isSending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [
          Icon(Icons.error_outline, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Expanded(child: Text('حدث خطأ أثناء الإرسال، يرجى المحاولة لاحقاً')),
        ]),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'شريان',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── العنوان ─────────────────────────────────────────────────
              Text(
                'إرسال بلاغ',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color),
              ),
              const SizedBox(height: 8),
              Text(
                'نحن هنا لنسمعك. يرجى تزويدنا بتفاصيل المشكلة لنتمكن من مساعدتك بأفضل شكل ممكن.',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.grey,
                    fontSize: 14,
                    height: 1.5),
              ),
              const SizedBox(height: 32),

              // ── بطاقة النموذج ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // نوع البلاغ
                    Text(
                      'نوع البلاغ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color:
                              Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 8),
                    CustomDropdownField<String>(
                      hintText: 'اختر نوع البلاغ',
                      value: _issueType,
                      validator: (v) =>
                          v == null ? 'يرجى اختيار نوع البلاغ' : null,
                      items: _issueTypes
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _issueType = val);
                      },
                    ),
                    const SizedBox(height: 24),

                    // تفاصيل المشكلة
                    Text(
                      'تفاصيل المشكلة',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color:
                              Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _detailsCtrl,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText:
                            'يرجى وصف المشكلة التي تواجهها بالتفصيل...',
                        hintStyle: TextStyle(
                            color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color ??
                                Colors.grey,
                            fontSize: 14),
                        filled: true,
                        fillColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) => (v == null || v.trim().length < 10)
                          ? 'يرجى كتابة تفاصيل كافية (١٠ أحرف على الأقل)'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // نظام آمن
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.security,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'نظام آمن',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 12),
                                ),
                                Text(
                                  'يتم التعامل مع بلاغك بسرية تامة من قبل فريقنا المختص.',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                      fontSize: 10),
                                ),
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
                text: _isSending ? 'جاري الإرسال...' : 'إرسال البلاغ',
                icon: Icons.send,
                isLoading: _isSending,
                onPressed: _isSending ? null : _submit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
