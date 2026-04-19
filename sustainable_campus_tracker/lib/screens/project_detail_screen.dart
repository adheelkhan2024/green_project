import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/project_document.dart';
import '../models/sustainability_project.dart';
import '../models/team_member.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final project = _findProject(controller);
    if (project == null) return const Scaffold(body: Center(child: Text('Project not found')));
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/project-form', arguments: project),
            icon: const Icon(Icons.edit_outlined),
          ),
          if (controller.currentUser?.isAdmin ?? false)
            IconButton(
              onPressed: () async {
                await controller.deleteProject(project.id);
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _ProjectSummary(project: project),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/team', arguments: project.id),
            icon: const Icon(Icons.group_outlined),
            label: const Text('Manage team'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => controller.uploadDocument(project.id),
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload PDF or image'),
          ),
          const SizedBox(height: 18),
          FutureBuilder<List<TeamMember>>(
            future: controller.getTeam(project.id),
            builder: (context, snapshot) {
              final team = snapshot.data ?? <TeamMember>[];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Team members', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  if (team.isEmpty) const Text('No members assigned yet.'),
                  for (final member in team)
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                      title: Text(member.name),
                      subtitle: Text('${member.role} • ${member.contribution}'),
                    ),
                  const SizedBox(height: 18),
                  FutureBuilder<List<ProjectDocument>>(
                    future: controller.getDocuments(project.id),
                    builder: (context, documentSnapshot) {
                      final docs = documentSnapshot.data ?? <ProjectDocument>[];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Documents', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          if (docs.isEmpty) const Text('No supporting documents uploaded.'),
                          for (final document in docs)
                            ListTile(
                              leading: const Icon(Icons.description_outlined),
                              title: Text(document.fileName),
                              subtitle: Text(DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(document.uploadedAt))),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  SustainabilityProject? _findProject(AppController controller) {
    for (final project in controller.projects) {
      if (project.id == projectId) return project;
    }
    return null;
  }
}

class _ProjectSummary extends StatelessWidget {
  final SustainabilityProject project;

  const _ProjectSummary({required this.project});

  @override
  Widget build(BuildContext context) {
    final due = DateFormat('dd MMM yyyy').format(DateTime.parse(project.dueDate));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(project.category)),
            const SizedBox(height: 10),
            Text(project.description),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: project.progress / 100, minHeight: 12),
            const SizedBox(height: 10),
            Text('${project.progress}% complete • ${project.status}'),
            const Divider(height: 28),
            Text('Location: ${project.location}'),
            Text('Due date: $due'),
            Text('Budget: R${project.budget.toStringAsFixed(0)}'),
            Text('Estimated CO2 reduction: ${project.estimatedCo2Reduction.toStringAsFixed(1)} tons'),
          ],
        ),
      ),
    );
  }
}