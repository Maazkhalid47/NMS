class TaskModel {
  final String id;
  final String title;
  final String status;
  final String workspaceId;
  final String priority;

  TaskModel({required this.id, required this.title, required this.status, required this.workspaceId, required this.priority});

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      status: map['status'] ?? 'pending',
      workspaceId: map['workspace_id'].toString(),
      priority: map['priority'] ?? 'medium',

    );
  }
}