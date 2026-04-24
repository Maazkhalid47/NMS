import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/task_model.dart';

class TaskRepository {
  final _supabase = Supabase.instance.client;

  Future<List<TaskModel>> fetchTasks(String workspaceId) async {
    final response = await _supabase.from('tasks').select().eq(
        'workspace_id', workspaceId);

    return (response as List).map((task) => TaskModel.fromMap(task)).toList();
  }
  Future<void> addTask({
    required String title,
    required String workspaceId,
    required String priority,
    String description = "",
    String? dueDate,
  }) async {
    final user = _supabase.auth.currentUser;

    await _supabase.from('tasks').insert({
      'title': title,
      'workspace_id': workspaceId,
      'priority': priority,
      'description': description,
      'due_date': dueDate,
      'created_by': user?.id,
      'status': 'pending',
    });
  }
  }