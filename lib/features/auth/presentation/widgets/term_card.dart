import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TermCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;
  final bool hasRedBorder;
  final Color iconColor;

  const TermCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    this.hasRedBorder = false,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          if (hasRedBorder)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
