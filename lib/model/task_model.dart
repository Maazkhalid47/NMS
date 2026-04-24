class TaskModel {
  final String id;
  final String title;
  final String status;
  final String workspaceId;
  final String priority;
  final String? description;
  final String dueDate;

  TaskModel({
    required this.id,
    this.description,
    required this.dueDate,
    required this.title,
    required this.status,
    required this.workspaceId,
    required this.priority});

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      priority: map['priority'] ?? 'medium',
      dueDate: map['due_date'] ?? '',
      status: map['status'] ?? 'pending',
      workspaceId: map['workspace_id'] ?? '',
    );
  }
}