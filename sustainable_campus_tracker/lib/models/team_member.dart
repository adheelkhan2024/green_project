class TeamMember {
  final String id;
  final String projectId;
  final String name;
  final String role;
  final String contribution;

  const TeamMember({
    required this.id,
    required this.projectId,
    required this.name,
    required this.role,
    required this.contribution,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'projectId': projectId,
        'name': name,
        'role': role,
        'contribution': contribution,
      };

  factory TeamMember.fromMap(Map<String, Object?> map) => TeamMember(
        id: map['id'] as String,
        projectId: map['projectId'] as String,
        name: map['name'] as String,
        role: map['role'] as String,
        contribution: map['contribution'] as String,
      );
}