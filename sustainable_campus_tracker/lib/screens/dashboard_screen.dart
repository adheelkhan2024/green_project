import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/project_card.dart';
import 'project_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final projects = controller.projects;
    final average = projects.isEmpty ? 0 : projects.map((p) => p.progress).reduce((a, b) => a + b) ~/ projects.length;
    final active = projects.where((p) => p.status != 'Completed').length;
    return AppShell(
      title: 'Dashboard',
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text('Welcome, ${controller.currentUser?.name ?? 'Student'}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricCard(label: 'Projects', value: '${projects.length}', icon: Icons.eco_outlined),
                const SizedBox(width: 12),
                _MetricCard(label: 'Active', value: '$active', icon: Icons.task_alt_outlined),
                const SizedBox(width: 12),
                _MetricCard(label: 'Avg Progress', value: '$average%', icon: Icons.trending_up),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress overview', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(leftTitles: AxisTitles(), rightTitles: AxisTitles(), topTitles: AxisTitles(), bottomTitles: AxisTitles()),
                          barGroups: [
                            for (int i = 0; i < projects.length; i++)
                              BarChartGroupData(x: i, barRods: [BarChartRodData(toY: projects[i].progress.toDouble(), color: const Color(0xFF168257), width: 18, borderRadius: BorderRadius.circular(6))]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Recent projects', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            for (final project in projects.take(3))
              ProjectCard(
                project: project,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id))),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF168257)),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}