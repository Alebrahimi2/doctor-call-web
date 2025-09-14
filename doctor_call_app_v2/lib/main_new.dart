import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const DoctorCallApp());
}

class DoctorCallApp extends StatelessWidget {
  const DoctorCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Doctor Call - Hospital Management',
        debugShowCheckedModeBanner: false,
        
        // Localization
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('ar', 'SA'), // Arabic
          Locale('es', 'ES'), // Spanish
        ],
        locale: const Locale('en', 'US'),
        
        // Theme
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3), // Medical blue
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          
          // App Bar Theme
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
          
          // Card Theme
          cardTheme: const CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          
          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        
        // Dark Theme
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        
        // Routes
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        
        // Route Generator for dynamic routes
        onGenerateRoute: (settings) {
          switch (settings.name) {
            default:
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );
          }
        },
        
        // Unknown Route
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Page not found!'),
              ),
            ),
          );
        },
      ),
    );
  }
}