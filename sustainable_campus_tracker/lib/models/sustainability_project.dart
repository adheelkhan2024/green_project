class SustainabilityProject {
  final String id;
  final String title;
  final String description;
  final String status;
  final int progress;
  final String category;
  final String startDate;
  final String dueDate;
  final String createdBy;
  final String location;
  final double budget;
  final double estimatedCo2Reduction;
  final String updatedAt;

  const SustainabilityProject({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.category,
    required this.startDate,
    required this.dueDate,
    required this.createdBy,
    required this.location,
    required this.budget,
    required this.estimatedCo2Reduction,
    required this.updatedAt,
  });

  SustainabilityProject copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    int? progress,
    String? category,
    String? startDate,
    String? dueDate,
    String? createdBy,
    String? location,
    double? budget,
    double? estimatedCo2Reduction,
    String? updatedAt,
  }) {
    return SustainabilityProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      createdBy: createdBy ?? this.createdBy,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      estimatedCo2Reduction: estimatedCo2Reduction ?? this.estimatedCo2Reduction,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'progress': progress,
        'category': category,
        'startDate': startDate,
        'dueDate': dueDate,
        'createdBy': createdBy,
        'location': location,
        'budget': budget,
        'estimatedCo2Reduction': estimatedCo2Reduction,
        'updatedAt': updatedAt,
      };

  factory SustainabilityProject.fromMap(Map<String, Object?> map) => SustainabilityProject(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        status: map['status'] as String,
        progress: map['progress'] as int,
        category: map['category'] as String,
        startDate: map['startDate'] as String,
        dueDate: map['dueDate'] as String,
        createdBy: map['createdBy'] as String,
        location: map['location'] as String,
        budget: (map['budget'] as num).toDouble(),
        estimatedCo2Reduction: (map['estimatedCo2Reduction'] as num).toDouble(),
        updatedAt: map['updatedAt'] as String,
      );
}