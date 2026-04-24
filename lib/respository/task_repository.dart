import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/task_model.dart';

class TaskRepository {
  final _supabase = Supabase.instance.client;

  Future<List<TaskModel>> fetchTasks(String workspaceId) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('workspace_id', workspaceId).order('created_at', ascending: false);

    return (response as List).map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<void> addTask({
    required String title,
    required String workspaceId,
    required String priority,
    required String description,
    required String dueDate,
  }) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) throw Exception("User not logged in");

    await _supabase.from('tasks').insert({
      'title': title,
      'workspace_id': workspaceId,
      'priority': priority.trim().toLowerCase(),
      'description': description,
      'due_date': dueDate,
      'created_by': userId,
      'assigned_to': userId,
      'status': 'pending',
    });
  }
  Future<void> deleteTask(String taskId) async {
    await _supabase
        .from('tasks')
        .delete()
        .eq('id', taskId);
  }
}