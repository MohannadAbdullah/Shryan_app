import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/global_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title ?? GlobalConstants.appName,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leading: leading ?? _buildDefaultLeading(),
      actions: actions ?? _buildDefaultActions(),
    );
  }

  Widget _buildDefaultLeading() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipOval(
        child: Image.asset(
          'assets/images/Logo.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 40,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      IconButton(
        icon: const Icon(Icons.notifications_none, color: Colors.blueGrey),
        onPressed: () {},
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
