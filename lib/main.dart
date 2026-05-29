// =============================================================================
// main.dart — Entry point for the Sharyan Blood Donation App
// Architecture: Feature-First with MVC principles per feature
// State Management: Riverpod (ProviderScope) + Provider (ThemeProvider)
// Backend: Firebase (Auth, Firestore, Cloud Messaging)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart' as pkg_provider;

import 'package:sharyan/firebase_options.dart';
import 'package:sharyan/core/constants/global_constants.dart';
import 'package:sharyan/core/routing/app_router.dart';
import 'package:sharyan/core/theme/app_theme.dart';
import 'package:sharyan/core/theme/theme_provider.dart';

// -----------------------------------------------------------------------------
// Background FCM Handler
// Must be a top-level function (outside any class) so FCM can call it
// when the app is terminated or in the background.
// -----------------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Re-initialize Firebase in the background isolate before using any service.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('📬 Background notification received: ${message.messageId}');
}

// -----------------------------------------------------------------------------
// App Entry Point
// -----------------------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase before any other Firebase service is accessed.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Register the background FCM handler.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 3. Wrap app in Riverpod's ProviderScope for all Riverpod-based providers,
  //    then launch the root widget.
  runApp(const ProviderScope(child: SharyanApp()));
}

// -----------------------------------------------------------------------------
// Root Widget
// -----------------------------------------------------------------------------
class SharyanApp extends StatelessWidget {
  const SharyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ThemeProvider uses the legacy `provider` package for theme switching.
    // Placed at the root so every descendant widget can access it.
    return pkg_provider.ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          final themeProvider =
              pkg_provider.Provider.of<ThemeProvider>(context);

          return MaterialApp.router(
            // ── App Identity ───────────────────────────────────────────────
            title: GlobalConstants.appName,
            debugShowCheckedModeBanner: false,

            // ── Theming ────────────────────────────────────────────────────
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // ── RTL / Arabic Localization ──────────────────────────────────
            locale: const Locale('ar', 'SA'),
            supportedLocales: const [Locale('ar', 'SA')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // ── Routing (go_router) ────────────────────────────────────────
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}