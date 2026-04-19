class AiInsight {
  final String projectId;
  final String projectTitle;
  final int delayRisk;
  final int successScore;
  final double sustainabilityImpact;
  final String recommendation;
  final String summary;

  const AiInsight({
    required this.projectId,
    required this.projectTitle,
    required this.delayRisk,
    required this.successScore,
    required this.sustainabilityImpact,
    required this.recommendation,
    required this.summary,
  });
}