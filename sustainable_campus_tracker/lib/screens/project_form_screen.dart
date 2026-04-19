import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/sustainability_project.dart';
import '../utils/validators.dart';

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final budget = TextEditingController(text: '10000');
  final co2 = TextEditingController(text: '10');
  String status = 'Planning';
  String category = 'Energy';
  double progress = 10;
  DateTime startDate = DateTime.now();
  DateTime dueDate = DateTime.now().add(const Duration(days: 30));
  SustainabilityProject? editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (editing == null && arg is SustainabilityProject) {
      editing = arg;
      title.text = arg.title;
      description.text = arg.description;
      location.text = arg.location;
      budget.text = arg.budget.toStringAsFixed(0);
      co2.text = arg.estimatedCo2Reduction.toStringAsFixed(1);
      status = arg.status;
      category = arg.category;
      progress = arg.progress.toDouble();
      startDate = DateTime.parse(arg.startDate);
      dueDate = DateTime.parse(arg.dueDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editing == null ? 'Create project' : 'Edit project')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            TextFormField(controller: title, decoration: const InputDecoration(labelText: 'Project title'), validator: (value) => Validators.requiredText(value, 'Title')),
            const SizedBox(height: 12),
            TextFormField(controller: description, decoration: const InputDecoration(labelText: 'Description'), minLines: 3, maxLines: 5, validator: (value) => Validators.requiredText(value, 'Description')),
            const SizedBox(height: 12),
            TextFormField(controller: location, decoration: const InputDecoration(labelText: 'Campus location'), validator: (value) => Validators.requiredText(value, 'Location')),
            const SizedBox(height: 12),
            DropdownButtonFormField(value: category, decoration: const InputDecoration(labelText: 'Category'), items: ['Energy', 'Waste', 'Water', 'Transport', 'Biodiversity'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setState(() => category = value ?? category)),
            const SizedBox(height: 12),
            DropdownButtonFormField(value: status, decoration: const InputDecoration(labelText: 'Status'), items: ['Planning', 'In Progress', 'Blocked', 'Completed'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setState(() => status = value ?? status)),
            const SizedBox(height: 12),
            Text('Progress: ${progress.round()}%'),
            Slider(value: progress, min: 0, max: 100, divisions: 20, label: '${progress.round()}%', onChanged: (value) => setState(() => progress = value)),
            const SizedBox(height: 12),
            TextFormField(controller: budget, decoration: const InputDecoration(labelText: 'Budget in R'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextFormField(controller: co2, decoration: const InputDecoration(labelText: 'Estimated CO2 reduction in tons'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => pickDate(true), child: Text('Start: ${startDate.toLocal().toString().split(' ').first}'))),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton(onPressed: () => pickDate(false), child: Text('Due: ${dueDate.toLocal().toString().split(' ').first}'))),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: save, child: const Text('Save project')),
          ],
        ),
      ),
    );
  }

  Future<void> pickDate(bool start) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1200)),
      initialDate: start ? startDate : dueDate,
    );
    if (picked != null) {
      setState(() {
        if (start) {
          startDate = picked;
        } else {
          dueDate = picked;
        }
      });
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    await context.read<AppController>().saveProject(
          id: editing?.id,
          title: title.text,
          description: description.text,
          status: status,
          progress: progress.round(),
          category: category,
          startDate: startDate.toIso8601String(),
          dueDate: dueDate.toIso8601String(),
          location: location.text,
          budget: double.tryParse(budget.text) ?? 0,
          estimatedCo2Reduction: double.tryParse(co2.text) ?? 0,
        );
    if (mounted) Navigator.pop(context);
  }
}