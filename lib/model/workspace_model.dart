class WorkspaceModel {
  final String id;
  final String name;
  final String userId;

  WorkspaceModel({required this.id, required this.name, required this.userId});

  factory WorkspaceModel.fromMap(Map<String, dynamic> map) {
    return WorkspaceModel(
      id: map['id'],
      name: map['name'],
      userId: map['user_id'],
    );
  }
}