import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/global_constants.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SharyanApp(),
    ),
  );
}

class SharyanApp extends StatelessWidget {
  const SharyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: GlobalConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // RTL Setup
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // Arabic
      ],
      locale: const Locale('ar', 'SA'), // Default to Arabic (RTL)
      routerConfig: AppRouter.router,
    );
  }
}
