import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'screens/ai_insights_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/project_form_screen.dart';
import 'screens/project_list_screen.dart';
import 'screens/team_management_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SustainableCampusApp());
}

class SustainableCampusApp extends StatelessWidget {
  const SustainableCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppController()..bootstrap(),
      child: MaterialApp(
        title: 'Sustainable Campus Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF168257)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF3F8F1),
          cardTheme: CardThemeData(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        routes: {
          '/': (_) => const AuthGate(),
          '/dashboard': (_) => const DashboardScreen(),
          '/projects': (_) => const ProjectListScreen(),
          '/project-form': (_) => const ProjectFormScreen(),
          '/team': (_) => const TeamManagementScreen(),
          '/notifications': (_) => const NotificationsScreen(),
          '/ai': (_) => const AiInsightsScreen(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return controller.currentUser == null ? const LoginScreen() : const DashboardScreen();
  }
}