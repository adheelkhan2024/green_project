import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              await controller.notificationService.markAllRead();
              await controller.refresh();
            },
            child: const Text('Mark read'),
          ),
        ],
      ),
      body: controller.notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final item = controller.notifications[index];
                return Card(
                  child: ListTile(
                    leading: Icon(item.read == 1 ? Icons.notifications_none : Icons.notifications_active, color: const Color(0xFF168257)),
                    title: Text(item.title, style: TextStyle(fontWeight: item.read == 1 ? FontWeight.w500 : FontWeight.w900)),
                    subtitle: Text('${item.message}\n${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(item.createdAt))}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}