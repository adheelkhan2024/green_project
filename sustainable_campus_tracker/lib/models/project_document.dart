class ProjectDocument {
  final String id;
  final String projectId;
  final String fileName;
  final String filePath;
  final String uploadedAt;

  const ProjectDocument({
    required this.id,
    required this.projectId,
    required this.fileName,
    required this.filePath,
    required this.uploadedAt,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'projectId': projectId,
        'fileName': fileName,
        'filePath': filePath,
        'uploadedAt': uploadedAt,
      };

  factory ProjectDocument.fromMap(Map<String, Object?> map) => ProjectDocument(
        id: map['id'] as String,
        projectId: map['projectId'] as String,
        fileName: map['fileName'] as String,
        filePath: map['filePath'] as String,
        uploadedAt: map['uploadedAt'] as String,
      );
}