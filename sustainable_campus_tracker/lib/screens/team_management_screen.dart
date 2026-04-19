import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/team_member.dart';
import '../utils/validators.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final role = TextEditingController();
  final contribution = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    role.dispose();
    contribution.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgument = ModalRoute.of(context)?.settings.arguments;
    if (routeArgument is! String) {
      return const Scaffold(body: Center(child: Text('Project not found')));
    }
    final projectId = routeArgument;
    final controller = context.watch<AppController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Team Management')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text('Assign member', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Member name'), validator: (value) => Validators.requiredText(value, 'Name')),
                    const SizedBox(height: 12),
                    TextFormField(controller: role, decoration: const InputDecoration(labelText: 'Role'), validator: (value) => Validators.requiredText(value, 'Role')),
                    const SizedBox(height: 12),
                    TextFormField(controller: contribution, decoration: const InputDecoration(labelText: 'Contribution'), validator: (value) => Validators.requiredText(value, 'Contribution')),
                    const SizedBox(height: 14),
                    FilledButton.icon(onPressed: () => add(projectId), icon: const Icon(Icons.person_add_alt), label: const Text('Add member')),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<TeamMember>>(
            future: controller.getTeam(projectId),
            builder: (context, snapshot) {
              final team = snapshot.data ?? <TeamMember>[];
              if (team.isEmpty) return const Text('No team members assigned yet.');
              return Column(
                children: [
                  for (final member in team)
                    Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                        title: Text(member.name),
                        subtitle: Text('${member.role}\n${member.contribution}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await context.read<AppController>().removeTeamMember(member.id);
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> add(String projectId) async {
    if (!formKey.currentState!.validate()) return;
    await context.read<AppController>().addTeamMember(projectId, name.text, role.text, contribution.text);
    name.clear();
    role.clear();
    contribution.clear();
    if (mounted) setState(() {});
  }
}