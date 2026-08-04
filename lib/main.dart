import 'dart:io';
import 'package:flutter/material.dart';

// Tes imports d'écrans (chemins à adapter selon ton projet)
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_step1_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/formations/formations_screen.dart';
import 'core/constants/app_routes.dart';

// 🌓 Notifier global pour contrôler le thème dynamiquement dans toute l'application
// Il est défini ICI pour être accessible partout.
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
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ C'est ici que la magie opère : ValueListenableBuilder écoute themeNotifier
    // À chaque changement de valeur, il reconstruit tout le MaterialApp.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'KH SERVICES', 
          debugShowCheckedModeBanner: false,
          
          // 1. Le mode actuel (System, Light, ou Dark) dicté par le notifier
          themeMode: currentThemeMode,
          
          // 2. Thème CLAIR (Défini proprement)
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF0F2B5B),
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
            cardColor: Colors.white,
            dividerColor: Colors.grey.withOpacity(0.2), // Pour les séparateurs
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F2B5B),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F2B5B),
              brightness: Brightness.light,
            ),
            // Ajout explicite pour forcer la couleur du texte si nécessaire
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black54),
            ),
          ),
          
          // 2. Thème SOMBRE (Défini proprement)
          darkTheme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF0F2B5B),
            scaffoldBackgroundColor: const Color(0xFF121212),
            brightness: Brightness.dark,
            cardColor: const Color(0xFF1E1E1E),
            dividerColor: Colors.white.withOpacity(0.1), // Pour les séparateurs
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F2B5B),
              brightness: Brightness.dark,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
            // Force la couleur des switches/checkboxes dans le thème sombre
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.all(Colors.green),
              trackColor: WidgetStateProperty.all(Colors.green.withOpacity(0.5)),
            ),
          ),
          
          // 3. Écran de démarrage
          home: const SplashScreen(),
          
          // 4. TABLE DES ROUTES
          routes: {
            AppRoutes.home: (context) => const MainScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            // Autres routes...
          },
        );
      },
    );
  }
}