import '../models/ai_insight.dart';
import '../models/sustainability_project.dart';
import '../models/team_member.dart';

class AiService {
  AiInsight analyze(SustainabilityProject project, List<TeamMember> team) {
    final now = DateTime.now();
    final start = DateTime.parse(project.startDate);
    final due = DateTime.parse(project.dueDate);
    final totalDays = due.difference(start).inDays.abs().clamp(1, 999).toInt();
    final elapsedDays = now.difference(start).inDays.clamp(0, totalDays).toInt();
    final expectedProgress = ((elapsedDays / totalDays) * 100).round();
    final progressGap = expectedProgress - project.progress;
    final teamPenalty = team.length < 3 ? 15 : 0;
    final deadlinePenalty = due.difference(now).inDays < 14 && project.progress < 75 ? 18 : 0;
    final delayRisk = (progressGap + teamPenalty + deadlinePenalty).clamp(0, 100).toInt();
    final successScore = (100 - delayRisk + (team.length * 3) + (project.progress ~/ 8)).clamp(0, 100).toInt();
    final categoryMultiplier = switch (project.category) {
      'Energy' => 1.35,
      'Waste' => 1.15,
      'Water' => 1.25,
      'Transport' => 1.3,
      _ => 1.0,
    };
    final impact = project.estimatedCo2Reduction * categoryMultiplier * (project.progress / 100);
    final recommendation = _recommendation(delayRisk, project.progress, team.length);
    final summary = 'Expected progress is $expectedProgress%, actual progress is ${project.progress}%. '
        'The model estimates a $delayRisk% delay risk and $successScore% completion confidence.';
    return AiInsight(
      projectId: project.id,
      projectTitle: project.title,
      delayRisk: delayRisk,
      successScore: successScore,
      sustainabilityImpact: double.parse(impact.toStringAsFixed(1)),
      recommendation: recommendation,
      summary: summary,
    );
  }

  String _recommendation(int delayRisk, int progress, int teamSize) {
    if (delayRisk > 65) return 'High delay risk. Add weekly milestones, assign more contributors, and reduce scope for the next sprint.';
    if (teamSize < 3) return 'Team capacity is low. Assign at least one coordinator and one implementation member.';
    if (progress < 35) return 'Progress is early. Confirm materials, ownership, and blockers before the next review.';
    return 'Project is healthy. Continue monitoring progress and document evidence for the sustainability report.';
  }
}