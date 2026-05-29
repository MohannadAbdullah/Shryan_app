import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,{required String title}) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leadingWidth: 100,
      leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Image.asset(
            'assets/images/Logo.png',
            fit: BoxFit.contain,
          ),
        ),
     
    );
  }