import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/sustainability_project.dart';

class ProjectCard extends StatelessWidget {
  final SustainabilityProject project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final due = DateFormat('dd MMM yyyy').format(DateTime.parse(project.dueDate));
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(project.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  Chip(label: Text(project.status)),
                ],
              ),
              const SizedBox(height: 8),
              Text(project.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: project.progress / 100, minHeight: 10, borderRadius: BorderRadius.circular(12)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${project.progress}% complete'),
                  Text('Due $due'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}