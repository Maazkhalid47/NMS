class TaskModel {
  final String id;
  final String title;
  final String status;
  final String workspaceId;
  final String priority;
  final String? description;
  final String dueDate;
  final DateTime created_at;

  TaskModel({
    required this.id,
    this.description,
    required this.dueDate,
    required this.title,
    required this.status,
    required this.workspaceId,
    required this.created_at,
    required this.priority,});

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      priority: map['priority'] ?? 'medium',
      dueDate: map['due_date'] ?? '',
      status: map['status'] ?? 'pending',
      workspaceId: map['workspace_id'] ?? '',
      created_at: DateTime.parse(map['created_at'] ?? DateTime.now().toString())
    );
  }
  TaskModel copyWith({String? status, String? title, String? priority,String? description}){
    return TaskModel(
        id: this.id,
        dueDate: this.dueDate,
        title: title ?? this.title,
        status: status ?? this.status,
        workspaceId: this.workspaceId,
        created_at: this.created_at,
        priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }
}