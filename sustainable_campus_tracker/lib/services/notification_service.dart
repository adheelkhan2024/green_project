import 'package:uuid/uuid.dart';

import '../models/notification_item.dart';
import 'database_service.dart';

class NotificationService {
  final _uuid = const Uuid();

  Future<List<NotificationItem>> getNotifications() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('notifications', orderBy: 'createdAt DESC');
    return rows.map(NotificationItem.fromMap).toList();
  }

  Future<void> add(String title, String message) async {
    final db = await DatabaseService.instance.database;
    final item = NotificationItem(
      id: _uuid.v4(),
      title: title,
      message: message,
      createdAt: DateTime.now().toIso8601String(),
      read: 0,
    );
    await db.insert('notifications', item.toMap());
  }

  Future<void> markAllRead() async {
    final db = await DatabaseService.instance.database;
    await db.update('notifications', {'read': 1});
  }
}