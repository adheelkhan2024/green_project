import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/app_user.dart';
import 'database_service.dart';

class AuthService {
  final _uuid = const Uuid();

  Future<void> seedDemoUsers() async {
    final db = await DatabaseService.instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users')) ?? 0;
    if (count > 0) return;
    await register(name: 'Campus Admin', email: 'admin@campus.edu', password: 'Admin123!', role: 'Admin');
    await register(name: 'Student User', email: 'student@campus.edu', password: 'Student123!', role: 'Student/User');
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final db = await DatabaseService.instance.database;
    final salt = _salt();
    final user = AppUser(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      role: role,
      passwordHash: _hash(password, salt),
      salt: salt,
    );
    await db.insert('users', user.toMap());
    return user;
  }

  Future<AppUser?> login(String email, String password) async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('users', where: 'email = ?', whereArgs: [email.trim().toLowerCase()], limit: 1);
    if (rows.isEmpty) return null;
    final user = AppUser.fromMap(rows.first);
    return user.passwordHash == _hash(password, user.salt) ? user : null;
  }

  String _salt() {
    final random = Random.secure();
    return List.generate(24, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }

  String _hash(String password, String salt) {
    return sha256.convert(utf8.encode('$salt:$password')).toString();
  }
}