class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String createdAt;
  final int read;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.read,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'message': message,
        'createdAt': createdAt,
        'read': read,
      };

  factory NotificationItem.fromMap(Map<String, Object?> map) => NotificationItem(
        id: map['id'] as String,
        title: map['title'] as String,
        message: map['message'] as String,
        createdAt: map['createdAt'] as String,
        read: map['read'] as int,
      );
}