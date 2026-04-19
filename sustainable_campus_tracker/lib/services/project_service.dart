import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/project_document.dart';
import '../models/sustainability_project.dart';
import '../models/team_member.dart';
import 'database_service.dart';

class ProjectService {
  final _uuid = const Uuid();

  Future<void> seedProjects(String createdBy) async {
    final db = await DatabaseService.instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM projects')) ?? 0;
    if (count > 0) return;
    final now = DateTime.now();
    final projects = [
      SustainabilityProject(
        id: _uuid.v4(),
        title: 'Solar Library Roof',
        description: 'Install solar panels on the central library roof to reduce grid electricity usage.',
        status: 'In Progress',
        progress: 62,
        category: 'Energy',
        startDate: now.subtract(const Duration(days: 42)).toIso8601String(),
        dueDate: now.add(const Duration(days: 24)).toIso8601String(),
        createdBy: createdBy,
        location: 'Main Library',
        budget: 85000,
        estimatedCo2Reduction: 38,
        updatedAt: now.toIso8601String(),
      ),
      SustainabilityProject(
        id: _uuid.v4(),
        title: 'Campus Recycling Drive',
        description: 'Coordinate student volunteers to increase recycling participation across residences.',
        status: 'Planning',
        progress: 28,
        category: 'Waste',
        startDate: now.subtract(const Duration(days: 12)).toIso8601String(),
        dueDate: now.add(const Duration(days: 45)).toIso8601String(),
        createdBy: createdBy,
        location: 'Student Residences',
        budget: 12000,
        estimatedCo2Reduction: 12,
        updatedAt: now.toIso8601String(),
      ),
    ];
    for (final project in projects) {
      await saveProject(project);
      await addTeamMember(TeamMember(id: _uuid.v4(), projectId: project.id, name: 'Green Society', role: 'Coordinator', contribution: 'Planning and reporting'));
    }
  }

  Future<List<SustainabilityProject>> getProjects() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('projects', orderBy: 'updatedAt DESC');
    return rows.map(SustainabilityProject.fromMap).toList();
  }

  Future<SustainabilityProject?> getProject(String id) async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('projects', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : SustainabilityProject.fromMap(rows.first);
  }

  Future<void> saveProject(SustainabilityProject project) async {
    final db = await DatabaseService.instance.database;
    await db.insert('projects', project.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProject(String id) async {
    final db = await DatabaseService.instance.database;
    await db.delete('team_members', where: 'projectId = ?', whereArgs: [id]);
    await db.delete('project_documents', where: 'projectId = ?', whereArgs: [id]);
    await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TeamMember>> getTeam(String projectId) async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('team_members', where: 'projectId = ?', whereArgs: [projectId]);
    return rows.map(TeamMember.fromMap).toList();
  }

  Future<void> addTeamMember(TeamMember member) async {
    final db = await DatabaseService.instance.database;
    await db.insert('team_members', member.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeTeamMember(String id) async {
    final db = await DatabaseService.instance.database;
    await db.delete('team_members', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ProjectDocument>> getDocuments(String projectId) async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('project_documents', where: 'projectId = ?', whereArgs: [projectId], orderBy: 'uploadedAt DESC');
    return rows.map(ProjectDocument.fromMap).toList();
  }

  Future<void> addDocument(ProjectDocument document) async {
    final db = await DatabaseService.instance.database;
    await db.insert('project_documents', document.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}