import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_insight.dart';
import '../models/app_user.dart';
import '../models/notification_item.dart';
import '../models/project_document.dart';
import '../models/sustainability_project.dart';
import '../models/team_member.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/project_service.dart';
import '../utils/validators.dart';

class AppController extends ChangeNotifier {
  final authService = AuthService();
  final projectService = ProjectService();
  final notificationService = NotificationService();
  final aiService = AiService();
  final _uuid = const Uuid();

  bool isLoading = true;
  AppUser? currentUser;
  List<SustainabilityProject> projects = [];
  List<NotificationItem> notifications = [];

  Future<void> bootstrap() async {
    await authService.seedDemoUsers();
    isLoading = false;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    final user = await authService.login(email, password);
    if (user == null) return 'Invalid email or password';
    currentUser = user;
    await projectService.seedProjects(user.id);
    await refresh();
    return null;
  }

  Future<String?> register(String name, String email, String password, String role) async {
    try {
      currentUser = await authService.register(
        name: Validators.clean(name),
        email: Validators.clean(email),
        password: password,
        role: role,
      );
      await notificationService.add('Welcome', 'Your account has been created as $role.');
      await refresh();
      return null;
    } catch (_) {
      return 'This email may already be registered';
    }
  }

  void logout() {
    currentUser = null;
    projects = [];
    notifications = [];
    notifyListeners();
  }

  Future<void> refresh() async {
    projects = await projectService.getProjects();
    notifications = await notificationService.getNotifications();
    notifyListeners();
  }

  Future<void> saveProject({
    String? id,
    required String title,
    required String description,
    required String status,
    required int progress,
    required String category,
    required String startDate,
    required String dueDate,
    required String location,
    required double budget,
    required double estimatedCo2Reduction,
  }) async {
    final project = SustainabilityProject(
      id: id ?? _uuid.v4(),
      title: Validators.clean(title),
      description: Validators.clean(description),
      status: status,
      progress: progress,
      category: category,
      startDate: startDate,
      dueDate: dueDate,
      createdBy: currentUser?.id ?? 'local',
      location: Validators.clean(location),
      budget: budget,
      estimatedCo2Reduction: estimatedCo2Reduction,
      updatedAt: DateTime.now().toIso8601String(),
    );
    await projectService.saveProject(project);
    await notificationService.add(id == null ? 'Project created' : 'Project updated', project.title);
    await refresh();
  }

  Future<void> deleteProject(String id) async {
    await projectService.deleteProject(id);
    await notificationService.add('Project deleted', 'A project and its related records were removed.');
    await refresh();
  }

  Future<List<TeamMember>> getTeam(String projectId) => projectService.getTeam(projectId);

  Future<List<ProjectDocument>> getDocuments(String projectId) => projectService.getDocuments(projectId);

  Future<void> addTeamMember(String projectId, String name, String role, String contribution) async {
    await projectService.addTeamMember(TeamMember(
      id: _uuid.v4(),
      projectId: projectId,
      name: Validators.clean(name),
      role: Validators.clean(role),
      contribution: Validators.clean(contribution),
    ));
    await notificationService.add('Team updated', '$name was assigned to a project.');
    await refresh();
  }

  Future<void> removeTeamMember(String id) async {
    await projectService.removeTeamMember(id);
    await notificationService.add('Team updated', 'A member was removed from a project.');
    await refresh();
  }

  Future<void> uploadDocument(String projectId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    await projectService.addDocument(ProjectDocument(
      id: _uuid.v4(),
      projectId: projectId,
      fileName: file.name,
      filePath: file.path ?? file.name,
      uploadedAt: DateTime.now().toIso8601String(),
    ));
    await notificationService.add('Document uploaded', '${file.name} was attached to a project.');
    await refresh();
  }

  Future<List<AiInsight>> getAiInsights() async {
    final result = <AiInsight>[];
    for (final project in projects) {
      final team = await projectService.getTeam(project.id);
      result.add(aiService.analyze(project, team));
    }
    return result;
  }

  int get unreadNotifications => notifications.where((item) => item.read == 0).length;
}