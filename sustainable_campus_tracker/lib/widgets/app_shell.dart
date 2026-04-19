import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';

class AppShell extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const AppShell({super.key, required this.title, required this.child, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(onPressed: () => Navigator.pushNamed(context, '/notifications'), icon: const Icon(Icons.notifications_outlined)),
              if (controller.unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(radius: 8, child: Text('${controller.unreadNotifications}', style: const TextStyle(fontSize: 9))),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              controller.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(child: child),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) {
          final route = ['/dashboard', '/projects', '/ai'][index];
          if (ModalRoute.of(context)?.settings.name != route) Navigator.pushReplacementNamed(context, route);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.eco_outlined), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'AI'),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final name = ModalRoute.of(context)?.settings.name;
    if (name == '/projects') return 1;
    if (name == '/ai') return 2;
    return 0;
  }
}