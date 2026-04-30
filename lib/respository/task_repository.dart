import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/tasks_model.dart';

class TaskRepository {
  final _supabase = Supabase.instance.client;

  Future<List<TaskModel>> fetchTasks(String workspaceId) async {
    final response = await _supabase
        .from('tasks')
        .select().eq('workspace_id', workspaceId).eq('created_by', _supabase.auth.currentUser!.id);

    return (response as List).map((task) => TaskModel.fromJson(task)).toList();
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
  Future<void> updateTaskTitle(String taskId, String newTitle) async {
    await _supabase.from('tasks').update({'title': newTitle}).eq('id', taskId);
  }
  Future<void> updateTaskPriority(String taskId,String priority) async{
    await _supabase.from('tasks').update({'priority': priority}).eq('id', taskId);
  }
  Future<void> updateTaskStatus(String id,String status) async{
    await _supabase.from('tasks').update({'status': status}).eq('id', id);
  }
  Future<void> updateTaskDescription(String taskId,String description) async{
    await _supabase.from('tasks').update({'description': description}).eq('id', taskId);
  }
}