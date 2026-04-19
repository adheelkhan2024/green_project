import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/project_card.dart';
import 'project_detail_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return AppShell(
      title: 'Projects',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/project-form'),
        icon: const Icon(Icons.add),
        label: const Text('New project'),
      ),
      child: controller.projects.isEmpty
          ? const Center(child: Text('No projects yet. Create the first sustainability initiative.'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: controller.projects.length,
              itemBuilder: (context, index) {
                final project = controller.projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id))),
                );
              },
            ),
    );
  }
}