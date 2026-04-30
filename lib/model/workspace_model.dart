class WorkspaceModel {
  final String id;
  final String name;
  final String userId;
  final int? collaborator;

  WorkspaceModel({required this.id, required this.name, required this.userId,this.collaborator});

  factory WorkspaceModel.fromJson(Map<String, dynamic> map) {
    return WorkspaceModel(
      id: map['id'],
      name: map['name'],
      userId: map['user_id'],
      collaborator: map['collaborator'] ?? 0,
    );
  }
}