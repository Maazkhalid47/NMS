import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/task_model.dart';
import '../model/workspace_model.dart';
import '../respository/task_repository.dart';
import '../respository/task_repository.dart' as _taskRepo;
import '../respository/workspace_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final WorkspaceRepository _workspaceRepo = WorkspaceRepository();
  final TaskRepository _taskRepo = TaskRepository();
  final supabase = Supabase.instance.client;

  List<WorkspaceModel> workspaces = [];
  List<TaskModel> tasks = [];
  bool isLoading = false;
  String? _selectedWorkspaceId;

  String? get selectedWorkspaceId => _selectedWorkspaceId;

  int get pendingCount =>
      tasks
          .where((t) => t.status?.toLowerCase() == 'pending')
          .length;

  int get completedCount =>
      tasks
          .where((t) => t.status?.toLowerCase() == 'completed')
          .length;

  String get selectedWorkspaceName {
    if (_selectedWorkspaceId == null || workspaces.isEmpty)
      return 'No Workspace';
    return workspaces
        .firstWhere((ws) => ws.id == _selectedWorkspaceId)
        .name;
  }

  Future<void> getWorkspaces() async {
    isLoading = true;
    notifyListeners();
    try {
      workspaces = await _workspaceRepo.fetchWorkspaces();

      if (workspaces.isNotEmpty) {
        _selectedWorkspaceId = workspaces.first.id;
        debugPrint("AUTO-SELECTED ID: $_selectedWorkspaceId");
        await fetchTasksForWorkspace(_selectedWorkspaceId!);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectWorkspaces(String id) {
    _selectedWorkspaceId = id;
    fetchTasksForWorkspace(id);
    notifyListeners();
  }

  Future<void> fetchTasksForWorkspace(String workspaceId) async {
    tasks = await _taskRepo.fetchTasks(workspaceId);
    notifyListeners();
  }

  Future<void> createNewTask({
    required String title,
    required String workspaceId,
    String description = "",
    String priority = "medium",
    required String dueDate,
  }) async {
    try {
      await _taskRepo.addTask(
        title: title,
        workspaceId: workspaceId,
        priority: priority,
        description: description,
        dueDate: dueDate,
      );
      print("TASK ADDED SUCCESSFULLY!");

      await Future.delayed(const Duration(milliseconds: 500));
      await fetchTasksForWorkspace(workspaceId);
    } catch (e) {
      debugPrint("DATABASE ERROR: $e");
    }
  }

  Future<void> createNewWorkspace(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('workspaces').insert({
        'name': name,
        'user_id': user.id,
      });
      await getWorkspaces();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepo.deleteTask(taskId);

      await fetchTasksForWorkspace(selectedWorkspaceId!);
    } catch (e) {
      print("Delete Error: $e");
    }
  }
}
// final userId = supabase.auth.currentUser?.id;
//
// if (userId == null) {
//
// debugPrint("USER NOT LOGGED IN");
//
// return;
//
// }