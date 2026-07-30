import 'dart:io';
import 'package:flutter/material.dart';

// Tes imports
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_step1_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/formations/formations_screen.dart';
import 'core/constants/app_routes.dart';

// 🌓 Notifier global pour contrôler le thème dynamiquement dans toute l'application
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  
  // ✅ On lance directement l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          // ✅ CHANGEMENT DU NOM DE L'APPLICATION ICI
          title: 'KH SERVICES', 
          
          debugShowCheckedModeBanner: false,
          themeMode: currentThemeMode,
          
          // 1. Thème CLAIR
          theme: ThemeData(
            primaryColor: const Color(0xFF0F2B5B),
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F2B5B),
              foregroundColor: Colors.white,
            ),
          ),
          
          // 2. Thème SOMBRE
          darkTheme: ThemeData(
            primaryColor: const Color(0xFF0F2B5B),
            scaffoldBackgroundColor: const Color(0xFF121212),
            brightness: Brightness.dark,
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
          ),
          
          // 3. Écran de démarrage
          home: const SplashScreen(),
          
          // 4. TABLE DES ROUTES
          routes: {
            AppRoutes.home: (context) => const MainScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}