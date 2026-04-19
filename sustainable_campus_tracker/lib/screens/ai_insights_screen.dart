import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/ai_insight.dart';
import '../widgets/app_shell.dart';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return AppShell(
      title: 'AI Insights',
      child: FutureBuilder<List<AiInsight>>(
        future: controller.getAiInsights(),
        builder: (context, snapshot) {
          final insights = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (insights.isEmpty) return const Center(child: Text('Create projects to generate AI insights.'));
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI model explanation', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      const Text('This app uses a transparent rule-based AI model that compares expected progress, actual progress, deadline pressure, team capacity, category, and estimated CO2 reduction to predict delay risk, completion confidence, and sustainability impact.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (final insight in insights) _InsightCard(insight: insight),
            ],
          );
        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final AiInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insight.projectTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            _Score(label: 'Delay risk', value: insight.delayRisk, color: insight.delayRisk > 60 ? Colors.red : Colors.orange),
            const SizedBox(height: 10),
            _Score(label: 'Completion success', value: insight.successScore, color: const Color(0xFF168257)),
            const SizedBox(height: 14),
            Text('Estimated impact: ${insight.sustainabilityImpact} tons CO2 reduction', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(insight.summary),
            const SizedBox(height: 10),
            Text(insight.recommendation, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _Score extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Score({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value%'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: value / 100, minHeight: 10, color: color, borderRadius: BorderRadius.circular(12)),
      ],
    );
  }
}